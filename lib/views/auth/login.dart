// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:alumni_busfa/views/lupa_password.dart';
// import 'package:alumni_busfa/views/auth/register.dart';
// import 'package:alumni_busfa/services/auth_controller.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final AuthService _authService = AuthService();

//   bool _isObscured = true;

//   @override
//   void dispose() {
//     emailController.dispose();
//     passwordController.dispose();
//     super.dispose();
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
//                 const Text(
//                   'Selamat Datang di',
//                   style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
//                 ),
//                 const Text(
//                   "LokaBis!",
//                   style: TextStyle(
//                     color: Colors.blue,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 32,
//                   ),
//                 ),
//                 const Text(
//                   'Silahkan login untuk melanjutkan',
//                   style: TextStyle(fontSize: 18, color: Colors.grey),
//                 ),

//                 const SizedBox(height: 40),
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
//                       onPressed:
//                           () => setState(() => _isObscured = !_isObscured),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     GestureDetector(
//                       onTap: () => Get.to(() => const LupaPasswordScreens()),
//                       child: const Text(
//                         'Lupa Password?',
//                         style: TextStyle(
//                           color: Colors.blue,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue,
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     onPressed:
//                         () => _authService.login(
//                           emailController.text,
//                           passwordController.text,
//                         ),
//                     child: const Text(
//                       'Login',
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
//                       child: Text("atau login dengan"),
//                     ),
//                     Expanded(child: Divider(color: Colors.grey, thickness: 1)),
//                   ],
//                 ),

//                 const SizedBox(height: 16),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     GestureDetector(
//                       onTap: () => _authService.loginWithGoogle(),
//                       child: Image.asset(
//                         'assets/images/google_logo.png',
//                         width: 50,
//                         height: 50,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text('Belum punya akun? '),
//                     GestureDetector(
//                       onTap: () => Get.to(() => const RegisterScreen()),
//                       child: const Text(
//                         'Sign Up',
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
