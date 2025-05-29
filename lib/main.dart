import 'package:alumni_busfa/maps/alumni_map_page.dart';
import 'package:alumni_busfa/views/activity_detail_page.dart';
import 'package:alumni_busfa/views/activity_page.dart';
import 'package:alumni_busfa/views/add_job_page.dart';
import 'package:alumni_busfa/views/auth/forget_password.dart';
import 'package:alumni_busfa/views/auth/login_page.dart';
import 'package:alumni_busfa/views/auth/sign_up.dart';
import 'package:alumni_busfa/views/edit_page.dart';
import 'package:alumni_busfa/views/group_chat_page.dart';
import 'package:alumni_busfa/views/job_page.dart';
import 'package:alumni_busfa/views/profil.dart';
import 'package:alumni_busfa/views/splash.dart';
import 'package:alumni_busfa/views/home_page.dart';
import 'package:alumni_busfa/views/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
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
        GetPage(name: '/add-job', page: () => AddJobPage()),
        GetPage(name: '/activity-detail', page: () => ActivityDetailPage()),
        GetPage(name: '/group-chat', page: () => GroupChatPage()),
        GetPage(name: '/forgot-pw', page: () => ForgetPasswordPage()),
        GetPage(name: '/edit-profile', page: () => EditProfilePage()),
      ],
    );
  }
}
