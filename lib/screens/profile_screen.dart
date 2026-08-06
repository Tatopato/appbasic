import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgsecondary,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // หัวข้อหน้า
            Text(
              'My Profile', 
              style: AppTextStyles.heading1,
            ),
            const SizedBox(height: 30),

            // 1. รูปโปรไฟล์พร้อมไอคอนแก้ไข (ซ้อนกันด้วย Stack)
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  padding: const EdgeInsets.all(4), // ขอบสีขาวรอบรูป
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const CircleAvatar(
                    radius: 70,
                    backgroundColor: AppColors.accent,
                    backgroundImage: AssetImage('assets/images/handsome.jpg'),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 2. ป้ายข้อความ "หมูกรอบ" (แก้ Padding ไม่ให้เกินจอ)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.5), width: 1.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'หมูกรอบ',
                    style: AppTextStyles.heading3.copyWith(
                      fontSize: 16,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.edit, size: 16, color: AppColors.primary),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // 3. การ์ดข้อมูลส่วนตัว (ใส่พื้นหลังสีขาวและเพิ่มเงา)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileInfoRow(
                    icon: Icons.person_outline,
                    text: 'Narathip Saleekul',
                  ),
                  const Divider(height: 24, thickness: 1, color: Colors.black12),
                  _buildProfileInfoRow(
                    icon: Icons.email_outlined,
                    text: 'gamemode30082547@gmail.com',
                  ),
                  const Divider(height: 24, thickness: 1, color: Colors.black12),
                  _buildProfileInfoRow(
                    icon: Icons.phone_android,
                    text: '062-801-5631',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // 4. การ์ด Account Setting (เปลี่ยนจากเส้นขอบเป็นการใช้เงา)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                    child: Text(
                      'Account Setting',
                      style: AppTextStyles.heading1.copyWith(
                        fontSize: 20, 
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  
                  // เมนูย่อย
                  _buildSettingMenu(
                    icon: Icons.lock_outline,
                    title: 'Change Password',
                    subtitle: 'Change your current password',
                    onTap: () {},
                  ),
                  const Divider(color: Colors.black12, thickness: 1, height: 1),

                  _buildSettingMenu(
                    icon: Icons.language,
                    title: 'Language',
                    subtitle: 'English', // แสดงภาษาปัจจุบัน
                    onTap: () {},
                  ),
                  const Divider(color: Colors.black12, thickness: 1, height: 1),

                  _buildSettingMenu(
                    icon: Icons.notifications_none,
                    title: 'Notifications',
                    onTap: () {},
                  ),
                  const Divider(color: Colors.black12, thickness: 1, height: 1),

                  // เมนู Help & Support และ Terms ที่มีอยู่แล้ว...
                  _buildSettingMenu(
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    onTap: () {},
                  ),
                  const Divider(color: Colors.black12, thickness: 1, height: 1),

                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.danger.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.delete_outline, color: AppColors.danger),
                    ),
                    title: Text(
                      'Delete Account', 
                      style: AppTextStyles.heading1.copyWith(
                        fontSize: 16, 
                        color: AppColors.danger,
                      ),
                    ),
                    onTap: () {
                      // แจ้งเตือน Dialog ยืนยันการลบ
                    },
                  ),
                  const Divider(color: Colors.black12, thickness: 1, height: 1),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      )
    );
  }
  Widget _buildProfileInfoRow({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.heading1.copyWith(fontSize: 16), // ปรับขนาดฟอนต์ให้เล็กลง
            overflow: TextOverflow.ellipsis, // ตัดคำถ้าอีเมลยาวเกินไป
          ),
        ),
      ],
    );
  }

  // Widget ช่วยสร้างเมนูตั้งค่า
  Widget _buildSettingMenu({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.bgsecondary.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primary),
      ),
      title: Text(
        title,
        style: AppTextStyles.heading1.copyWith(fontSize: 16),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: GoogleFonts.roboto(fontSize: 13, color: Colors.grey.shade600),
            )
          : null,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}