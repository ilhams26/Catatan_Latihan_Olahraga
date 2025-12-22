import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'leaderboard_screen.dart'; // Import Baru
import 'bmi_screen.dart'; // Import Baru

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;

  // Daftar Halaman (Urutan 0, 1, 2, 3)
  final List<Widget> _pages = [
    const HomeScreen(), // 0
    const LeaderboardScreen(), // 1
    const BmiScreen(), // 2
    const ProfileScreen(), // 3
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        // Gunakan NavigationBar (Material 3) agar lebih modern dari BottomNavigationBar
        selectedIndex: _index,
        onDestinationSelected: (val) => setState(() => _index = val),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.fitness_center_outlined),
            selectedIcon: Icon(Icons.fitness_center),
            label: 'Latihan',
          ),
          NavigationDestination(
            icon: Icon(Icons.leaderboard_outlined),
            selectedIcon: Icon(Icons.leaderboard),
            label: 'Rank',
          ),
          NavigationDestination(
            icon: Icon(Icons.calculate_outlined),
            selectedIcon: Icon(Icons.calculate),
            label: 'BMI',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
