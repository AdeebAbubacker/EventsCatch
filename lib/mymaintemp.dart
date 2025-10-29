// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:pushset/custom_banner.dart';
// import 'firebase_options.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
// import 'package:firebase_app_installations/firebase_app_installations.dart';



// // Initialize local notifications plugin
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// // Background handler
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   print('Background message: ${message.notification?.title}');
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//   const AndroidInitializationSettings initAndroid =
//       AndroidInitializationSettings('@mipmap/ic_launcher');
//   const InitializationSettings initSettings =
//       InitializationSettings(android: initAndroid);

//   await flutterLocalNotificationsPlugin.initialize(initSettings);

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Firebase Notifications',
//       theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.green)),
//       home: const NotificationHome(),
//     );
//   }
// }

// class NotificationHome extends StatefulWidget {
//   const NotificationHome({super.key});

//   @override
//   State<NotificationHome> createState() => _NotificationHomeState();
// }

// class _NotificationHomeState extends State<NotificationHome> {
//   OverlayEntry? _overlayEntry;
//   String? _token;
//   String _lastMessage = "No messages yet";

//   @override
//   void initState() {
//     super.initState();
//      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       _showInAppNotification(
//         title: message.notification?.title ?? "No title",
//         body: message.notification?.body ?? "No body",
//         imageUrls: [
//           "https://your-image-url.png",
//           "https://your-image-url.png",
//           "https://your-image-url.png",
//           "https://your-image-url.png",
//           ],
//       );
//     });
//     _initNotifications();
//   }

// void _showInAppNotification({
//   required String title,
//   required String body,
//   List<String>? imageUrls,
// }) {
//   _overlayEntry?.remove(); 

//   final bucket = PageStorageBucket(); 

// _overlayEntry = OverlayEntry(
//   builder: (context) => Material(
//     color: Colors.transparent,
//     child: Stack(
//       children: [
//         Positioned(
//           top: 50,
//           left: 0,
//           right: 0,
//           child: InAppNotificationBanner(
//             title: title,
//             body: body,
//             imageUrls: imageUrls,
//             onClose: () {
//               _overlayEntry?.remove();
//               _overlayEntry = null;
//             },
//           ),
//         ),
//       ],
//     ),
//   ),
// );
//  Overlay.of(context).insert(_overlayEntry!);

//   // Auto dismiss after 5 seconds
//   Future.delayed(const Duration(seconds: 5), () {
//     _overlayEntry?.remove();
//     _overlayEntry = null;
//   });
// }
//  Future<void> _initNotifications() async {
//     // Ask for permission
//     NotificationSettings settings =
//         await FirebaseMessaging.instance.requestPermission();

//     print('Permission: ${settings.authorizationStatus}');

//     // Get FCM token
//     _token = await FirebaseMessaging.instance.getToken();
//     print("FCM Token: $_token");

//     // Foreground message handler
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       _handleMessage(message, isForeground: true);
//     });

//     // App opened via notification
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       _handleMessage(message, openedFromNotification: true);
//     });
//   }

//   void _handleMessage(RemoteMessage message,
//       {bool isForeground = false, bool openedFromNotification = false}) {
//     final title = message.notification?.title ?? "No title";
//     final body = message.notification?.body ?? "";

//     setState(() {
//       if (openedFromNotification) {
//         _lastMessage = "Opened from notification: $title";
//       } else if (isForeground) {
//         _lastMessage = "Foreground message: $title";
//       } else {
//         _lastMessage = title;
//       }
//     });

//     // Show local notification if in foreground
//     if (isForeground) {
//       flutterLocalNotificationsPlugin.show(
//         message.hashCode,
//         title,
//         body,
//         const NotificationDetails(
//           android: AndroidNotificationDetails(
//             'high_importance_channel',
//             'High Importance Notifications',
//             importance: Importance.max,
//             priority: Priority.high,
//           ),
//         ),
//       );
//     }
//   }
//    String fid = '';
//   String fcmToken = '';

//   void _getFirebaseInfo() async {
//      try {
//       String? installationId = await FirebaseAppInstallations.instance.getId();
//       print('Firebase Installation ID: $installationId');
//     } catch (e) {
//       print('Error getting Firebase Installation ID: $e');
//     }
//   }
//   // Simulate normal push notification (for demo)
//   void _simulatePushNotification() {
//     setState(() {
//       _lastMessage = "Simulated normal push notification";
//     });
//   }

//   // Simulate in-app notification
//   void _simulateInAppNotification() {
//   _showInAppNotification(
//     title: "In-App Notification",
//     body: "This is a custom in-app notification",
//     imageUrls: [
//       "https://images.unsplash.com/photo-1501785888041-af3ef285b470",
//       "https://images.unsplash.com/photo-1501785888041-af3ef285b470",    
//       "https://images.unsplash.com/photo-1501785888041-af3ef285b470"
//       ], 
//   );

//   setState(() {
//     _lastMessage = "Simulated in-app notification";
//   });
// }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Firebase Notification Demo')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//              ElevatedButton(
//               onPressed: _getFirebaseInfo,
//               child: Text('Get Firebase Info'),
//             ),
//             Text(
//               "Last message:\n$_lastMessage",
//               textAlign: TextAlign.center,
//               style: const TextStyle(fontSize: 18),
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: () => _showTokenDialog(context),
//               child: const Text("Show Device Token"),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _simulatePushNotification,
//               child: const Text("Simulate Normal Push Notification"),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _simulateInAppNotification,
//               child: const Text("Simulate In-App Notification"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showTokenDialog(BuildContext context) {
//     print('oken: $_token');
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text('Device Token'),
//         content: SelectableText(_token ?? "Token not available"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Close'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// //------------------------------------------------------------------------------------------------------
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_app_installations/firebase_app_installations.dart';

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

///------------------------------------------------------------------------------------------
///