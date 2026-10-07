import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

/// Everything below is stored under `users/{uid}` where `uid` is the account
/// that is currently signed in, so every account has its own separate data:
///
///   users/{uid}                 profile (name, bio, avatar, recent searches)
///   users/{uid}/favorites/{id}  favorited anime (doc id = anime id)
///
/// Posts are public and shared by everyone, so they live in a top-level
/// collection (readable by all signed-in users, real time):
///
///   posts/{id}                  caption, uid, author info, imageBase64, ...
///
/// Images are shrunk on the device and stored inside the post document as
/// base64 text, so Firebase Storage (paid plan) is not needed.
class UserProfile {
  const UserProfile({
    required this.displayName,
    required this.email,
    required this.bio,
    required this.avatar,
    required this.photoUrl,
    required this.recentSearches,
  });

  final String displayName;
  final String email;
  final String bio;

  /// Asset path chosen by the user, or null.
  final String? avatar;

  /// Photo from the sign-in provider (Google/Facebook/GitHub), or null.
  final String? photoUrl;
  final List<String> recentSearches;

  factory UserProfile.fromData(Map<String, dynamic>? data, User user) {
    final saved = (data?['displayName'] as String?)?.trim() ?? '';
    final authName = user.displayName?.trim() ?? '';
    final emailName = (user.email ?? '').split('@').first;

    return UserProfile(
      displayName: saved.isNotEmpty
          ? saved
          : authName.isNotEmpty
              ? authName
              : emailName.isNotEmpty
                  ? emailName
                  : 'Anime Fan',
      email: user.email ?? '',
      bio: (data?['bio'] as String?) ?? '',
      avatar: data?['avatar'] as String?,
      photoUrl: user.photoURL,
      recentSearches:
          List<String>.from((data?['recentSearches'] as List?) ?? const []),
    );
  }
}

class UserPost {
  const UserPost({
    required this.id,
    required this.uid,
    required this.authorName,
    required this.authorAvatar,
    required this.authorPhotoUrl,
    required this.caption,
    required this.animeId,
    required this.imageBase64,
    required this.createdAt,
  });

  final String id;

  /// Account that wrote the post.
  final String uid;
  final String authorName;
  final String? authorAvatar;
  final String? authorPhotoUrl;
  final String caption;
  final String? animeId;

  /// Photo from the device, shrunk and encoded as base64 text.
  final String? imageBase64;
  final DateTime createdAt;

  bool get isMine => FirebaseAuth.instance.currentUser?.uid == uid;

  /// Lets the shared [UserAvatar] widget draw the author.
  UserProfile get author => UserProfile(
        displayName: authorName,
        email: '',
        bio: '',
        avatar: authorAvatar,
        photoUrl: authorPhotoUrl,
        recentSearches: const [],
      );

  factory UserPost.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const <String, dynamic>{};
    return UserPost(
      id: doc.id,
      uid: (data['uid'] as String?) ?? '',
      authorName: (data['authorName'] as String?) ?? 'Anime Fan',
      authorAvatar: data['authorAvatar'] as String?,
      authorPhotoUrl: data['authorPhotoUrl'] as String?,
      caption: (data['caption'] as String?) ?? '',
      animeId: data['animeId'] as String?,
      imageBase64: data['imageBase64'] as String?,
      // Null while the server timestamp is still being written.
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}

class UserDataService {
  UserDataService._();
  static final UserDataService instance = UserDataService._();

  FirebaseFirestore get _db => FirebaseFirestore.instance;

  User get _user {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw StateError('No signed-in user.');
    return user;
  }

  DocumentReference<Map<String, dynamic>> get _doc =>
      _db.collection('users').doc(_user.uid);
  CollectionReference<Map<String, dynamic>> get _posts =>
      _db.collection('posts');
  CollectionReference<Map<String, dynamic>> get _favorites =>
      _doc.collection('favorites');

  // ---------------------------------------------------------------- profile

  /// Creates the profile document the first time an account signs in.
  Future<void> ensureProfile() async {
    final user = _user;
    final snap = await _doc.get();
    if (snap.exists) return;
    await _doc.set({
      'displayName': UserProfile.fromData(null, user).displayName,
      'email': user.email,
      'bio': '',
      'avatar': null,
      'recentSearches': <String>[],
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<UserProfile> profileStream() {
    final user = _user;
    return _doc
        .snapshots()
        .map((snap) => UserProfile.fromData(snap.data(), user));
  }

  Future<void> updateProfile({
    required String displayName,
    required String bio,
    required String? avatar,
  }) async {
    final user = _user;
    final name = displayName.trim();
    await _doc.set({
      'displayName': name,
      'bio': bio.trim(),
      'avatar': avatar,
    }, SetOptions(merge: true));
    if (name.isNotEmpty) {
      await user.updateDisplayName(name);
    }
  }

  // -------------------------------------------------------------- favorites

  Stream<Set<String>> favoriteIdsStream() {
    return _favorites
        .snapshots()
        .map((snap) => snap.docs.map((d) => d.id).toSet());
  }

  Future<void> setFavorite(String animeId, bool value) {
    final ref = _favorites.doc(animeId);
    if (value) {
      return ref.set({'addedAt': FieldValue.serverTimestamp()});
    }
    return ref.delete();
  }

  // ------------------------------------------------------------------ posts

  /// Public feed: everyone's posts, newest first, updated in real time.
  Stream<List<UserPost>> feedStream({int limit = 30}) {
    return _posts
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snap) => snap.docs.map(UserPost.fromDoc).toList());
  }

  /// Only this account's posts (used for the post counter on Profile).
  /// Sorted on the device so no composite index is needed.
  Stream<List<UserPost>> myPostsStream() {
    return _posts
        .where('uid', isEqualTo: _user.uid)
        .snapshots()
        .map((snap) {
      final list = snap.docs.map(UserPost.fromDoc).toList();
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list;
    });
  }

  /// Max size of the encoded photo. A Firestore document is limited to
  /// 1 MiB, so keep a safe margin for the text fields.
  static const int _maxImageBytes = 600 * 1024;

  Future<String> _encodeImage(XFile image) async {
    final bytes = await image.readAsBytes(); // works on mobile and web
    if (bytes.length > _maxImageBytes) {
      throw const FormatException('image-too-large');
    }
    return base64Encode(bytes);
  }

  Future<void> addPost({
    required String caption,
    String? animeId,
    XFile? image,
  }) async {
    final user = _user;
    final profileSnap = await _doc.get();
    final profile = UserProfile.fromData(profileSnap.data(), user);

    final imageBase64 = image == null ? null : await _encodeImage(image);

    await _posts.add({
      'uid': user.uid,
      'authorName': profile.displayName,
      'authorAvatar': profile.avatar,
      'authorPhotoUrl': profile.photoUrl,
      'caption': caption.trim(),
      'animeId': animeId,
      'imageBase64': imageBase64,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deletePost(UserPost post) => _posts.doc(post.id).delete();

  // ---------------------------------------------------------- recent search

  Future<void> addRecentSearch(String query) async {
    final term = query.trim();
    if (term.isEmpty) return;
    final snap = await _doc.get();
    final list =
        List<String>.from((snap.data()?['recentSearches'] as List?) ?? const []);
    list.removeWhere((e) => e.toLowerCase() == term.toLowerCase());
    list.insert(0, term);
    await _doc.set(
      {'recentSearches': list.take(8).toList()},
      SetOptions(merge: true),
    );
  }

  Future<void> clearRecentSearches() {
    return _doc.set(
      {'recentSearches': <String>[]},
      SetOptions(merge: true),
    );
  }
}
