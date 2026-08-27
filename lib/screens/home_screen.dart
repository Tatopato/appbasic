import 'package:flutter/material.dart';
import 'package:app_name_v2/constants/app_colors.dart';
import 'package:app_name_v2/constants/app_text_styles.dart';
import 'package:app_name_v2/constants/cosmic_background.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  // Sample feed data. Replace `avatarPath` / `imagePath` with your own
  // assets (declared in pubspec.yaml). Missing files fall back to a
  // placeholder automatically, so nothing crashes while you swap them in.
  final List<_Post> _posts = [
    const _Post(
      username: 'narathip.s',
      avatarPath: 'assets/images/handsome.jpg',
      timeAgo: '2h ago',
      imagePath: 'assets/images/rezero.jpg',
      caption: 'Re:Zero season finale hit different 😭 that ending arc was insane.',
      likeCount: 128,
      commentCount: 24,
      accentColorKey: _ColorKey.primary,
    ),
    const _Post(
      username: 'ploy_anime',
      avatarPath: 'assets/images/profile1.jpg',
      timeAgo: '5h ago',
      imagePath: 'assets/images/akame.jpg',
      caption: 'Akeme is on sad mode this week, but the animation quality is top notch as always.',
      likeCount: 342,
      commentCount: 58,
      accentColorKey: _ColorKey.secondary,
    ),
    const _Post(
      username: 'kenji_watches',
      avatarPath: 'assets/images/profile2.jpg',
      timeAgo: '1d ago',
      imagePath: 'assets/images/bluelock.jpg',
      caption: 'Blue Lock is heating up this season, the competition is fierce!',
      likeCount: 96,
      commentCount: 11,
      accentColorKey: _ColorKey.accent,
    ),
    const _Post(
      username: 'mika.reviews',
      avatarPath: 'assets/images/profile3.jpg',
      timeAgo: '2d ago',
      imagePath: 'assets/images/slime.jpg',
      caption: 'Slime is the best character in the show, hands down!',
      likeCount: 210,
      commentCount: 33,
      accentColorKey: _ColorKey.success,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fade = CurvedAnimation(parent: _entrance, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entrance, curve: Curves.easeOutCubic));
    _entrance.forward();
  }

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  Color _resolve(_ColorKey key) {
    switch (key) {
      case _ColorKey.primary:
        return AppColors.primary;
      case _ColorKey.secondary:
        return AppColors.secondary;
      case _ColorKey.accent:
        return AppColors.accent;
      case _ColorKey.success:
        return AppColors.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171A3D),
      floatingActionButton: _buildCreatePostFab(),
      body: Stack(
        children: [
          const Positioned.fill(child: CosmicBackground()),
          SafeArea(
            child: FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: Column(
                  children: [
                    _buildTopBar(),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                        itemCount: _posts.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 18),
                        itemBuilder: (context, index) {
                          final post = _posts[index];
                          return _StaggeredEntry(
                            delay: index * 80,
                            child: _PostCard(
                              post: post,
                              accentColor: _resolve(post.accentColorKey),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Discover', style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.5))),
              Text('Anime', style: AppTextStyles.heading1.copyWith(color: Colors.white)),
            ],
          ),
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: const Icon(Icons.notifications_none_rounded, color: Colors.white70),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 44,
                  height: 44,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.secondary, AppColors.accent],
                    ),
                    boxShadow: [
                      BoxShadow(color: AppColors.secondary.withOpacity(0.4), blurRadius: 10),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/handsome.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xFF23205A),
                        child: const Icon(Icons.person, color: Colors.white70, size: 20),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCreatePostFab() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
        ),
        boxShadow: [
          BoxShadow(color: AppColors.secondary.withOpacity(0.5), blurRadius: 18, spreadRadius: 1),
        ],
      ),
      child: FloatingActionButton(
        onPressed: _openCreatePostSheet,
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
    );
  }

  void _openCreatePostSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _CreatePostSheet(
          onSubmit: (caption, imagePath) {
            setState(() {
              _posts.insert(
                0,
                _Post(
                  username: 'you',
                  avatarPath: 'assets/images/handsome.jpg',
                  timeAgo: 'Just now',
                  imagePath: imagePath ?? 'assets/images/rezero.jpg',
                  caption: caption,
                  likeCount: 0,
                  commentCount: 0,
                  accentColorKey: _ColorKey.primary,
                ),
              );
            });
          },
        );
      },
    );
  }

}

enum _ColorKey { primary, secondary, accent, success }

class _Post {
  const _Post({
    required this.username,
    required this.avatarPath,
    required this.timeAgo,
    required this.imagePath,
    required this.caption,
    required this.likeCount,
    required this.commentCount,
    required this.accentColorKey,
  });

  final String username;
  final String avatarPath;
  final String timeAgo;
  final String imagePath;
  final String caption;
  final int likeCount;
  final int commentCount;
  final _ColorKey accentColorKey;
}

/// Fades + slides a child in with a per-item delay, used for the
/// staggered feed entrance animation.
class _StaggeredEntry extends StatefulWidget {
  const _StaggeredEntry({required this.child, required this.delay});
  final Widget child;
  final int delay;

