import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_name_v2/constants/app_colors.dart';
import 'package:app_name_v2/constants/app_text_styles.dart';
import 'login_screen.dart'; // เพิ่ม Import หน้า Login

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _starController;

  @override
  void initState() {
    super.initState();
    _starController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _starController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF060716),
      body: Stack(
        children: [
          // Deep space gradient background
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF0B0B24),
                    Color(0xFF14103A),
                    Color(0xFF1D0F3B),
                    Color(0xFF06040F),
                  ],
                  stops: [0.0, 0.35, 0.65, 1.0],
                ),
              ),
            ),
          ),
          // Nebula glow blobs
          Positioned(
            top: -80,
            left: -60,
            child: _nebulaBlob(AppColors.secondary, 220),
          ),
          Positioned(
            top: 120,
            right: -80,
            child: _nebulaBlob(AppColors.primary, 260),
          ),
          Positioned(
            bottom: 60,
            left: -60,
            child: _nebulaBlob(AppColors.accent, 200),
          ),
          // Twinkling stars
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _starController,
              builder: (context, _) {
                return CustomPaint(
                  painter: _StarfieldPainter(_starController.value),
                );
              },
            ),
          ),
          // Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 28),
                  _buildSectionTitle('My Account'),
                  const SizedBox(height: 10),
                  _buildCategoryCard(
                    children: [
                      _buildMenuTile(
                        icon: Icons.person_outline_rounded,
                        iconColor: AppColors.primary,
                        title: 'Edit Profile',
                        subtitle: 'Name, photo, and personal info',
                        onTap: () {},
                      ),
                      _buildDivider(),
                      _buildMenuTile(
                        icon: Icons.lock_outline_rounded,
                        iconColor: AppColors.secondary,
                        title: 'Security',
                        subtitle: 'Password and verification',
                        onTap: () {},
                      ),
                      _buildDivider(),
                      _buildMenuTile(
                        icon: Icons.notifications_none_rounded,
                        iconColor: AppColors.accent,
                        title: 'Notifications',
                        subtitle: 'Manage your notifications',
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('My Activity'),
                  const SizedBox(height: 10),
                  _buildCategoryCard(
                    children: [
                      _buildMenuTile(
                        icon: Icons.favorite_border_rounded,
                        iconColor: AppColors.danger,
                        title: 'Favorites',
                        subtitle: "Items you've liked",
                        onTap: () {},
                      ),
                      _buildDivider(),
                      _buildMenuTile(
                        icon: Icons.shopping_bag_outlined,
                        iconColor: AppColors.success,
                        title: 'My Orders',
                        subtitle: 'Track your order status',
                        onTap: () {},
                      ),
                      _buildDivider(),
                      _buildMenuTile(
                        icon: Icons.star_border_rounded,
                        iconColor: AppColors.warning,
                        title: 'My Reviews',
                        subtitle: "Reviews you've written",
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Others'),
                  const SizedBox(height: 10),
                  _buildCategoryCard(
                    children: [
                      _buildMenuTile(
                        icon: Icons.help_outline_rounded,
                        iconColor: AppColors.primary,
                        title: 'Help & Support',
                        subtitle: 'FAQs and contact us',
                        onTap: () {},
                      ),
                      _buildDivider(),
                      _buildMenuTile(
                        icon: Icons.info_outline_rounded,
                        iconColor: AppColors.secondary,
                        title: 'About App',
                        subtitle: 'Version and more info',
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  _buildLogoutButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Nebula blob ----------
  Widget _nebulaBlob(Color color, double size) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withOpacity(0.35),
              color.withOpacity(0.0),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- Header ----------
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Profile',
                style: AppTextStyles.heading2.copyWith(color: Colors.white),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.settings_outlined, color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.secondary,
                      AppColors.accent,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.secondary.withOpacity(0.55),
                      blurRadius: 24,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  radius: 65,
                  backgroundColor: Color(0xFF141225),
                  backgroundImage: AssetImage(
                    'assets/images/handsome.jpg',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF0B0B24), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.6),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: const Icon(Icons.edit, color: Colors.white, size: 14),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            FirebaseAuth.instance.currentUser?.displayName ?? 'Anime Fan',
            style: AppTextStyles.heading3.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            FirebaseAuth.instance.currentUser?.email ?? '',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Section ----------
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        title,
        style: AppTextStyles.heading3.copyWith(
          fontSize: 15,
          color: Colors.white.withOpacity(0.55),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCategoryCard({required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
        child: Column(children: children),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      indent: 60,
      color: Colors.white.withOpacity(0.08),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return _MenuTile(
      icon: icon,
      iconColor: iconColor,
      title: title,
      subtitle: subtitle,
      onTap: onTap,
    );
  }

  // ---------- Logout ----------
  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            if (!context.mounted) return;
            // นำทางไปยังหน้า LoginScreen และเคลียร์ stack ป้องกันการกด back กลับมาหน้าเดิม
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false,
            );
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.danger,
            side: BorderSide(color: AppColors.danger.withOpacity(0.5)),
            backgroundColor: AppColors.danger.withOpacity(0.08),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          icon: const Icon(Icons.logout_rounded, size: 18),
          label: const Text(
            'Log Out',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

// ---------- Menu tile with hover animation ----------
class _MenuTile extends StatefulWidget {
  const _MenuTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  State<_MenuTile> createState() => _MenuTileState();
}

class _MenuTileState extends State<_MenuTile> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          margin: EdgeInsets.symmetric(
            horizontal: _hovering ? 6 : 0,
            vertical: _hovering ? 3 : 0,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: _hovering
                ? widget.iconColor.withOpacity(0.10)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _hovering
                  ? widget.iconColor.withOpacity(0.35)
                  : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                width: 40,
                height: 40,
                transform: Matrix4.identity()
                  ..scale(_hovering ? 1.08 : 1.0),
                transformAlignment: Alignment.center,
                decoration: BoxDecoration(
                  color: widget.iconColor.withOpacity(_hovering ? 0.5 : 0.32),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: widget.iconColor.withOpacity(_hovering ? 0.55 : 0.3),
                      blurRadius: _hovering ? 16 : 8,
                      spreadRadius: _hovering ? 1 : 0,
                    ),
                  ],
                ),
                child: Icon(widget.icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.45),
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedSlide(
                duration: const Duration(milliseconds: 200),
                offset: _hovering ? const Offset(0.15, 0) : Offset.zero,
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: _hovering
                      ? widget.iconColor.withOpacity(0.9)
                      : Colors.white.withOpacity(0.3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------- Starfield painter ----------
class _StarfieldPainter extends CustomPainter {
  _StarfieldPainter(this.progress);

  final double progress;
  static final List<_Star> _stars = List.generate(70, (index) {
    final rnd = Random(index);
    return _Star(
      dx: rnd.nextDouble(),
      dy: rnd.nextDouble(),
      radius: rnd.nextDouble() * 1.4 + 0.4,
      phase: rnd.nextDouble(),
    );
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    for (final star in _stars) {
      final twinkle = (sin((progress + star.phase) * 2 * pi) + 1) / 2;
      paint.color = Colors.white.withOpacity(0.25 + twinkle * 0.65);
      canvas.drawCircle(
        Offset(star.dx * size.width, star.dy * size.height),
        star.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _StarfieldPainter oldDelegate) => true;
}

class _Star {
  _Star({
    required this.dx,
    required this.dy,
    required this.radius,
    required this.phase,
  });

  final double dx;
  final double dy;
  final double radius;
  final double phase;
}
