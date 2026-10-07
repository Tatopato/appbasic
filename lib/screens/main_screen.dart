import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants/minimal_ui.dart';
import '../services/user_data_service.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'profile_screen.dart';
import 'search_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Create this account's profile document the first time it signs in.
    UserDataService.instance.ensureProfile().catchError((Object _) {});
  }

  @override
  Widget build(BuildContext context) {
    // Safety net: without a signed-in account there is no data to show.
    if (FirebaseAuth.instance.currentUser == null) {
      return const LoginScreen();
    }

    return Scaffold(
      backgroundColor: Mi.bg,
      // IndexedStack keeps each tab alive (scroll position, open streams).
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          HomeScreen(),
          SearchScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Mi.surface,
          border: Border(top: BorderSide(color: Mi.line)),
        ),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            labelTextStyle: WidgetStateProperty.resolveWith((states) {
              final selected = states.contains(WidgetState.selected);
              return Mi.body(
                size: 12,
                color: selected ? Mi.accent : Mi.sub,
                weight: selected ? FontWeight.w700 : FontWeight.w500,
              );
            }),
          ),
          child: NavigationBar(
            height: 64,
            elevation: 0,
            backgroundColor: Mi.surface,
            surfaceTintColor: Colors.transparent,
            indicatorColor: Mi.accent.withValues(alpha: 0.12),
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) =>
                setState(() => _currentIndex = index),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined, color: Mi.sub),
                selectedIcon: Icon(Icons.home_rounded, color: Mi.accent),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.search_rounded, color: Mi.sub),
                selectedIcon: Icon(Icons.search_rounded, color: Mi.accent),
                label: 'Search',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline_rounded, color: Mi.sub),
                selectedIcon: Icon(Icons.person_rounded, color: Mi.accent),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
