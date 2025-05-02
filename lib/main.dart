import 'package:alumni_busfa/views/admin/dashboard/admin_dashboard.dart';
import 'package:alumni_busfa/views/user/user_home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'views/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Busfa App',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/admin-dashboard': (context) => AdminDashboard(),
        '/user-dashboard': (context) => UserHome(),
      },
    );
  }
}
