import 'package:alumni_busfa/maps/alumni_map_page.dart';
import 'package:alumni_busfa/views/activity_page.dart';
import 'package:alumni_busfa/views/auth/login_page.dart';
import 'package:alumni_busfa/views/auth/sign_up.dart';
import 'package:alumni_busfa/views/job_page.dart';
import 'package:alumni_busfa/views/profil.dart';
import 'package:alumni_busfa/views/splash.dart';
import 'package:alumni_busfa/views/user_home.dart';
import 'package:alumni_busfa/views/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => SplashScreen()),
        GetPage(name: '/welcome-page', page: () => WelcomePage()),
        GetPage(name: '/register', page: () => RegisterPage()),
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/user-dashboard', page: () => HomePage()),
        GetPage(name: '/profile', page: () => ProfileScreen()),
        GetPage(name: '/alumni-map', page: () => AlumniMapPage()),
        GetPage(name: '/activities', page: () => ActivityPage()),
        GetPage(name: '/job', page: () => JobPage()),
      ],
    );
  }
}
