import 'package:alumni_busfa/views/admin/dashboard/admin_dashboard.dart';
import 'package:alumni_busfa/views/user/user_home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:alumni_busfa/views/splash.dart';
import 'package:alumni_busfa/views/welcome_page.dart';

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
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/': (context) => WelcomePage(),
        '/admin-dashboard': (context) => AdminDashboard(),
        '/user-dashboard': (context) => UserHome(),
      },
    );
  }
}
