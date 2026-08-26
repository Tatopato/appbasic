import 'package:flutter/material.dart';
import 'package:app_name_v2/constants/app_colors.dart';
import 'package:app_name_v2/constants/app_text_styles.dart';
import 'package:app_name_v2/constants/cosmic_background.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  bool _focused = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF060716),
      body: Stack(
        children: [
          const Positioned.fill(child: CosmicBackground()),
          SafeArea(
            child: FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Search', style: AppTextStyles.heading1.copyWith(color: Colors.white)),
                      const SizedBox(height: 16),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOut,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _focused
                                ? AppColors.accent.withOpacity(0.7)
                                : Colors.white.withOpacity(0.08),
                          ),
                          boxShadow: _focused
                              ? [BoxShadow(color: AppColors.accent.withOpacity(0.35), blurRadius: 18)]
                              : [],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search_rounded,
                              color: _focused ? AppColors.accent : Colors.white.withOpacity(0.4),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Focus(
                                onFocusChange: (has) => setState(() => _focused = has),
                                child: TextField(
                                  autofocus: true,
                                  style: const TextStyle(color: Colors.white, fontSize: 14),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Search anime, manga...',
                                    hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.35),
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 48),
                      Center(
                        child: _PulsingIcon(color: AppColors.secondary),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Text(
                          'Find your next favorite anime',
                          style: TextStyle(color: Colors.white.withOpacity(0.45), fontSize: 13),
                        ),
                      ),
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
}

/// Slowly pulsing glow icon used for the empty search state.
class _PulsingIcon extends StatefulWidget {
  const _PulsingIcon({required this.color});
  final Color color;

  @override
  State<_PulsingIcon> createState() => _PulsingIconState();
}

class _PulsingIconState extends State<_PulsingIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        return Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.color.withOpacity(0.10 + t * 0.05),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.25 + t * 0.2),
                blurRadius: 24 + t * 12,
                spreadRadius: t * 3,
              ),
            ],
          ),
          child: Icon(
            Icons.travel_explore_rounded,
            size: 44,
            color: Colors.white.withOpacity(0.8),
          ),
        );
      },
    );
  }
}