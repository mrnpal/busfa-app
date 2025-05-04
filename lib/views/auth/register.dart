// import 'package:alumni_busfa/views/auth/login_screen.dart';
// import 'package:alumni_busfa/views/user/user_home.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// // import 'package:alumni_busfa/views/auth/login.dart';
// // import 'package:alumni_busfa/views/main_screens.dart';

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});

//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController namaController = TextEditingController();
//   final TextEditingController alamatController = TextEditingController();
//   final TextEditingController angkatanController = TextEditingController();

//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   bool _isObscured = true;

//   @override
//   void dispose() {
//     emailController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }

//   // Fungsi untuk daftar dengan email dan password
//   Future<void> _register() async {
//     String email = emailController.text.trim();
//     String password = passwordController.text.trim();

//     if (email.isEmpty ||
//         password.isEmpty ||
//         namaController.text.isEmpty ||
//         alamatController.text.isEmpty ||
//         angkatanController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Email dan Password tidak boleh kosong"),
//           backgroundColor: Colors.red,
//         ),
//       );

//       return;
//     }

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
//         colorText: Colors.white,
//       );
//       Get.offAll(
//         () => const LoginScreen(),
//       ); // Arahkan ke login setelah registrasi
//     } on FirebaseAuthException catch (e) {
//       String errorMsg = "Terjadi kesalahan";
//       if (e.code == 'email-already-in-use') {
//         errorMsg = "Email sudah terdaftar. Gunakan email lain.";
//       } else if (e.code == 'weak-password') {
//         errorMsg = "Password terlalu lemah. Gunakan password yang lebih kuat.";
//       }
//       Get.snackbar(
//         "Error",
//         errorMsg,
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }

//   // Fungsi untuk login/daftar dengan akun Google
//   Future<void> _signInWithGoogle() async {
//     try {
//       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//       if (googleUser == null) return; // Jika user batal login

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
//         colorText: Colors.white,
//       );
//       Get.offAll(() => UserHome()); // Pindah ke login setelah berhasil
//     } catch (e) {
//       Get.snackbar(
//         "Error",
//         "Login dengan Google gagal!",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(24.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Center(
//                   child: Image.asset('assets/images/logo2.png', height: 150),
//                 ),
//                 const SizedBox(height: 32),
//                 const Text(
//                   'Buat Akun',
//                   style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 8),
//                 const Text(
//                   'Daftar untuk mulai menggunakan aplikasi',
//                   style: TextStyle(fontSize: 18, color: Colors.grey),
//                 ),
//                 const SizedBox(height: 32),
//                 TextField(
//                   controller: namaController,
//                   decoration: InputDecoration(
//                     labelText: 'Nama',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     prefixIcon: const Icon(Icons.person),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 TextField(
//                   controller: emailController,
//                   decoration: InputDecoration(
//                     labelText: 'Email',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     prefixIcon: const Icon(Icons.email),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 TextField(
//                   controller: alamatController,
//                   decoration: InputDecoration(
//                     labelText: 'alamat',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     prefixIcon: const Icon(Icons.location_city),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 TextField(
//                   controller: angkatanController,
//                   decoration: InputDecoration(
//                     labelText: 'Tahun Angkatan',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     prefixIcon: const Icon(Icons.calendar_today),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 TextField(
//                   controller: passwordController,
//                   obscureText: _isObscured,
//                   decoration: InputDecoration(
//                     labelText: 'Password',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     prefixIcon: const Icon(Icons.lock),
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _isObscured ? Icons.visibility_off : Icons.visibility,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           _isObscured = !_isObscured; // Toggle visibility
//                         });
//                       },
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: _register,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue,
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child: const Text(
//                       'Daftar',
//                       style: TextStyle(color: Colors.white, fontSize: 18),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   children: [
//                     Expanded(child: Divider(color: Colors.grey, thickness: 1)),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                       child: Text("atau daftar dengan"),
//                     ),
//                     Expanded(child: Divider(color: Colors.grey, thickness: 1)),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 // Tombol Login dengan Google
//                 Center(
//                   child: GestureDetector(
//                     onTap: _signInWithGoogle,
//                     child: Image.asset(
//                       'assets/images/google_logo.png',
//                       width: 48,
//                       height: 48,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text('Sudah punya akun? '),
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => LoginScreen(),
//                           ),
//                         );
//                       },
//                       child: const Text(
//                         'Login',
//                         style: TextStyle(
//                           color: Colors.blue,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
