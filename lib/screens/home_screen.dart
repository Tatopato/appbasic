import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../constants/minimal_ui.dart';
import '../data/anime_catalog.dart';
import '../services/user_data_service.dart';

/// Home: greeting, trending anime (favorite with the heart) and the public
/// community feed. Posts from every account appear here in real time;
/// favorites stay private under the account's uid.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _service = UserDataService.instance;

  late final Stream<UserProfile> _profile = _service.profileStream();
  late final Stream<Set<String>> _favorites = _service.favoriteIdsStream();
  late final Stream<List<UserPost>> _posts = _service.feedStream();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Mi.bg,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            _buildHeader(),
            const SizedBox(height: 28),
            const MiSectionHeader(title: 'Trending'),
            const SizedBox(height: 12),
            _buildTrending(),
            const SizedBox(height: 28),
            MiSectionHeader(
              title: 'Community',
              actionLabel: '+ New post',
              onAction: _openNewPost,
            ),
            const SizedBox(height: 12),
            _buildPosts(),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------- header

  Widget _buildHeader() {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder<UserProfile>(
      stream: _profile,
      initialData: user == null ? null : UserProfile.fromData(null, user),
      builder: (context, snapshot) {
        final profile = snapshot.data;
        return Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hello,', style: Mi.caption()),
                  Text(
                    profile?.displayName ?? 'Anime Fan',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Mi.title(size: 26),
                  ),
                ],
              ),
            ),
            if (profile != null) UserAvatar(profile: profile, size: 46),
          ],
        );
      },
    );
  }

  // -------------------------------------------------------------- trending

  Widget _buildTrending() {
    return StreamBuilder<Set<String>>(
      stream: _favorites,
      builder: (context, snapshot) {
        if (snapshot.hasError) return const MiDataError();
        final favorites = snapshot.data ?? const <String>{};
        return SizedBox(
          height: 275,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: animeCatalog.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final anime = animeCatalog[index];
              return SizedBox(
                width: 128,
                child: AnimeTile(
                  anime: anime,
                  isFavorite: favorites.contains(anime.id),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // ----------------------------------------------------------------- posts

  Widget _buildPosts() {
    return StreamBuilder<List<UserPost>>(
      stream: _posts,
      builder: (context, snapshot) {
        if (snapshot.hasError) return const MiDataError();
        if (!snapshot.hasData) return const MiLoading();

        final posts = snapshot.data!;
        if (posts.isEmpty) {
          return MiEmpty(
            icon: Icons.edit_note_rounded,
            text: "No posts yet.\nBe the first to share something.",
            actionLabel: 'Write a post',
            onAction: _openNewPost,
          );
        }
        return Column(
          children: [
            for (final post in posts) ...[
              _PostCard(
                post: post,
                onDelete: () => _deletePost(post),
              ),
              const SizedBox(height: 14),
            ],
          ],
        );
      },
    );
  }

  Future<void> _deletePost(UserPost post) async {
    try {
      await _service.deletePost(post);
    } catch (_) {
      if (mounted) miSnack(context, "Couldn't delete the post.");
    }
  }

  void _openNewPost() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Mi.surface,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _NewPostSheet(),
    );
  }
}

// ---------------------------------------------------------------------------
// Post card
// ---------------------------------------------------------------------------

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post, required this.onDelete});

  final UserPost post;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final anime = animeById(post.animeId);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: Mi.card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author row
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 6, 10),
            child: Row(
              children: [
                UserAvatar(profile: post.author, size: 36),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.authorName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Mi.body(weight: FontWeight.w700),
                      ),
                      Text(timeAgo(post.createdAt), style: Mi.caption()),
                    ],
                  ),
                ),
                if (post.isMine)
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_horiz_rounded,
                        size: 20, color: Mi.sub),
                    padding: EdgeInsets.zero,
                    color: Mi.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    onSelected: (value) {
                      if (value == 'delete') onDelete();
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: 'delete',
                        child: Text(
                          'Delete',
                          style: Mi.body(color: Mi.danger),
                        ),
                      ),
                    ],
                  )
                else
                  const SizedBox(width: 8),
              ],
            ),
          ),
          // Uploaded photo, or the tagged anime poster
          if (post.imageBase64 != null)
            _PostImage(base64: post.imageBase64!)
          else if (anime != null)
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.asset(
                anime.image,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                errorBuilder: (_, __, ___) => Container(color: Mi.line),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (anime != null)
                  Text(
                    '#${anime.title}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Mi.body(
                      size: 12,
                      color: Mi.accent,
                      weight: FontWeight.w700,
                    ),
                  ),
                if (post.caption.isNotEmpty) ...[
                  if (anime != null) const SizedBox(height: 4),
                  Text(post.caption, style: Mi.body(size: 14)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Decodes the base64 photo once (not on every rebuild of the feed).
class _PostImage extends StatefulWidget {
  const _PostImage({required this.base64});

  final String base64;

  @override
  State<_PostImage> createState() => _PostImageState();
}

class _PostImageState extends State<_PostImage> {
  late Uint8List? _bytes = _decode(widget.base64);

  static Uint8List? _decode(String data) {
    try {
      return base64Decode(data);
    } catch (_) {
      return null;
    }
  }

  @override
  void didUpdateWidget(covariant _PostImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.base64 != widget.base64) _bytes = _decode(widget.base64);
  }

  @override
  Widget build(BuildContext context) {
    final bytes = _bytes;
    if (bytes == null) {
      return AspectRatio(
        aspectRatio: 4 / 3,
        child: Container(
          color: Mi.line,
          alignment: Alignment.center,
          child: const Icon(Icons.broken_image_outlined, color: Mi.sub),
        ),
      );
    }
    return Image.memory(
      bytes,
      width: double.infinity,
      fit: BoxFit.cover,
      gaplessPlayback: true,
    );
  }
}

// ---------------------------------------------------------------------------
// New post sheet
// ---------------------------------------------------------------------------

class _NewPostSheet extends StatefulWidget {
  const _NewPostSheet();

  @override
  State<_NewPostSheet> createState() => _NewPostSheetState();
}

class _NewPostSheetState extends State<_NewPostSheet> {
  final TextEditingController _caption = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  String? _animeId;
  XFile? _image;
  bool _saving = false;

  bool get _canPost =>
      !_saving &&
      (_caption.text.trim().isNotEmpty || _animeId != null || _image != null);

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        maxWidth: 900,
        imageQuality: 60,
      );
      if (picked != null && mounted) setState(() => _image = picked);
    } catch (_) {
      if (mounted) miSnack(context, "Couldn't open the photo picker.");
    }
  }

  void _chooseImageSource() {
    // The camera is only offered on phones; web/desktop use the file picker.
    if (kIsWeb) {
      _pickImage(ImageSource.gallery);
      return;
    }
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Mi.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text('Choose from gallery', style: Mi.body()),
              onTap: () {
                Navigator.pop(sheetContext);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text('Take a photo', style: Mi.body()),
              onTap: () {
                Navigator.pop(sheetContext);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _caption.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _caption.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _saving = true);
    try {
      await UserDataService.instance.addPost(
        caption: _caption.text,
        animeId: _animeId,
        image: _image,
      );
      if (mounted) Navigator.of(context).pop();
    } on FormatException {
      if (mounted) {
        setState(() {
          _saving = false;
          _image = null;
        });
        miSnack(context, 'That photo is too large. Please pick a smaller one.');
      }
    } catch (_) {
      if (mounted) {
        setState(() => _saving = false);
        miSnack(context, "Couldn't post. Please try again.");
      }
    }
  }

  Widget _buildPhotoPicker() {
    final image = _image;
    if (image == null) {
      return OutlinedButton.icon(
        onPressed: _saving ? null : _chooseImageSource,
        style: OutlinedButton.styleFrom(
          foregroundColor: Mi.text,
          side: const BorderSide(color: Mi.line),
          backgroundColor: Mi.bg,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        icon: const Icon(Icons.add_photo_alternate_outlined, size: 20),
        label: Text(
          'Add a photo',
          style: Mi.body(weight: FontWeight.w700),
        ),
      );
    }
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            // XFile.path is a blob URL on web and a file path elsewhere.
            child: FutureBuilder<Uint8List>(
              future: image.readAsBytes(),
              builder: (context, snapshot) => snapshot.hasData
                  ? Image.memory(snapshot.data!, fit: BoxFit.cover)
                  : Container(color: Mi.line),
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: _saving ? null : () => setState(() => _image = null),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close_rounded,
                  size: 18, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('New post', style: Mi.title(size: 20)),
            const SizedBox(height: 16),
            Text('Photo (optional)', style: Mi.caption()),
            const SizedBox(height: 8),
            _buildPhotoPicker(),
            const SizedBox(height: 16),
            Text('Tag an anime (optional)', style: Mi.caption()),
            const SizedBox(height: 8),
            SizedBox(
              height: 96,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: animeCatalog.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final anime = animeCatalog[index];
                  final selected = anime.id == _animeId;
                  return GestureDetector(
                    onTap: () => setState(
                      () => _animeId = selected ? null : anime.id,
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 64,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selected ? Mi.accent : Colors.transparent,
                          width: 2.5,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(9.5),
                        child: Image.asset(
                          anime.image,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Container(color: Mi.line),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _caption,
              minLines: 3,
              maxLines: 5,
              maxLength: 280,
              style: Mi.body(),
              cursorColor: Mi.accent,
              decoration: InputDecoration(
                hintText: "What's on your mind about anime today?",
                hintStyle: Mi.body(color: Mi.sub),
                filled: true,
                fillColor: Mi.bg,
                counterStyle: Mi.caption(),
                contentPadding: const EdgeInsets.all(16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Mi.accent, width: 1.4),
                ),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _canPost ? _submit : null,
              style: FilledButton.styleFrom(
                backgroundColor: Mi.accent,
                disabledBackgroundColor: Mi.line,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: _saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      'Post',
                      style: Mi.body(
                        size: 15,
                        color: _canPost ? Colors.white : Mi.sub,
                        weight: FontWeight.w700,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
