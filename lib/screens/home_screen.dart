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

  // Categories can optionally carry an `imagePath`. If it's null (or the
  // asset fails to load) the card falls back to the icon + color chip.
  static const List<_AnimeCategory> _categories = [
    _AnimeCategory('Action', Icons.bolt_rounded, _ColorKey.primary, 'assets/images/action.jpg'),
    _AnimeCategory('Romance', Icons.favorite_rounded, _ColorKey.danger, null),
    _AnimeCategory('Comedy', Icons.emoji_emotions_rounded, _ColorKey.warning, null),
    _AnimeCategory('Fantasy', Icons.auto_awesome_rounded, _ColorKey.secondary, null),
    _AnimeCategory('Horror', Icons.dark_mode_rounded, _ColorKey.accent, null),
    _AnimeCategory('Slice of Life', Icons.local_cafe_rounded, _ColorKey.success, null),
    _AnimeCategory('Sports', Icons.sports_soccer_rounded, _ColorKey.accent, null),
    _AnimeCategory('Isekai', Icons.public_rounded, _ColorKey.primary, null),
    _AnimeCategory('Mecha', Icons.smart_toy_rounded, _ColorKey.secondary, null),
    _AnimeCategory('Mystery', Icons.search_rounded, _ColorKey.warning, null),
  ];

  static const List<_TrendingAnime> _trending = [
    _TrendingAnime('Solo Ascend', '4.9', _ColorKey.primary),
    _TrendingAnime('Blade of Dawn', '4.8', _ColorKey.secondary),
    _TrendingAnime('Starlit Path', '4.7', _ColorKey.accent),
    _TrendingAnime('Crimson Order', '4.6', _ColorKey.danger),
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
      case _ColorKey.danger:
        return AppColors.danger;
      case _ColorKey.warning:
        return AppColors.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171A3D),
      body: Stack(
        children: [
          const Positioned.fill(child: CosmicBackground()),
          SafeArea(
            child: FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTopBar(),
                      const SizedBox(height: 16),
                      _buildSearchBar(),
                      const SizedBox(height: 24),
                      _buildSectionHeader('Categories'),
                      const SizedBox(height: 12),
                      _buildCategoryGrid(),
                      const SizedBox(height: 28),
                      _buildSectionHeader('Trending Now'),
                      const SizedBox(height: 12),
                      _buildTrendingList(),
                      const SizedBox(height: 8),
                    ],
                  ),
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
              // Small profile avatar shortcut.
              // Point this at your own asset, e.g. 'assets/images/handsome.jpg'
              // (already used on the Profile screen).
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

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Row(
          children: [
            Icon(Icons.search_rounded, color: Colors.white.withOpacity(0.4)),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search anime, manga...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.heading3.copyWith(fontSize: 18, color: Colors.white)),
          Text(
            'See all',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.accent),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2.4,
        ),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final delay = index * 40;
          return _StaggeredEntry(
            delay: delay,
            child: _CosmicCategoryCard(
              label: category.label,
              icon: category.icon,
              imagePath: category.imagePath,
              color: _resolve(category.colorKey),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTrendingList() {
    return SizedBox(
      height: 190,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _trending.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final anime = _trending[index];
          final delay = index * 70;
          return _StaggeredEntry(
            delay: delay,
            child: _CosmicTrendingCard(
              title: anime.title,
              rating: anime.rating,
              color: _resolve(anime.colorKey),
            ),
          );
        },
      ),
    );
  }
}

enum _ColorKey { primary, secondary, accent, success, danger, warning }

class _AnimeCategory {
  const _AnimeCategory(this.label, this.icon, this.colorKey, [this.imagePath]);
  final String label;
  final IconData icon;
  final _ColorKey colorKey;
  // Optional. Point this at e.g. 'assets/images/categories/action.jpg' to
  // show artwork instead of the plain icon chip. Leave null for icon-only.
  final String? imagePath;
}

class _TrendingAnime {
  const _TrendingAnime(this.title, this.rating, this.colorKey);
  final String title;
  final String rating;
  final _ColorKey colorKey;
}

/// Fades + slides a child in with a per-item delay, used for the
/// staggered grid/list entrance animation.
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
          begin: const Offset(0, 0.15),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic)),
        child: widget.child,
      ),
    );
  }
}

class _CosmicCategoryCard extends StatefulWidget {
  const _CosmicCategoryCard({
    required this.label,
    required this.icon,
    required this.color,
    this.imagePath,
  });

  final String label;
  final IconData icon;
  final Color color;
  final String? imagePath;

  @override
  State<_CosmicCategoryCard> createState() => _CosmicCategoryCardState();
}

class _CosmicCategoryCardState extends State<_CosmicCategoryCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final hasImage = widget.imagePath != null;

    return RepaintBoundary(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovering = true),
        onExit: (_) => setState(() => _hovering = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          transform: Matrix4.identity()..scale(_hovering ? 1.03 : 1.0),
          transformAlignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: _hovering ? widget.color.withOpacity(0.16) : Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hovering ? widget.color.withOpacity(0.5) : Colors.white.withOpacity(0.08),
            ),
            // Keep a single BoxShadow entry at all times (just tween its
            // opacity/blur) instead of swapping between [] and [shadow] —
            // AnimatedContainer can't interpolate list length changes, so
            // that used to pop in/out abruptly and felt like lag on hover.
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(_hovering ? 0.35 : 0.0),
                blurRadius: _hovering ? 16 : 0,
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 38,
                  height: 38,
                  color: widget.color.withOpacity(0.35),
                  child: hasImage
                      ? Image.asset(
                          widget.imagePath!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(widget.icon, color: Colors.white, size: 19),
                        )
                      : Icon(widget.icon, color: Colors.white, size: 19),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CosmicTrendingCard extends StatefulWidget {
  const _CosmicTrendingCard({required this.title, required this.rating, required this.color});
  final String title;
  final String rating;
  final Color color;

  @override
  State<_CosmicTrendingCard> createState() => _CosmicTrendingCardState();
}

class _CosmicTrendingCardState extends State<_CosmicTrendingCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovering = true),
        onExit: (_) => setState(() => _hovering = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          width: 130,
          transform: Matrix4.identity()..translate(0.0, _hovering ? -6.0 : 0.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(_hovering ? 0.45 : 0.15),
                blurRadius: _hovering ? 20 : 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 130,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [widget.color, widget.color.withOpacity(0.55)],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                  ),
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.35),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded, color: Colors.amber, size: 12),
                          const SizedBox(width: 2),
                          Text(
                            widget.rating,
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF23205A),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(18),
                  ),
                  border: Border.all(color: Colors.white.withOpacity(0.06)),
                ),
                child: Text(
                  widget.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}