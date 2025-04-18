// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import '/controller/language.dart';
import '/model/noti.dart';
import 'package:flutter/material.dart';

import '../../controller/no_imternet.dart';
import '../../controller/textstyle.dart';
import '../../controller/var.dart';
import 'package:http/http.dart' as http;

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final List<Noti> notifications = [];

  bool isLoading = true;
  @override
  void initState() {
    getAllNotifications();
    makeAllNotificationsSeen();
    super.initState();
  }

  makeAllNotificationsSeen() async {
    String userId = await getUserId();
    String url = isUserNow
        ? '$baseUrl/notification.php?input_key=$input_key&input_secret=$input_secret&user_id=$userId&scenario=4&target=0'
        : '$baseUrl/notification.php?input_key=$input_key&input_secret=$input_secret&STEjari=$sTejariValue&scenario=4&target=1';
    var request = http.Request('GET', Uri.parse(url));

    http.StreamedResponse response = await request.send();
  }

  getAllNotifications() async {
    String userId = await getUserId();
    String url = isUserNow
        ? '$baseUrl/notification.php?input_key=$input_key&input_secret=$input_secret&user_id=$userId&scenario=3&target=0'
        : '$baseUrl/notification.php?input_key=$input_key&input_secret=$input_secret&STEjari=$sTejariValue&scenario=3&target=1';
    var request = http.Request('GET', Uri.parse(url));

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      Map data = json.decode(await response.stream.bytesToString());
      log(data.toString());
      if (data["status"] == "success") {
        data["data"].forEach((element) {
          notifications.add(Noti(
              id: element["id"].toString(),
              title: element["title"].toString(),
              description: element["description"].toString(),
              link: element["link"].toString(),
              status: element["status"].toString(),
              created_at: element["created_at"].toString(),
              seen_at: element["seen_at"].toString(),
              notification_id: element["notification_id"].toString()));
        });
      }
      setState(() {
        isLoading = false;
      });
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const NoInternet()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Container(
        height: Platform.isIOS ? 90 : 85,
        decoration: BoxDecoration(
          gradient: gradient,
        ),
        child: Stack(
          children: [
            Container(
              width: 150,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/Logo Shape.png"),
                      fit: BoxFit.cover)),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      getText("Notifications"),
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 7),
                      child: Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          "assets/bell.png",
                          height: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      Padding(
          padding: EdgeInsets.only(top: Platform.isIOS ? 90 : 69),
          child: Container(
              height: screenHeight,
              width: screenWidth,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: orange,
                          ),
                        )
                      : notifications.isEmpty
                          ? Center(child: Text(getText("message24")))
                          : Column(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: screenHeight - 110,
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: notifications.length,
                                    itemBuilder: (context, index) {
                                      final notification = notifications[index];
                                      return NotificationCard(
                                        title: notification.title,
                                        body: notification.description,
                                        time: notification.created_at,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ]))))
    ]));
  }
}

class NotificationCard extends StatelessWidget {
  final String title;
  final String body;
  final String time;

  const NotificationCard({
    super.key,
    required this.title,
    required this.body,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.notifications,
              color: orange,
              size: 30,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    body,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
