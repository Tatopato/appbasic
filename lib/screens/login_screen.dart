import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgsecondary,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // หัวข้อ Login โดยใช้ heading1 แบบเดียวกับหน้า Register
                Text(
                  "Welcome\nBack",
                  style: AppTextStyles.heading1.copyWith(height: 1.2), 
                ),
                const SizedBox(height: 12),
                
                // คำอธิบาย
                Text(
                  "Please sign in to continue",
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    color: AppColors.textsecondary,
                  ),
                ),
                const SizedBox(height: 50),

                // ช่องกรอก Username
                _buildTextField(
                  controller: _usernameController,
                  label: "Username",
                  icon: Icons.person,
                ),
                const SizedBox(height: 20),

                // ช่องกรอก Password
                _buildTextField(
                  controller: _passwordController,
                  label: "Password",
                  icon: Icons.lock,
                  isPassword: true,
                ),
                
                // ลืมรหัสผ่าน (Forgot Password)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // เพิ่ม Action สำหรับลืมรหัสผ่าน
                    },
                    child: Text(
                      "Forgot Password?",
                      style: GoogleFonts.roboto(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 30),

                // ปุ่ม Login
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
                      print("Login Username: ${_usernameController.text}");
                      print("Login Password: ${_passwordController.text}");
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "LOGIN",
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
                
                const SizedBox(height: 30),
                
                // ข้อความไปยังหน้า Register
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // เพิ่ม Navigator เพื่อไปยังหน้า Register ที่นี่
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
                    },
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: GoogleFonts.roboto(
                          color: AppColors.textprimary, 
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: "Register",
                            style: GoogleFonts.roboto(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
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

  // ใช้ Widget แบบเดียวกันกับหน้า Register เพื่อคุมธีมให้ตรงกัน
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: GoogleFonts.roboto(color: AppColors.textprimary), 
      decoration: InputDecoration(
        labelText: label,
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