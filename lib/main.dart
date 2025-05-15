import 'package:alumni_busfa/chat/chat.dart';

import 'package:alumni_busfa/maps/map.dart';
import 'package:alumni_busfa/maps/map_with_custom_info_windows.dart';
// import 'package:alumni_busfa/maps/map_circles.dart';
import 'package:alumni_busfa/views/activity_page.dart';
import 'package:alumni_busfa/views/profil.dart';
import 'package:alumni_busfa/views/user_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

        '/alumni-map': (context) => MapWithCustomInfoWindows(),
        '/profile': (context) => ProfileScreen(),
        '/user-dashboard': (context) => HomePage(),
        '/activities': (context) => ActivityPage(),
        '/grup': (context) => ChatGrupPage(),
      },
    );
  }
}
