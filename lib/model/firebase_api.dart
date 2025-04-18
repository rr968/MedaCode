import 'dart:developer';

import '/main.dart';
import '/model/notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../controller/var.dart';

Future<void> handleBackgroundMessage(message) async {
  Notificationc.initialize(flutterLocalNotificationsPlugin);
  showTextNotification(
      title: message.notification?.title ?? "",
      body: message.notification?.body ?? "",
      fln: flutterLocalNotificationsPlugin);
}

class FirebaseApi {
  final fireabsemessaging = FirebaseMessaging.instance;
  Future<void> initNotification() async {
    try {
      final fsmToken = await fireabsemessaging.getToken();
      notificationToken = fsmToken;
      log("////fsm token//$notificationToken");
      FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
      FirebaseMessaging.onMessage.listen((message) {
        Notificationc.initialize(flutterLocalNotificationsPlugin);
        showTextNotification(
            title: message.notification?.title ?? "",
            body: message.notification?.body ?? "",
            fln: flutterLocalNotificationsPlugin);
      });
    } catch (_) {}
  }
}
