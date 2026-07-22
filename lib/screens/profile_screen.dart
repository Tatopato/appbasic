import 'package:app_name_v2/constants/app_colors.dart';

import '../constants/app_text_styles.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //profile Section
          Text('Profile Page', style: AppTextStyles.heading1),
          const SizedBox(height: 20),
          const CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.accent,
            backgroundImage: AssetImage('assets/images/profile.jpg'),
          ),
          Text('Email-xxxxxxx@gmail.com', style: AppTextStyles.heading1),
          Text('Phone-xxx-xxx-xxxx', style: AppTextStyles.heading1),

          //Account Setting
          const SizedBox(height: 20),
          Text('Accout Setting', style: AppTextStyles.heading1),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.bgsecondary,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ListTile(
                  leading: const Icon(Icons.lock, color: AppColors.primary),
                  title: Text('Change Password', style: AppTextStyles.heading1),
                  subtitle: Text(
                    "Change your password",
                    style: AppTextStyles.heading3,
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 30,
                    color: AppColors.secondary,
                  ),
                ),
                const Divider(color: AppColors.danger, thickness: 1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
