import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math';
import '/view/profile/account_settings.dart';
import 'package:http/http.dart' as http;

import '/controller/language.dart';
import '/view/auth/forget_password.dart';
import '/view/splashscreen/splashscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../controller/textstyle.dart';
import '../../controller/var.dart';
import '../support/support_chat.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
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
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 12),
                          child: ListView(padding: EdgeInsets.zero, children: [
                            Container(
                              height: 16,
                            ),
                            Text(
                              getText("Preferences"),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Container(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ForgetPassword()));
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      getText("ResetPassword"),
                                      style: textStyle11,
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 20,
                                      color: Color.fromARGB(255, 94, 94, 94),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const Divider(),
                            Container(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ForgetPassword()));
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      getText("Language"),
                                      style: textStyle11,
                                    ),
                                    Expanded(child: Container()),
                                    Radio(
                                        value: "0",
                                        groupValue: groupValue,
                                        activeColor: orange,
                                        onChanged: (value) {
                                          setLanguage("0");
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const SplashScreen()),
                                              (route) => false);
                                        }),
                                    const Text("EN"),
                                    Radio(
                                        value: "1",
                                        groupValue: groupValue,
                                        activeColor: orange,
                                        onChanged: (value) {
                                          setLanguage("1");
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const SplashScreen()),
                                              (route) => false);
                                        }),
                                    const Text("العربية"),
                                  ],
                                ),
                              ),
                            ),
                            const Divider(),
                            Container(
                              height: 10,
                            ),
                            !isUserNow
                                ? Container()
                                : Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AccountSettings()));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      getText("SettingAcc"),
                                                      style: const TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.bold),
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
                                        padding: EdgeInsets.only(
                                            top: 15, bottom: 15),
                                        child: Divider(),
                                      )
                                    ],
                                  )
                          ]))),
                ])))
      ]),
    ));
  }
}
