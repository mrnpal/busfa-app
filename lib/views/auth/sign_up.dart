import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '/services/auth_service.dart';
import 'login_page.dart';

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

      setState(() => isLoading = false);

      if (result == 'Pendaftaran berhasil. Tunggu verifikasi admin.') {
        emailController.clear();
        passwordController.clear();
        nameController.clear();
        addressController.clear();
        phoneController.clear();
        jobController.clear();
        graduationYearController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              'Registrasi berhasil, Tunggu verifikasi admin.',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        setState(() => message = result);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    FadeInUp(
                      duration: Duration(milliseconds: 1000),
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    FadeInUp(
                      duration: Duration(milliseconds: 1200),
                      child: Text(
                        "Lengkapi data untuk registrasi alumni",
                        style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      FadeInUp(
                        duration: Duration(milliseconds: 1200),
                        child: makeInput("Nama", nameController),
                      ),
                      FadeInUp(
                        duration: Duration(milliseconds: 1250),
                        child: makeInput("Email", emailController),
                      ),
                      FadeInUp(
                        duration: Duration(milliseconds: 1300),
                        child: makeInput(
                          "Password",
                          passwordController,
                          obscureText: true,
                          minLength: 6,
                        ),
                      ),
                      FadeInUp(
                        duration: Duration(milliseconds: 1350),
                        child: makeInput("No HP", phoneController),
                      ),
                      FadeInUp(
                        duration: Duration(milliseconds: 1400),
                        child: makeInput("Alamat", addressController),
                      ),
                      FadeInUp(
                        duration: Duration(milliseconds: 1450),
                        child: makeInput("Pekerjaan", jobController),
                      ),
                      FadeInUp(
                        duration: Duration(milliseconds: 1500),
                        child: makeInput(
                          "Tahun Lulus",
                          graduationYearController,
                        ),
                      ),
                    ],
                  ),
                ),
                FadeInUp(
                  duration: Duration(milliseconds: 1550),
                  child: Container(
                    padding: EdgeInsets.only(top: 3, left: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.black),
                    ),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      onPressed: isLoading ? null : _register,
                      color: Colors.greenAccent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        isLoading ? "Tunggu..." : "Sign up",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
                if (message != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(message!, style: TextStyle(color: Colors.red)),
                  ),
                FadeInUp(
                  duration: Duration(milliseconds: 1600),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Already have an account?"),
                      TextButton(
                        child: Text(
                          " Login",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget makeInput(
    String label,
    TextEditingController controller, {
    bool obscureText = false,
    int minLength = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 5),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator:
              (v) =>
                  (v == null || v.trim().length < minLength)
                      ? 'Wajib diisi'
                      : null,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
