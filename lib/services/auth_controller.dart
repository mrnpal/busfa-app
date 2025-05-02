// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import 'package:alumni_busfa/views/main_screens.dart';

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   Future<void> login(String email, String password) async {
//     if (email.isEmpty || password.isEmpty) {
//       Get.snackbar(
//         "Error",
//         "Email dan Password tidak boleh kosong",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return;
//     }
//     try {
//       await _auth.signInWithEmailAndPassword(email: email, password: password);
//       Get.snackbar(
//         "Success",
//         "Login berhasil!",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.green,
//         colorText: const Color.fromRGBO(255, 255, 255, 1),
//       );
//       Get.offAll(() => const MainScreens());
//     } on FirebaseAuthException catch (e) {
//       String errorMsg = "Login gagal!";
//       if (e.code == 'user-not-found') errorMsg = "Email tidak terdaftar.";
//       if (e.code == 'wrong-password') errorMsg = "Password salah.";

//       Get.snackbar(
//         "Error",
//         errorMsg,
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: const Color.fromRGBO(255, 0, 0, 1),
//         colorText: const Color.fromRGBO(255, 255, 255, 1),
//       );
//     }
//   }

//   Future<void> register(String email, String password) async {
//     try {
//       await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       Get.snackbar(
//         "Success",
//         "Akun berhasil dibuat!",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.green,
//         colorText: const Color.fromRGBO(255, 255, 255, 1),
//       );
//       Get.offAll(() => const MainScreens());
//     } on FirebaseAuthException catch (e) {
//       String errorMsg = "Terjadi kesalahan";
//       if (e.code == 'email-already-in-use') errorMsg = "Email sudah terdaftar.";
//       if (e.code == 'weak-password') errorMsg = "Password terlalu lemah.";

//       Get.snackbar(
//         "Error",
//         errorMsg,
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: const Color.fromRGBO(255, 0, 0, 1),
//         colorText: const Color.fromRGBO(255, 255, 255, 1),
//       );
//     }
//   }

//   Future<void> loginWithGoogle() async {
//     try {
//       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//       if (googleUser == null) return;

//       final GoogleSignInAuthentication googleAuth =
//           await googleUser.authentication;
//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       await _auth.signInWithCredential(credential);
//       Get.snackbar(
//         "Success",
//         "Login dengan Google berhasil!",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.green,
//         colorText: const Color.fromRGBO(255, 255, 255, 1),
//       );
//       Get.offAll(() => const MainScreens());
//     } catch (e) {
//       Get.snackbar(
//         "Error",
//         "Login dengan Google gagal!",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: const Color.fromRGBO(255, 0, 0, 1),
//         colorText: const Color.fromRGBO(255, 255, 255, 1),
//       );
//     }
//   }
// }
