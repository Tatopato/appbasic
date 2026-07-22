import 'package:app_name_v2/screens/profile_screen.dart';
import 'package:flutter/material.dart';
//import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Name V2 DEMO',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),

      // routes: {
      //   '/':(context) => HomeScreen(),
      //   '/profile':(context) => ProfileScreen(),
      // },

      // initialRoute: '/profile',
      home: const ProfileScreen(),
    );
  }
}
