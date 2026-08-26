import 'package:flutter/material.dart';
import 'package:app_name_v2/constants/app_colors.dart';
import 'package:app_name_v2/constants/app_text_styles.dart';
import 'package:app_name_v2/constants/cosmic_background.dart';
import 'package:app_name_v2/screens/login_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // ---- Onboarding content ----
  // Point `imagePath` at any asset under assets/images/ (declared in
  // pubspec.yaml). Slides render Image.asset directly now; if a file is
  // missing you'll see a soft placeholder icon instead of a crash.
  static const List<_IntroSlide> _slides = [
    _IntroSlide(
      imagePath: 'assets/images/rezero.jpg',
      title: 'Endless Anime Library',
      description: 'Explore thousands of titles across every genre, updated daily.',
      accentColorKey: _ColorKey.primary,
    ),
    _IntroSlide(
      imagePath: 'assets/images/jjk.jpg',
      title: 'Personalized For You',
      description: 'Get recommendations tailored to what you love watching.',
      accentColorKey: _ColorKey.secondary,
    ),
    _IntroSlide(
      imagePath: 'assets/images/sao.jpg',
      title: 'Watch Anywhere',
      description: 'Stream seamlessly across your phone, tablet, and desktop.',
      accentColorKey: _ColorKey.accent,
    ),
    _IntroSlide(
      imagePath: 'assets/images/onepiece.jpg',
      title: 'Join the Community',
      description: 'Rate, review, and discuss your favorite series with fans worldwide.',
      accentColorKey: _ColorKey.success,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
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

  bool get _isLastPage => _currentPage == _slides.length - 1;

  void _onNext() {
    if (_isLastPage) {
      _goToApp();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _goToApp() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, animation, __) => FadeTransition(
          opacity: animation,
          child: const LoginScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accent = _resolve(_slides[_currentPage].accentColorKey);

    return Scaffold(
      backgroundColor: const Color(0xFF171A3D),
      body: Stack(
        children: [
          const Positioned.fill(child: CosmicBackground()),
          SafeArea(
            child: Column(
              children: [
                // Skip button
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 20, 0),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 250),
                      opacity: _isLastPage ? 0 : 1,
                      child: TextButton(
                        onPressed: _isLastPage ? null : _goToApp,
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _slides.length,
                    onPageChanged: (index) => setState(() => _currentPage = index),
                    itemBuilder: (context, index) {
                      final slide = _slides[index];
                      return _IntroSlideView(
                        slide: slide,
                        accentColor: _resolve(slide.accentColorKey),
                      );
                    },
                  ),
                ),
                _buildDotsIndicator(accent),
                const SizedBox(height: 28),
                _buildBottomButton(accent),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDotsIndicator(Color accent) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_slides.length, (index) {
        final active = index == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active ? accent : Colors.white.withOpacity(0.25),
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: accent.withOpacity(active ? 0.6 : 0.0),
                blurRadius: active ? 10 : 0,
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildBottomButton(Color accent) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: ScaleTransition(scale: animation, child: child),
          ),
          child: ElevatedButton(
            key: ValueKey(_isLastPage),
            onPressed: _onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: accent,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ).copyWith(
              shadowColor: WidgetStateProperty.all(accent.withOpacity(0.5)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _isLastPage ? 'Get Started' : 'Next',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(width: 8),
                Icon(
                  _isLastPage ? Icons.rocket_launch_rounded : Icons.arrow_forward_rounded,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum _ColorKey { primary, secondary, accent, success }

class _IntroSlide {
  const _IntroSlide({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.accentColorKey,
  });

  final String imagePath;
  final String title;
  final String description;
  final _ColorKey accentColorKey;
}

class _IntroSlideView extends StatelessWidget {
  const _IntroSlideView({required this.slide, required this.accentColor});

  final _IntroSlide slide;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Glowing image frame — now actually renders the asset.
          // If the file is missing/misnamed, errorBuilder shows a soft
          // placeholder icon instead of crashing the page.
          Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              color: Colors.white.withOpacity(0.06),
              border: Border.all(color: accentColor.withOpacity(0.35)),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withOpacity(0.35),
                  blurRadius: 40,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          accentColor.withOpacity(0.25),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Image.asset(
                    slide.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(
                          Icons.image_outlined,
                          size: 56,
                          color: Colors.white.withOpacity(0.25),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            slide.title,
            textAlign: TextAlign.center,
            style: AppTextStyles.heading2.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 12),
          Text(
            slide.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.white.withOpacity(0.55),
            ),
          ),
        ],
      ),
    );
  }
}