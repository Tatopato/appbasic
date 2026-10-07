import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import 'login_screen.dart';
import 'main_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with TickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  late final AnimationController _starController;
  late final AnimationController _entryController;
  late final AnimationController _floatingController; // เพิ่ม Controller สำหรับนักบินอวกาศ
  late final TapGestureRecognizer _loginTapRecognizer;

  @override
  void initState() {
    super.initState();
    // อนิเมชั่นดวงดาว (ฉากหลัง)
    _starController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    // อนิเมชั่นการปรากฏของ UI (เลื่อนขึ้นและ Fade in)
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    // อนิเมชันนักบินอวกาศจิ๋วลอยไปมา
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _loginTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      };
  }

  @override
  void dispose() {
    _starController.dispose();
    _entryController.dispose();
    _floatingController.dispose(); // อย่าลืม dispose
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _loginTapRecognizer.dispose();
    super.dispose();
  }

  // ฟังก์ชันช่วยสร้าง Minimalist Animation ให้ค่อยๆ ปรากฏทีละวิดเจ็ต
  Widget _animateWidget(Widget child, int index) {
    final delay = index * 0.1;
    final start = delay;
    final end = (start + 0.5).clamp(0.0, 1.0);

    final animation = CurvedAnimation(
      parent: _entryController,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF060716),
      body: Stack(
        children: [
          // Background Gradient
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
          Positioned(top: -80, left: -60, child: _nebulaBlob(AppColors.secondary, 220)),
          Positioned(top: 120, right: -80, child: _nebulaBlob(AppColors.primary, 260)),
          Positioned(bottom: 60, left: -60, child: _nebulaBlob(AppColors.accent, 200)),
          // Twinkling stars
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _starController,
              builder: (context, _) => CustomPaint(
                painter: _StarfieldPainter(_starController.value),
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Center(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // อนิเมชันการ์ตูนนักบินอวกาศจิ๋ว
                      _animateWidget(Center(child: _buildCuteAstronaut()), 0),
                      const SizedBox(height: 24),

                      _animateWidget(
                        Text(
                          "Create Your Account",
                          style: AppTextStyles.heading1.copyWith(color: Colors.white, height: 1.2),
                        ),
                        1,
                      ),
                      const SizedBox(height: 40),
                      
                      _animateWidget(
                        _buildTextFormField(
                          controller: _usernameController,
                          label: "Email",
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: _validateEmail,
                        ),
                        2,
                      ),
                      const SizedBox(height: 16),
                      
                      _animateWidget(
                        _buildTextFormField(
                          controller: _passwordController,
                          label: "Password",
                          icon: Icons.lock,
                          isPassword: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Please enter a password';
                            if (value.length < 6) return 'Password must be at least 6 characters';
                            return null;
                          },
                        ),
                        3,
                      ),
                      const SizedBox(height: 16),
                      
                      _animateWidget(
                        _buildTextFormField(
                          controller: _confirmPasswordController,
                          label: "Confirm Password",
                          icon: Icons.lock_outline,
                          isPassword: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Please confirm your password';
                            if (value != _passwordController.text) return 'Passwords do not match';
                            return null;
                          },
                        ),
                        4,
                      ),
                      const SizedBox(height: 32),
                      
                      _animateWidget(
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              elevation: 0, 
                            ),
                            onPressed: _isSubmitting ? null : _register,
                            child: _isSubmitting
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "REGISTER",
                                  style: GoogleFonts.roboto(
                                    fontSize: 16, 
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 2.0, 
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        5,
                      ),
                      const SizedBox(height: 32),

                      // --- Social Login Section ---
                      _animateWidget(_buildSocialLogins(), 6),
                      
                      const SizedBox(height: 32),

                      _animateWidget(
                        Center(
                          child: RichText(
                            text: TextSpan(
                              text: "Already have an account? ",
                              style: GoogleFonts.roboto(color: Colors.white60, fontSize: 14),
                              children: [
                                TextSpan(
                                  text: "Login",
                                  style: GoogleFonts.roboto(color: AppColors.accent, fontWeight: FontWeight.bold),
                                  recognizer: _loginTapRecognizer,
                                ),
                              ],
                            ),
                          ),
                        ),
                        7,
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

  // --- Cute Minimalist Astronaut Widget ---
  Widget _buildCuteAstronaut() {
    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        // ทำให้ลอยขึ้นและลงอย่างนุ่มนวล
        final floatY = sin(_floatingController.value * pi * 2) * 8.0;
        return Transform.translate(
          offset: Offset(0, floatY),
          child: child,
        );
      },
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // หน้ากากนักบินอวกาศ (กระจกดำ)
            Container(
              width: 45,
              height: 30,
              decoration: BoxDecoration(
                color: const Color(0xFF14103A), // สีอวกาศ
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            // ตาหรือแสงสะท้อนบนกระจก
            Positioned(
              top: 25,
              left: 20,
              child: Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: 25,
              right: 25,
              child: Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Widget สำหรับ Third-Party Login ---
  Widget _buildSocialLogins() {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Divider(color: Colors.white24, thickness: 1)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Or register with",
                style: GoogleFonts.roboto(color: Colors.white54, fontSize: 12),
              ),
            ),
            const Expanded(child: Divider(color: Colors.white24, thickness: 1)),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _socialButton(FontAwesomeIcons.google, Colors.white, () {
              debugPrint("Google Login Clicked");
            }),
            const SizedBox(width: 20),
            _socialButton(FontAwesomeIcons.facebookF, const Color(0xFF1877F2), () {
              debugPrint("Facebook Login Clicked");
            }),
            const SizedBox(width: 20),
            _socialButton(FontAwesomeIcons.github, Colors.white, () {
              debugPrint("GitHub Login Clicked");
            }),
          ],
        ),
      ],
    );
  }

  // ปุ่ม Social แบบ Minimalist
  Widget _socialButton(dynamic icon, Color iconColor, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50),
        splashColor: Colors.white.withOpacity(0.1),
        highlightColor: Colors.white.withOpacity(0.05),
        child: Container(
          width: 50,
          height: 50,
          alignment: Alignment.center, 
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.5),
          ),
          child: FaIcon(icon, color: iconColor, size: 20), 
        ),
      ),
    );
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _usernameController.text.trim(),
        password: _passwordController.text,
      );
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
        (route) => false,
      );
    } on FirebaseAuthException catch (error) {
      _showMessage(_authErrorMessage(error));
    } catch (_) {
      _showMessage('Firebase is not configured yet. Please complete the setup steps.');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Please enter your email';
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String _authErrorMessage(FirebaseAuthException error) {
    switch (error.code) {
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'network-request-failed':
        return 'Please check your internet connection.';
      default:
        return error.message ?? 'Unable to create account. Please try again.';
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: GoogleFonts.roboto(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.roboto(color: Colors.white60),
        prefixIcon: Icon(icon, color: AppColors.accent, size: 22),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
        errorStyle: const TextStyle(color: AppColors.danger),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1), width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.danger, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
        ),
      ),
    );
  }

  Widget _nebulaBlob(Color color, double size) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color.withOpacity(0.25), color.withOpacity(0.0)],
          ),
        ),
      ),
    );
  }
}

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
      paint.color = Colors.white.withOpacity(0.15 + twinkle * 0.5); 
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
  _Star({required this.dx, required this.dy, required this.radius, required this.phase});
  final double dx;
  final double dy;
  final double radius;
  final double phase;
}
