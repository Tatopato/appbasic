import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import 'package:flutter/material.dart';
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgprimary,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Text('My Profile ', style: AppTextStyles.heading1),
                const SizedBox(height: 0),
              ],
            ),
          ),
          Center(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 80,
                  backgroundColor: AppColors.accent,
                  backgroundImage: AssetImage('assets/images/handsome.jpg'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.email_outlined,
                      color: AppColors.primary,
                      size: 26,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'gamemode30082547@gmail.com',
                      style: AppTextStyles.heading1,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.phone_android,
                      color: AppColors.primary,
                      size: 26,
                    ),
                    const SizedBox(width: 12),
                    Text('062-801-5631', style: AppTextStyles.heading1),
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.person_outline,
                color: AppColors.primary,
                size: 26,
              ),
              const SizedBox(width: 10),
              Text('Name : Narathip Saleekul', style: AppTextStyles.heading1),
            ],
          ),
         
           Padding(
            padding: const EdgeInsets.symmetric(horizontal: 250.0),
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: Colors.grey.shade400,
                      width: 1.2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'หมูกรอบ',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.heading3.copyWith(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: GestureDetector(
                    child: const Icon(
                      Icons.edit, size: 18, color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          //Account Setting
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300, width: 1.5),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Material(
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Account Setting',
                          style: AppTextStyles.heading1.copyWith(
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.lock, color: AppColors.primary),
                    title: Text(
                      'Change Password',
                      style: AppTextStyles.heading1,
                    ),
                    subtitle: Text(
                      "Change your password",
                      style: AppTextStyles.heading3,
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                      color: AppColors.secondary,
                    ),
                    onTap: () {},
                  ),
                  const Divider(color: Colors.black12, thickness: 1, height: 1),
 
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.help_outline,
                      color: AppColors.primary,
                    ),
                    title: Text(
                      'Help & Support',
                      style: AppTextStyles.heading1,
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                      color: AppColors.secondary,
                    ),
                    onTap: () {},
                  ),
                  const Divider(color: Colors.black12, thickness: 1, height: 1),
 
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.description_outlined,
                      color: AppColors.primary,
                    ),
                    title: Text(
                      'Terms & Privacy Policy',
                      style: AppTextStyles.heading1,
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                      color: AppColors.secondary,
                    ),
                    onTap: () {},
                  ),
                  const SizedBox(height: 24),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.exit_to_app,
                      color: AppColors.danger,
                    ),
                    title: Text('Logout', style: AppTextStyles.heading1),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
      )
    );
  }
}