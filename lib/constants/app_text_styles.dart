import 'package:app_name_v2/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle heading1 = GoogleFonts.itim(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textprimary,
  );

  static TextStyle heading2 = GoogleFonts.itim(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textprimary,
  );

  static TextStyle heading3 = GoogleFonts.itim(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColors.textprimary,
  );
}
