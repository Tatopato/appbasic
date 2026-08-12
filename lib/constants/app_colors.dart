import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // main color
  static const Color primary = Color(0xFF1565C0);
  static const Color secondary = Color.fromRGBO(255, 30, 230, 1);
  static const Color accent = Color.fromRGBO(250, 127, 97, 1);

  // Background color (ปรับให้เป็น Minimal อ่อนสบายตา)
  static const Color bgprimary = Color(0xFFF9F9F9); // ขาวอมเทาอ่อน
  static const Color bgsecondary = Color(0xFFFFFFFF); // ขาวล้วนสำหรับ Card

  // text color
  static const Color textprimary = Color(0xFF1F1F1F); // ดำเทา ไม่ดำสนิท
  static const Color textsecondary = Color(0xFF8E8E93); // เทา (แก้จากสีแดงเพื่อให้ดู Minimal)

  // status color
  static const Color success = Color.fromARGB(255, 4, 230, 15);
  static const Color danger = Color.fromARGB(255, 172, 4, 4);
  static const Color warning = Color.fromARGB(255, 238, 255, 0);

  // --- สีใหม่สำหรับหน้าโปรไฟล์ ---
  static const Color primaryBlue = Color(0xFFE3F2FD); // ฟ้าอ่อนมาก
  static const Color secondaryBlue = Color(0xFFF4F8FB); // ฟ้าที่จางลงเกือบขาว
  static const Color primaryText = Color(0xFF263238); // เทาเข้ม (ใช้แทน textprimary เดิม)
  static const Color secondaryText = Color(0xFF546E7A); // เทา (ใช้แทน textsecondary เดิม)
  static const Color cardBackground = Color(0xFFFFFFFF); // ขาว
  static const Color accentBlue = Color(0xFF42A5F5); // ฟ้าสดใส
}