// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
// import 'package:alumni_busfa/views/auth/login.dart';
// import 'package:alumni_busfa/views/main_screens.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _checkLoginStatus();
//   }

  // void _checkLoginStatus() async {
  //   await Future.delayed(Duration(seconds: 2));
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     Get.offAll(() => const MainScreens());
  //   } else {
  //     Get.offAll(() => const LoginScreen());
  //   }
  // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               'assets/images/logo.png', // Path ke logo Anda
//               width: 150,
//               height: 150,
//             ),
//             const SizedBox(height: 20),
//             const CircularProgressIndicator(color: Colors.blue),
//           ],
//         ),
//       ),
//     );
//   }
// }
