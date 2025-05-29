import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:finaltest/controller/note_alert.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '/controller/language.dart';
import '/controller/var.dart';
import '/controller/version_dialog.dart';
import '/view/category/home_page.dart';
import '/view/category/main_categories.dart';
import '/view/chat/chats.dart';
import '/view/orders/orders.dart';
import '/view/profile/profile.dart';
import '/view/wallet/walet.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentPageNumber = 1;
  bool isPressed = false;
  List<Widget> screens = [
    const HomePage(),
    const Wallet(),
    MyChats(isUser: true, openLastChat: false),
    const Profile(),
  ];
  @override
  void initState() {
    isUserNow = true;
    checkVersion();
    uploadFCM();

    super.initState();
  }

  checkVersion() async {
    var headers = {'Cookie': 'PHPSESSID=pkjgl6qfq25j4hvhl359mma1ej'};
    try {
      var request = http.Request(
        'GET',
        Uri.parse(
          '$baseUrl/app_version.php?input_key=$input_key&input_secret=$input_secret',
        ),
      );

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        Map data = json.decode(await response.stream.bytesToString());

        if (Platform.isAndroid && data["android"] > currentAndroidVersion) {
          showUpdateDialog(context);
        } else if (Platform.isIOS && data["ios"] > currentIOSVersion) {
          showUpdateDialog(context);
        }
      }
    } catch (_) {}
  }

  uploadFCM() async {
    bool fsm = await getFSM();
    if (!fsm) {
      String userId = await getUserId();
      final fsmToken = await FirebaseMessaging.instance.getToken();
      String url =
          '$baseUrl/fcm.php?input_key=$input_key&input_secret=$input_secret&fcm=$fsmToken&id=$userId';
      var request = http.Request('GET', Uri.parse(url));
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        var d = await response.stream.bytesToString();
        try {
          Map data = json.decode(d);
          log("//////////////////////");
          log(data.toString());
          if (data["status"] == "success") {
            setFSM(true);
          }
        } catch (_) {}
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: language == "0" ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        backgroundColor:
            currentPageNumber == 1
                ? const Color.fromARGB(255, 245, 245, 245)
                : Colors.white,
        bottomNavigationBar: SafeArea(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(height: 21),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: greyc)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          bottomItem(getText("Main"), 1),
                          bottomItem(getText("Wallet"), 2),
                          const Column(children: [Text("          ")]),
                          bottomItem(getText("Chats"), 3),
                          bottomItem(getText("More"), 4),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  if (token.trim().isEmpty) {
                    showSignInDialog(context);
                  } else {
                    setState(() {
                      isPressed = !isPressed;
                    });
                  }
                },
                child: Image.asset(
                  isPressed ? "assets/pressed.png" : "assets/notPressed.png",
                  height: 50,
                ),
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            screens[currentPageNumber - 1],
            isPressed
                ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Stack(
                      children: [
                        Image.asset("assets/bar.png", height: 50),
                        SizedBox(
                          height: 30,
                          width: 210,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 7,
                              right: 7,
                              top: 7,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (token.trim().isEmpty) {
                                      showSignInDialog(context);
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) =>
                                                  const MainCategories(),
                                        ),
                                      );
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        "assets/createOrder.png",
                                        height: 22,
                                      ),
                                      Container(width: 4),
                                      Text(
                                        getText("Createorder"),
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    if (token.trim().isEmpty) {
                                      showSignInDialog(context);
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => const UserOrders(),
                                        ),
                                      );
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        "assets/clipboard-list.png",
                                        color: Colors.white,
                                        height: 18,
                                      ),
                                      Container(width: 4),
                                      Text(
                                        getText("Myorders"),
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget bottomItem(text, pageNumber) {
    return InkWell(
      onTap: () {
        if (token.trim().isEmpty) {
          showSignInDialog(context);
        } else {
          setState(() {
            currentPageNumber = pageNumber;
          });
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/icon$pageNumber.png",
            height: pageNumber == 1 ? 21 : 20,
            color: currentPageNumber == pageNumber ? orange : Colors.black,
          ),
          Text(text, style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
}
