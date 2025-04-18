import 'dart:convert';
import 'dart:io';
import 'dart:math';

import '/view/splashscreen/splashscreen.dart';
import '/view/support/support_chat.dart';
import '/view/support/support_items.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../controller/language.dart';
import '../../controller/textstyle.dart';
import '../../controller/var.dart';
import '../notification/notifications.dart';

class SupportMenu extends StatefulWidget {
  const SupportMenu({super.key});

  @override
  State<SupportMenu> createState() => _SupportMenuState();
}

class _SupportMenuState extends State<SupportMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Directionality(
          textDirection:
              language == "0" ? TextDirection.ltr : TextDirection.rtl,
          child: Stack(children: [
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
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 22,
                          ),
                          Text(
                            getText("Support"),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const NotificationPage()));
                                },
                                child: Stack(
                                  children: [
                                    Image.asset(
                                      "assets/bell.png",
                                      height: 22,
                                    ),
                                    unSeenNotiNum == 0
                                        ? Container()
                                        : Container(
                                            height: 14,
                                            width: 14,
                                            decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(100)),
                                            child: Center(
                                              child: Text(
                                                unSeenNotiNum.toString(),
                                                style: const TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          )
                                  ],
                                ),
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
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(children: [
                          Container(
                            height: 15,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SupportItems(
                                          typeName: "Bll_ids",
                                          ticketType: "1")));
                            },
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        "assets/Bills.png",
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
                                              getText("Bills"),
                                              style: const TextStyle(
                                                  fontSize: 13,
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
                                const Padding(
                                  padding: EdgeInsets.only(
                                      left: 20, top: 9, bottom: 9),
                                  child: Divider(),
                                )
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SupportItems(
                                          typeName: "ND_ids",
                                          ticketType: "2")));
                            },
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        "assets/delivery.png",
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
                                              getText("message29"),
                                              style: const TextStyle(
                                                  fontSize: 13,
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
                                const Padding(
                                  padding: EdgeInsets.only(
                                      left: 20, top: 9, bottom: 9),
                                  child: Divider(),
                                )
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SupportItems(
                                          typeName: "ISS_ids",
                                          ticketType: "3")));
                              /*  String r = (Random().nextInt(90000000) + 10000000)
                                  .toString();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SupportChat(
                                          offerId: "ISS_$r",
                                          ticket_type: "3",
                                          ticket_title: "issues")));*/
                            },
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        "assets/problem.png",
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
                                              getText("issues"),
                                              style: const TextStyle(
                                                  fontSize: 13,
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
                                const Padding(
                                  padding: EdgeInsets.only(
                                      left: 20, top: 9, bottom: 9),
                                  child: Divider(),
                                )
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SupportItems(
                                          typeName: "SUG_ids",
                                          ticketType: "4")));
                              /*   String r = (Random().nextInt(90000000) + 10000000)
                                  .toString();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SupportChat(
                                          offerId: "SUG$r",
                                          ticket_type: "4",
                                          ticket_title: "suggestions")));*/
                            },
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        "assets/opinion.png",
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
                                              getText("suggestions"),
                                              style: const TextStyle(
                                                  fontSize: 13,
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
                                const Padding(
                                  padding: EdgeInsets.only(
                                      left: 20, top: 9, bottom: 9),
                                  child: Divider(),
                                )
                              ],
                            ),
                          ),
                        ]))))
          ]),
        ));
  }
}
