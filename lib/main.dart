import 'package:finaltest/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '/controller/provider.dart';
import '/controller/var.dart';
import '/view/splashscreen/splashscreen.dart';
import 'model/firebase_api.dart';
import 'model/notification.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await requestNotificationPermission();
  await Notificationc.initialize(flutterLocalNotificationsPlugin);
  await FirebaseApi().initNotification();

  runApp(const MyApp());
}

Future<void> requestNotificationPermission() async {
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return ChangeNotifierProvider(
      create: (context) => MyProvider(),
      child: MaterialApp(
        title: 'Meda',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: orange, hintColor: Colors.black),
        home: const SplashScreen(),
        builder: (context, child) {
          final mediaQueryData = MediaQuery.of(context);
          final scale = mediaQueryData.textScaleFactor.clamp(1.2, 1.2);
          return MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(scale)),
            child: child!,
          );
        },
      ),
    );
  }
}
