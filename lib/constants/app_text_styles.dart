import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// อย่าลืมแก้ path import ให้ตรงกับโปรเจกต์ของคุณ
import 'app_colors.dart'; 

class AppTextStyles {
  AppTextStyles._();

  static TextStyle heading1 = GoogleFonts.montserrat(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textprimary,
  );

  static TextStyle heading2 = GoogleFonts.montserrat(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textprimary,
  );

  static TextStyle heading3 = GoogleFonts.montserrat(
    fontSize: 24, // ปรับลดขนาดลงนิดหน่อยให้ต่างจาก heading2
    fontWeight: FontWeight.w600,
    color: AppColors.textprimary,
  );

  // เพิ่ม bodyText สำหรับข้อความทั่วไป
  static TextStyle bodyText = GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textsecondary,
  );
}