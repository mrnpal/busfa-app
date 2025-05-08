import 'package:alumni_busfa/views/auth/sign_up.dart';
import 'package:flutter/material.dart';
import '/services/auth_service.dart';
import '/views/user/user_home.dart'; // tempat halaman utama setelah login

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? message;
  bool isLoading = false;

  void _login() async {
    setState(() => isLoading = true);
    final result = await loginAlumni(
      emailController.text.trim(),
      passwordController.text.trim(),
    );
    setState(() {
      isLoading = false;
      if (result != null) {
        message = result;
      } else {
        Navigator.pushReplacementNamed(
          context,
          '/user-dashboard',
        ); // atau halaman utama
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login Alumni")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : _login,
              child: Text(isLoading ? "Memproses..." : "Login"),
            ),
            if (message != null)
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(message!, style: TextStyle(color: Colors.red)),
              ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: Text("Belum punya akun? Daftar di sini"),
            ),
          ],
        ),
      ),
    );
  }
}
