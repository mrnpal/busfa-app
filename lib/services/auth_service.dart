// import 'package:alumni_busfa/views/user/user_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:get/get.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<UserModel?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      String role = email == 'admin@busfa.com' ? 'admin' : 'user';

      // Kembalikan UserModel
      return UserModel(email: userCredential.user!.email!, role: role);
    } on FirebaseAuthException catch (e) {
      print('Error: ${e.message}');
      return null;
    }
  }

  void handleLogin(BuildContext context, String email, String password) async {
    final authService = AuthService();

    // Login menggunakan AuthService
    UserModel? user = await authService.login(email, password);

    if (user != null) {
      // Periksa role dan arahkan ke halaman yang sesuai
      if (user.role == 'admin') {
        Navigator.pushReplacementNamed(context, '/admin-dashboard');
      } else if (user.role == 'user') {
        Navigator.pushReplacementNamed(context, '/user-dashboard');
      }
    } else {
      // Tampilkan pesan error jika login gagal
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login gagal. Periksa email dan password Anda.'),
        ),
      );
    }
  }

  // Logout pengguna
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Mendapatkan pengguna saat ini
  User? get currentUser => _auth.currentUser;
}

// Login dengan Google
// Future<void> loginWithGoogle(BuildContext context) async {
//   final _auth = AuthService._auth;
//   try {
//     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//     if (googleUser == null) return;

//     final GoogleSignInAuthentication googleAuth =
//         await googleUser.authentication;
//     final AuthCredential credential = GoogleAuthProvider.credential(
//       accessToken: googleAuth.accessToken,
//       idToken: googleAuth.idToken,
//     );

//     // Login dengan Google
//     UserCredential userCredential = await _auth.signInWithCredential(
//       credential,
//     );

//     // Ambil email pengguna
//     String? email = userCredential.user?.email;

//     // Tentukan role berdasarkan email (contoh logika, sesuaikan dengan kebutuhan Anda)
//     String role = email == 'admin@busfa.com' ? 'admin' : 'user';

//     // Arahkan ke halaman yang sesuai berdasarkan role
//     if (role == 'admin') {
//       Navigator.pushReplacementNamed(context, '/admin-dashboard');
//     } else {
//       Navigator.pushReplacementNamed(context, '/user-dashboard');
//     }

//     // Tampilkan notifikasi sukses
//     Get.snackbar(
//       "Success",
//       "Login dengan Google berhasil!",
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Colors.green,
//       colorText: const Color.fromRGBO(255, 255, 255, 1),
//     );
//   } catch (e) {
//     // Tangani error login
//     Get.snackbar(
//       "Error",
//       "Login dengan Google gagal!",
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: const Color.fromRGBO(255, 0, 0, 1),
//       colorText: const Color.fromRGBO(255, 255, 255, 1),
//     );
//   }
// }
