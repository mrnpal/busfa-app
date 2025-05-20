import 'package:alumni_busfa/maps/alumni_map_page.dart';
import 'package:alumni_busfa/views/activity_detail_page.dart';
import 'package:alumni_busfa/views/activity_page.dart';
import 'package:alumni_busfa/views/add_job_page.dart';
import 'package:alumni_busfa/views/auth/login_page.dart';
import 'package:alumni_busfa/views/auth/sign_up.dart';
import 'package:alumni_busfa/views/group_chat_page.dart';
import 'package:alumni_busfa/views/job_page.dart';
import 'package:alumni_busfa/views/profil.dart';
import 'package:alumni_busfa/views/splash.dart';
import 'package:alumni_busfa/views/user_home.dart';
import 'package:alumni_busfa/views/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Inisialisasi plugin notifikasi lokal
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// // Handle notifikasi background
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   _showNotification(message);
// }

// Tampilkan notifikasi lokal
// void _showNotification(RemoteMessage message) {
//   final notification = message.notification;
//   final android = notification?.android;
//   if (notification != null && android != null) {
//     flutterLocalNotificationsPlugin.show(
//       notification.hashCode,
//       notification.title,
//       notification.body,
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           'group_chat_channel',
//           'Group Chat',
//           channelDescription: 'Notifikasi pesan grup alumni',
//           importance: Importance.max,
//           priority: Priority.high,
//           showWhen: true,
//         ),
//       ),
//     );
//   }
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // // Setup background handler
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // // Inisialisasi notifikasi lokal
  // const AndroidInitializationSettings initializationSettingsAndroid =
  //     AndroidInitializationSettings('@mipmap/ic_launcher');

  // const InitializationSettings initializationSettings = InitializationSettings(
  //   android: initializationSettingsAndroid,
  // );

  // await flutterLocalNotificationsPlugin.initialize(initializationSettings);

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

    // Subscribe ke topik agar semua user bisa menerima notifikasi grup
    // FirebaseMessaging.instance.subscribeToTopic('groupChat');

    // // Handle notifikasi ketika aplikasi sedang dibuka
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   _showNotification(message);
    // });

    // // (Opsional) Log token FCM
    // FirebaseMessaging.instance.getToken().then((token) {
    //   print("FCM Token: $token");
    // });
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
      ],
    );
  }
}
