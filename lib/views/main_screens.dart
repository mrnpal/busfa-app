// // main_screens.dart
// import 'package:flutter/material.dart';
// import 'package:alumni_busfa/views/user/dashboard.dart';
// import 'package:alumni_busfa/views/info.dart';
// import 'package:alumni_busfa/views/profil.dart';
// import 'package:lucide_icons_flutter/lucide_icons.dart';

// class MainScreens extends StatefulWidget {
//   const MainScreens({super.key});

//   @override
//   State<MainScreens> createState() => _MainScreensState();
// }

// class _MainScreensState extends State<MainScreens> {
//   int _selectedIndex = 0;

//   final List<Widget> _pages = [
//     const HomeScreen(),
//     const InfoScreen(),
//     const ProfileScreen(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() => _selectedIndex = index);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         selectedItemColor: Colors.blue,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
//           BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Info'),
//           BottomNavigationBarItem(
//             icon: Icon(LucideIcons.user),
//             label: 'Profil',
//           ),
//         ],
//       ),
//     );
//   }
// }
