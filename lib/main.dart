import 'screens/login_page.dart';
import 'screens/register_page.dart';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/profile_page.dart';

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
      initialRoute: '/login',
      // initialRoute: '/',

      routes: {
        '/': (context) => const HomeScreen(),
        // '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfileScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        //'/mainPage': (context) => const MainPage(),
        //'/intro': (context) => const IntroScreen(),
      },
    );
  }
}
