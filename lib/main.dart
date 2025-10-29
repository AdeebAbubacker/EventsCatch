
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_app_installations/firebase_app_installations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pushset/initialPage.dart';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// Future<void> setupFlutterNotifications() async {
//   const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('@mipmap/ic_launcher');

//   const InitializationSettings initializationSettings =
//       InitializationSettings(android: initializationSettingsAndroid);

//   await flutterLocalNotificationsPlugin.initialize(initializationSettings);

//   // Foreground message listener
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     RemoteNotification? notification = message.notification;
//     AndroidNotification? android = notification?.android;

//     if (notification != null && android != null) {
//       flutterLocalNotificationsPlugin.show(
//         notification.hashCode,
//         notification.title,
//         notification.body,
//         const NotificationDetails(
//           android: AndroidNotificationDetails(
//             'default_channel_id',
//             'Default Channel',
//             importance: Importance.max,
//             priority: Priority.high,
//           ),
//         ),
//       );
//     }
//   });
// }


// /// ✅ Required for background messages
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print('🔔 Background message received: ${message.notification?.title}');
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();

//   /// ✅ Register background message handler
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   await setupFlutterNotifications();
//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   String? fcmToken;
//   String? errorMessage;

//   @override
//   void initState() {
//     super.initState();
//     _initializeFCM();
//   }

//   /// ✅ Initialize FCM and request permission
//   Future<void> _initializeFCM() async {
//     try {
//       NotificationSettings settings =
//           await FirebaseMessaging.instance.requestPermission();

//       print('🔔 Permission granted: ${settings.authorizationStatus}');

//       /// ✅ Listen for foreground messages
//       FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//         print('💬 Foreground message: ${message.notification?.title}');
//         print('📄 Message body: ${message.notification?.body}');
//       });

//       /// Get token right away
//       _getFcmToken();
//     } catch (e) {
//       print("Error initializing FCM: $e");
//     }
//   }

//   Future<void> _getFcmToken() async {
//     try {
//       final token = await FirebaseMessaging.instance.getToken();
//       print("📱 FCM Token: $token");
//       setState(() {
//         fcmToken = token;
//       });
//     } catch (e) {
//       setState(() {
//         errorMessage = 'Error getting FCM token: $e';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Firebase Installation & FCM Token'),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               FutureBuilder<String>(
//                 future: _getInstallationId(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const CircularProgressIndicator();
//                   } else if (snapshot.hasError) {
//                     return Text('Error: ${snapshot.error}');
//                   } else {
//                     print("Installation ID: ${snapshot.data}");
//                     return Text(
//                       'Installation ID: ${snapshot.data}',
//                       textAlign: TextAlign.center,
//                     );
//                   }
//                 },
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _getFcmToken,
//                 child: const Text('Get FCM Token'),
//               ),
//               if (fcmToken != null) ...[
//                 const SizedBox(height: 20),
//                 SelectableText(
//                   'FCM Token:\n$fcmToken',
//                   textAlign: TextAlign.center,
//                 ),

//                 ElevatedButton(onPressed: () {
                  
//                 }, child: Text("Called Firebase Event Hai"))
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// Future<String> _getInstallationId() async {
//   try {
//     return await FirebaseInstallations.instance.getId();
//   } catch (e) {
//     return 'Failed to get Installation ID: $e';
//   }
// }

// ///------------------------------------------------------------------------------------------
// ///


//----------------------------------------------------------


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? fcmToken;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Initialpage(),
    );
  }
}

