// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:alumni_busfa/views/ubah_kata_sandi.dart';
// import 'package:lucide_icons_flutter/lucide_icons.dart';
// import 'package:alumni_busfa/views/auth/login.dart';

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});

//   Future<void> _logout() async {
//     try {
//       await FirebaseAuth.instance.signOut(); // Logout dari Firebase
//       await GoogleSignIn().signOut(); // Logout dari Google

//       Get.offAll(() => const LoginScreen()); // Arahkan ke halaman login
//     } catch (e) {
//       Get.snackbar(
//         "Error",
//         "Gagal logout!",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }

//   void _showLogoutConfirmation() {
//     Get.defaultDialog(
//       title: "Konfirmasi Keluar",
//       middleText: "Apakah Anda yakin ingin keluar?",
//       textCancel: "Tidak",
//       textConfirm: "Ya",

//       confirmTextColor: Colors.white,
//       buttonColor: const Color.fromARGB(255, 116, 204, 245),
//       onConfirm: _logout,
//       onCancel: () {},
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;
//     String userName = user?.displayName ?? user?.email?.split('@')[0] ?? "User";
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Profil',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         centerTitle: false,
//       ),

//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//               height: 1,
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.2),
//                     blurRadius: 1,
//                     offset: const Offset(0, 1),
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 40,
//                     backgroundImage:
//                         user?.photoURL != null
//                             ? NetworkImage(user!.photoURL!)
//                             : const AssetImage('assets/images/profile-icon.png')
//                                 as ImageProvider,
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           userName,
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           user?.email ?? 'Email Pengguna',
//                           style: const TextStyle(color: Colors.grey),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const Divider(),

//             // Pengaturan
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16.0),
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   'Pengaturan',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 8),

//             // Item Menu
//             _buildMenuItem(
//               icon: LucideIcons.lock,
//               title: 'Ubah Kata Sandi',
//               onTap: () {
//                 Get.to(const UbahKataSandiScreens());
//               },
//             ),

//             _buildMenuItem(
//               icon: LucideIcons.logOut,
//               title: 'Keluar',
//               onTap: _showLogoutConfirmation, // Panggil fungsi logout
//             ),
//           ],
//         ),
//       ),

//       // Bottom Navigation Bar
//     );
//   }

//   Widget _buildMenuItem({
//     required IconData icon,
//     required String title,
//     required VoidCallback onTap,
//   }) {
//     return ListTile(
//       leading: Icon(icon, color: Colors.black),
//       title: Text(title),
//       trailing: const Icon(LucideIcons.chevronRight),
//       onTap: onTap,
//     );
//   }
// }
