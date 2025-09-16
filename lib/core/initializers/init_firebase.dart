// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
//
// import '../core.dart';
// import '../notifications/cloud_messaging_service.dart';
// import '../notifications/local_notification_service.dart';
//
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
// }
//
// Future<void> initApp() async {
//   /// background push notifications
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//
//   /// Initialize notifications
//   await sl.get<CloudMessagingService>().initialize();
//   await sl.get<LocalNotificationsService>().initialize();
// }
