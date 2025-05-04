import 'package:alumni_busfa/views/user/user_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Controllers for registration fields
  final TextEditingController registerEmailController = TextEditingController();
  final TextEditingController registerPasswordController =
      TextEditingController();
  final TextEditingController registerNameController = TextEditingController();

  // State variable to track login status
  bool isLogin = false;

  // Fungsi Login
  Future<UserModel?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      String role = email == 'admin@busfa.com' ? 'admin' : 'user';

      return UserModel(email: userCredential.user!.email!, role: role);
    } on FirebaseAuthException catch (e) {
      print('Login Error: ${e.message}');
      return null;
    }
  }

  // Fungsi Register
  Future<UserModel?> register(String email, String password) async {
    try {
      // Mencoba mendaftarkan pengguna
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // Registrasi berhasil
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        // Email sudah digunakan
        throw Exception('Email sudah digunakan.');
      } else if (e.code == 'invalid-email') {
        // Email tidak valid
        throw Exception('Email tidak valid.');
      } else if (e.code == 'weak-password') {
        // Password terlalu lemah
        throw Exception('Password terlalu lemah.');
      } else {
        // Kesalahan lainnya
        throw Exception('Terjadi kesalahan. Silakan coba lagi.');
      }
    } catch (e) {
      // Kesalahan umum
      throw Exception('Terjadi kesalahan. Silakan coba lagi.');
    }
  }

  // Handler Login
  void handleLogin(BuildContext context, String email, String password) async {
    final authService = AuthService();

    UserModel? user = await authService.login(email, password);

    if (user != null) {
      if (user.role == 'admin') {
        Navigator.pushReplacementNamed(context, '/admin-dashboard');
      } else {
        Navigator.pushReplacementNamed(context, '/user-dashboard');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login gagal. Periksa email dan password Anda.'),
        ),
      );
    }
  }

  // Handler Register
  void handleRegister(BuildContext context) async {
    final authService = AuthService();
    if (registerEmailController.text.isEmpty ||
        registerPasswordController.text.isEmpty ||
        registerNameController.text.isEmpty) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text('Registrasi Gagal'),
              content: Text('Semua field harus diisi.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
      );
      return;
    }

    final UserModel? user = await authService.register(
      registerEmailController.text,
      registerPasswordController.text,
    );

    if (user == null) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text('Registrasi Gagal'),
              content: Text('Email sudah digunakan atau terjadi kesalahan.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
      );
    } else {
      // Notify the UI to update the state (e.g., using a callback or state management solution)
      isLogin = true; // Beralih ke halaman login setelah berhasil daftar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registrasi berhasil, silakan login.')),
      );
    }
  }

  // Login dengan Google
  Future<void> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      Get.snackbar(
        "Success",
        "Login dengan Google berhasil!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: const Color.fromRGBO(255, 255, 255, 1),
      );
      Get.offAll(() => UserHome());
    } catch (e) {
      Get.snackbar(
        "Error",
        "Login dengan Google gagal!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color.fromRGBO(255, 0, 0, 1),
        colorText: const Color.fromRGBO(255, 255, 255, 1),
      );
    }
  }
}
