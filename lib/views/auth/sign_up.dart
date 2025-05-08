import 'package:flutter/material.dart';
import '/services/auth_service.dart'; // tempat fungsi registerAlumni

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final jobController = TextEditingController();
  final graduationYearController = TextEditingController();

  bool isLoading = false;
  String? message;

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      final result = await registerAlumni(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        name: nameController.text.trim(),
        address: addressController.text.trim(),
        phone: phoneController.text.trim(),
        job: jobController.text.trim(),
        graduationYear: graduationYearController.text.trim(),
      );
      setState(() {
        isLoading = false;
        message = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Daftar Alumni")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Nama'),
                validator: (v) => v!.isEmpty ? 'Isi nama' : null,
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (v) => v!.isEmpty ? 'Isi email' : null,
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (v) => v!.length < 6 ? 'Min 6 karakter' : null,
              ),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'No HP'),
              ),
              TextFormField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Alamat'),
              ),
              TextFormField(
                controller: jobController,
                decoration: InputDecoration(labelText: 'Pekerjaan'),
              ),
              TextFormField(
                controller: graduationYearController,
                decoration: InputDecoration(labelText: 'Tahun Lulus'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: isLoading ? null : _register,
                child: Text(isLoading ? "Tunggu..." : "Daftar"),
              ),
              if (message != null)
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(message!, style: TextStyle(color: Colors.red)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
