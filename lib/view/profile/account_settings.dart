import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;

import '/controller/language.dart';
import '/view/auth/forget_password.dart';
import '/view/splashscreen/splashscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../controller/textstyle.dart';
import '../../controller/var.dart';
import '../support/support_chat.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  String groupValue = language;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Directionality(
      textDirection: language == "0" ? TextDirection.ltr : TextDirection.rtl,
      child: Stack(children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15))),
          child: Stack(
            children: [
              Image.asset(
                "assets/Logo Shape.png",
                width: 150,
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12, top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          )),
                      Text(
                        getText("Settings"),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        "     ",
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
            padding: EdgeInsets.only(top: Platform.isIOS ? 100 : 65),
            child: Container(
                height: screenHeight,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(children: [
                  Container(
                    height: screenHeight - 120,
                    width: screenWidth,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25)),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 12),
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          Container(
                            height: 16,
                          ),
                          InkWell(
                            onTap: () {
                              showCupertinoDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CupertinoAlertDialog(
                                    title: Text(getText("DeleteAccount")),
                                    content: Text(getText("message30")),
                                    actions: <Widget>[
                                      CupertinoDialogAction(
                                        child: Text(getText("Cancel")),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      CupertinoDialogAction(
                                        child: Text(getText('OK')),
                                        onPressed: () async {
                                          var headers = {
                                            'Cookie':
                                                'PHPSESSID=1ljp80udb4p4rbib2mgqomsue8'
                                          };
                                          String userid = await getUserId();
                                          var request = http.Request(
                                              'GET',
                                              Uri.parse(
                                                  '$baseUrl/user_deletion.php?input_key=$input_key&input_secret=$input_secret&user_id=$userid'));

                                          request.headers.addAll(headers);

                                          http.StreamedResponse response =
                                              await request.send();

                                          if (response.statusCode == 200) {
                                            Map data = json.decode(
                                                await response.stream
                                                    .bytesToString());
                                            if (data["status"] != "error") {
                                              setUserId("");
                                              setToken("");
                                              setUserName("");
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const SplashScreen()),
                                                  (route) => false);
                                            } else {
                                              Navigator.pop(context);
                                              snackBar(
                                                  context, data["message"]);
                                            }
                                          } else {
                                            Navigator.pop(context);
                                            snackBar(context,
                                                getText("checkInternet"));
                                          }
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/trash.png",
                                    height: 25,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          getText("DAccount"),
                                          style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(child: Container()),
                                  Icon(
                                    Icons.arrow_back_ios_new,
                                    size: 18,
                                    textDirection: language == "0"
                                        ? TextDirection.rtl
                                        : TextDirection.ltr,
                                    color: Colors.grey,
                                  )
                                ],
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 15, bottom: 15),
                            child: Divider(),
                          )
                        ],
                      ),
                    ),
                  ),
                ])))
      ]),
    ));
  }
}
