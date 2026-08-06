//import 'package:app_name_v2/screens/login.dart';
import 'package:app_name_v2/screens/register_screen.dart';
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
      title: 'Profile Page',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),

      // routes: {
      //   '/':(context) => HomeScreen(),
      //   '/profile':(context) => ProfileScreen(),
      // },

      // initialRoute: '/profile',
      home: const RegisterScreen(),
    );
  }
}
