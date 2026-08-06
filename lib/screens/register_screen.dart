import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 82, 214, 168),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Create Your Account",
                  style: AppTextStyles.heading1.copyWith(height: 1.2), 
                ),
                const SizedBox(height: 12),
                const SizedBox(height: 40),
                //Username
                _buildTextField(
                  controller: _usernameController,
                  label: "Username",
                  icon: Icons.person,
                ),
                const SizedBox(height: 20),
                //Password
                _buildTextField(
                  controller: _passwordController,
                  label: "Password",
                  icon: Icons.lock,
                  isPassword: true,
                ),
                const SizedBox(height: 20),

                //Confirm Password
                _buildTextField(
                  controller: _confirmPasswordController,
                  label: "Confirm Password",
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),
                const SizedBox(height: 40),

                //Register
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary, 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 3,
                    ),
                    onPressed: () {
                      print("Username: ${_usernameController.text}");
                      print("Password: ${_passwordController.text}");
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()), // แก้ชื่อคลาสให้ตรงกับหน้า Login ของคุณ
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "REGISTER",
                          style: GoogleFonts.roboto(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const CircleAvatar(
                          radius: 12,
                          backgroundColor: AppColors.secondary,
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Login ด้านล่าง
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: "Already have an account? ",
                      style: GoogleFonts.roboto(
                        color: AppColors.textprimary, 
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(
                          text: "Login",
                          style: GoogleFonts.roboto(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget สำหรับสร้างช่องกรอกข้อมูล
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      // บังคับให้ text ในกล่องข้อความเป็นฟอนต์ Roboto
      style: GoogleFonts.roboto(color: AppColors.textprimary), 
      decoration: InputDecoration(
        labelText: label,
        // บังคับให้ label เป็นฟอนต์ Roboto
        labelStyle: GoogleFonts.roboto(color: AppColors.textprimary),
        prefixIcon: Icon(icon, color: AppColors.accent),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.5),
        contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: AppColors.accent, width: 2.0),
        ),
      ),
    );
  }
}