  @override
  State<_StaggeredEntry> createState() => _StaggeredEntryState();
}

class _StaggeredEntryState extends State<_StaggeredEntry>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.1),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic)),
        child: widget.child,
      ),
    );
  }
}

/// A single feed post: profile header, anime artwork, then
/// like / comment / share actions.
class _PostCard extends StatefulWidget {
  const _PostCard({required this.post, required this.accentColor});

  final _Post post;
  final Color accentColor;

  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard> {
  bool _liked = false;
  late int _likeCount = widget.post.likeCount;

  void _toggleLike() {
    setState(() {
      _liked = !_liked;
      _likeCount += _liked ? 1 : -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildImage(),
            _buildActions(),
            _buildCaption(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [widget.accentColor, widget.accentColor.withOpacity(0.4)],
              ),
            ),
            child: ClipOval(
              child: Image.asset(
                widget.post.avatarPath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xFF23205A),
                  child: const Icon(Icons.person, color: Colors.white70, size: 18),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.post.username,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                ),
                Text(
                  widget.post.timeAgo,
                  style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.45)),
                ),
              ],
            ),
          ),
          Icon(Icons.more_horiz_rounded, color: Colors.white.withOpacity(0.4)),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Image.asset(
        widget.post.imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [widget.accentColor, widget.accentColor.withOpacity(0.5)],
              ),
            ),
            child: Center(
              child: Icon(Icons.image_outlined, size: 48, color: Colors.white.withOpacity(0.4)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Row(
        children: [
          _ActionButton(
            icon: _liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            label: '$_likeCount',
            color: _liked ? AppColors.danger : Colors.white.withOpacity(0.8),
            animateOnTap: true,
            onTap: _toggleLike,
          ),
          const SizedBox(width: 18),
          _ActionButton(
            icon: Icons.mode_comment_outlined,
            label: '${widget.post.commentCount}',
            color: Colors.white.withOpacity(0.8),
            onTap: () {},
          ),
          const SizedBox(width: 18),
          _ActionButton(
            icon: Icons.share_outlined,
            label: 'Share',
            color: Colors.white.withOpacity(0.8),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildCaption() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '${widget.post.username}  ',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
            ),
            TextSpan(
              text: widget.post.caption,
              style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.7), height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

/// Like / comment / share button with a small pop animation for the icon.
class _ActionButton extends StatefulWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.animateOnTap = false,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool animateOnTap;

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _bump = false;

  void _handleTap() {
    widget.onTap();
    if (widget.animateOnTap) {
      setState(() => _bump = true);
      Future.delayed(const Duration(milliseconds: 180), () {
        if (mounted) setState(() => _bump = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: _handleTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutBack,
              scale: _bump ? 1.35 : 1.0,
              child: Icon(widget.icon, color: widget.color, size: 22),
            ),
            const SizedBox(width: 6),
            Text(
              widget.label,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: widget.color),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bottom sheet used to compose a new post: an image preview area
/// (tap to "pick" — wire this up to image_picker in your project),
/// a caption field, and a Post button.
class _CreatePostSheet extends StatefulWidget {
  const _CreatePostSheet({required this.onSubmit});

  /// Called with (caption, imagePath). `imagePath` is null until you
  /// wire up a real image picker — the sheet just demonstrates the flow.
  final void Function(String caption, String? imagePath) onSubmit;

  @override
  State<_CreatePostSheet> createState() => _CreatePostSheetState();
}

class _CreatePostSheetState extends State<_CreatePostSheet> {
  final TextEditingController _captionController = TextEditingController();
  String? _pickedImagePath;

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  void _pickImage() {
    // TODO: hook this up to `image_picker` (or your file picker of choice)
    // and set _pickedImagePath to the real file/asset path.
    setState(() {
      _pickedImagePath = 'assets/images/rezero.jpg';
    });
  }

  void _submit() {
    final caption = _captionController.text.trim();
    if (caption.isEmpty && _pickedImagePath == null) return;
    widget.onSubmit(caption.isEmpty ? 'New post' : caption, _pickedImagePath);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        decoration: const BoxDecoration(
          color: Color(0xFF1E2050),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'New Post',
                  style: AppTextStyles.heading3.copyWith(fontSize: 18, color: Colors.white),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel', style: TextStyle(color: Colors.white.withOpacity(0.5))),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _pickImage,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _pickedImagePath != null
                        ? AppColors.primary.withOpacity(0.6)
                        : Colors.white.withOpacity(0.12),
                  ),
                ),
                child: _pickedImagePath == null
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add_photo_alternate_outlined,
                                color: Colors.white.withOpacity(0.4), size: 32),
                            const SizedBox(height: 8),
                            Text(
                              'Tap to add anime artwork',
                              style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 13),
                            ),
                          ],
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          _pickedImagePath!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Icon(Icons.image_outlined, color: Colors.white.withOpacity(0.3), size: 32),
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: TextField(
                controller: _captionController,
                maxLines: 3,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "What's on your mind about anime today?",
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 14),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Post', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}