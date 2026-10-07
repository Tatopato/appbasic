import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../constants/minimal_ui.dart';
import '../data/anime_catalog.dart';
import '../services/user_data_service.dart';
import 'login_screen.dart';

/// Profile: name, photo, bio, stats and favorites of the signed-in account.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _service = UserDataService.instance;

  late final Stream<UserProfile> _profile = _service.profileStream();
  late final Stream<Set<String>> _favorites = _service.favoriteIdsStream();
  late final Stream<List<UserPost>> _posts = _service.myPostsStream();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Mi.bg,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            Row(
              children: [
                Expanded(child: Text('Profile', style: Mi.title())),
                IconButton(
                  tooltip: 'Log out',
                  onPressed: _confirmLogOut,
                  style: IconButton.styleFrom(
                    backgroundColor: Mi.surface,
                    side: const BorderSide(color: Mi.line),
                  ),
                  icon: const Icon(Icons.logout_rounded,
                      size: 20, color: Mi.danger),
                ),
              ],
            ),
            const SizedBox(height: 24),
            StreamBuilder<UserProfile>(
              stream: _profile,
              initialData:
                  user == null ? null : UserProfile.fromData(null, user),
              builder: (context, snapshot) {
                final profile = snapshot.data;
                if (profile == null) return const MiLoading();
                return _buildHeader(profile);
              },
            ),
            const SizedBox(height: 24),
            _buildStats(),
            const SizedBox(height: 28),
            const MiSectionHeader(title: 'Favorites'),
            const SizedBox(height: 12),
            _buildFavorites(),
            const SizedBox(height: 28),
            const MiSectionHeader(title: 'Account'),
            const SizedBox(height: 12),
            _buildAccountCard(),
            const SizedBox(height: 20),
            _buildLogout(),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------- header

  Widget _buildHeader(UserProfile profile) {
    return Column(
      children: [
        UserAvatar(profile: profile, size: 92),
        const SizedBox(height: 14),
        Text(
          profile.displayName,
          textAlign: TextAlign.center,
          style: Mi.title(size: 22),
        ),
        if (profile.email.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(profile.email, style: Mi.caption()),
        ],
        if (profile.bio.isNotEmpty) ...[
          const SizedBox(height: 10),
          Text(
            profile.bio,
            textAlign: TextAlign.center,
            style: Mi.body(color: Mi.text.withValues(alpha: 0.75)),
          ),
        ],
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () => _openEditProfile(profile),
          style: OutlinedButton.styleFrom(
            foregroundColor: Mi.text,
            side: const BorderSide(color: Mi.line),
            backgroundColor: Mi.surface,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          icon: const Icon(Icons.edit_outlined, size: 16),
          label: Text(
            'Edit profile',
            style: Mi.body(size: 13, weight: FontWeight.w700),
          ),
        ),
      ],
    );
  }

  // ----------------------------------------------------------------- stats

  Widget _buildStats() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: Mi.card(),
      child: Row(
        children: [
          Expanded(
            child: StreamBuilder<List<UserPost>>(
              stream: _posts,
              builder: (context, snapshot) => _Stat(
                value: snapshot.data?.length,
                label: 'Posts',
              ),
            ),
          ),
          Container(width: 1, height: 32, color: Mi.line),
          Expanded(
            child: StreamBuilder<Set<String>>(
              stream: _favorites,
              builder: (context, snapshot) => _Stat(
                value: snapshot.data?.length,
                label: 'Favorites',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------- favorites

  Widget _buildFavorites() {
    return StreamBuilder<Set<String>>(
      stream: _favorites,
      builder: (context, snapshot) {
        if (snapshot.hasError) return const MiDataError();
        if (!snapshot.hasData) return const MiLoading();

        final ids = snapshot.data!;
        final items = animeCatalog.where((a) => ids.contains(a.id)).toList();

        if (items.isEmpty) {
          return const MiEmpty(
            icon: Icons.favorite_border_rounded,
            text: 'No favorites yet.\nTap the heart on any anime.',
          );
        }

        return SizedBox(
          height: 275,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) => SizedBox(
              width: 128,
              child: AnimeTile(anime: items[index], isFavorite: true),
            ),
          ),
        );
      },
    );
  }

  // --------------------------------------------------------------- account

  Widget _buildAccountCard() {
    return Container(
      decoration: Mi.card(),
      child: Column(
        children: [
          _SettingsTile(
            icon: Icons.lock_reset_rounded,
            title: 'Change password',
            subtitle: 'Send a reset link to your email',
            onTap: _sendPasswordReset,
          ),
          const Divider(height: 1, indent: 56, color: Mi.line),
          _SettingsTile(
            icon: Icons.info_outline_rounded,
            title: 'About',
            subtitle: 'Anime App 1.0.0',
            onTap: () => showAboutDialog(
              context: context,
              applicationName: 'Anime App',
              applicationVersion: '1.0.0',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogout() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _confirmLogOut,
        style: OutlinedButton.styleFrom(
          foregroundColor: Mi.danger,
          side: const BorderSide(color: Mi.line),
          backgroundColor: Mi.surface,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        icon: const Icon(Icons.logout_rounded, size: 18),
        label: Text(
          'Log out',
          style: Mi.body(color: Mi.danger, weight: FontWeight.w700),
        ),
      ),
    );
  }

  // --------------------------------------------------------------- actions

  void _openEditProfile(UserProfile profile) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Mi.surface,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _EditProfileSheet(profile: profile),
    );
  }

  Future<void> _sendPasswordReset() async {
    final email = FirebaseAuth.instance.currentUser?.email;
    if (email == null || email.isEmpty) {
      miSnack(context, 'This account has no email address.');
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (mounted) miSnack(context, 'Reset link sent to $email');
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        miSnack(context, e.message ?? "Couldn't send the reset email.");
      }
    } catch (_) {
      if (mounted) miSnack(context, "Couldn't send the reset email.");
    }
  }

  Future<void> _confirmLogOut() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Mi.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Log out?', style: Mi.title(size: 18)),
        content: Text(
          'You can sign back in anytime.',
          style: Mi.body(color: Mi.sub),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text('Cancel', style: Mi.body(color: Mi.sub)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              'Log out',
              style: Mi.body(color: Mi.danger, weight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
    if (ok == true) await _logOut();
  }

  Future<void> _logOut() async {
    // Also sign out of the social providers so the next login can pick a
    // different account instead of silently reusing this one.
    try {
      await GoogleSignIn.instance.signOut();
    } catch (_) {}
    try {
      await FacebookAuth.instance.logOut();
    } catch (_) {}
    await FirebaseAuth.instance.signOut();

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }
}

// ---------------------------------------------------------------------------
// Small widgets
// ---------------------------------------------------------------------------

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final int? value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value?.toString() ?? '–', style: Mi.title(size: 22)),
        const SizedBox(height: 2),
        Text(label, style: Mi.caption()),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: Mi.text, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Mi.body(weight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: Mi.caption()),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Mi.sub),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Edit profile sheet
// ---------------------------------------------------------------------------

class _EditProfileSheet extends StatefulWidget {
  const _EditProfileSheet({required this.profile});

  final UserProfile profile;

  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  late final TextEditingController _name =
      TextEditingController(text: widget.profile.displayName);
  late final TextEditingController _bio =
      TextEditingController(text: widget.profile.bio);
  late String? _avatar = widget.profile.avatar;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _bio.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty) {
      miSnack(context, 'Please enter a name.');
      return;
    }
    setState(() => _saving = true);
    try {
      await UserDataService.instance.updateProfile(
        displayName: _name.text,
        bio: _bio.text,
        avatar: _avatar,
      );
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (mounted) {
        setState(() => _saving = false);
        miSnack(context, "Couldn't save your profile. Please try again.");
      }
    }
  }

  InputDecoration _decoration(String label) => InputDecoration(
        labelText: label,
        labelStyle: Mi.body(color: Mi.sub),
        floatingLabelStyle:
            Mi.body(color: Mi.accent, weight: FontWeight.w700),
        filled: true,
        fillColor: Mi.bg,
        counterStyle: Mi.caption(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Mi.accent, width: 1.4),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final initialOnly = UserProfile(
      displayName: _name.text.isEmpty ? widget.profile.displayName : _name.text,
      email: widget.profile.email,
      bio: '',
      avatar: null,
      photoUrl: null,
      recentSearches: const [],
    );

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Edit profile', style: Mi.title(size: 20)),
            const SizedBox(height: 18),
            Text('Photo', style: Mi.caption()),
            const SizedBox(height: 10),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _AvatarOption(
                  selected: _avatar == null,
                  onTap: () => setState(() => _avatar = null),
                  child: UserAvatar(profile: initialOnly, size: 52),
                ),
                for (final path in avatarChoices)
                  _AvatarOption(
                    selected: _avatar == path,
                    onTap: () => setState(() => _avatar = path),
                    child: ClipOval(
                      child: Image.asset(
                        path,
                        width: 52,
                        height: 52,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Container(width: 52, height: 52, color: Mi.line),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _name,
              maxLength: 30,
              style: Mi.body(size: 15),
              cursorColor: Mi.accent,
              textCapitalization: TextCapitalization.words,
              decoration: _decoration('Name'),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _bio,
              maxLength: 80,
              maxLines: 2,
              style: Mi.body(size: 15),
              cursorColor: Mi.accent,
              decoration: _decoration('Bio'),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _saving ? null : _save,
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
                      'Save',
                      style: Mi.body(
                        size: 15,
                        color: Colors.white,
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

class _AvatarOption extends StatelessWidget {
  const _AvatarOption({
    required this.selected,
    required this.onTap,
    required this.child,
  });

  final bool selected;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? Mi.accent : Colors.transparent,
            width: 2.5,
          ),
        ),
        child: child,
      ),
    );
  }
}
