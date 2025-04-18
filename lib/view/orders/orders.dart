// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import '../../controller/language.dart';
import '../notification/notifications.dart';
import '/view/orders/dealers.dart';
import '/view/orders/myOrders.dart';
import '/view/orders/recivedOffers.dart';
import '../../../controller/textstyle.dart';
import '../../../controller/var.dart';

class UserOrders extends StatefulWidget {
  const UserOrders({super.key});

  @override
  State<UserOrders> createState() => _UserOrdersState();
}

class _UserOrdersState extends State<UserOrders> {
  int currentIndex = 0;

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
                      const Text("      "),
                      Text(
                        getText("Orders"),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
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
          padding: EdgeInsets.only(top: Platform.isIOS ? 100 : 65),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                Container(
                  height: screenHeight - 75,
                  width: screenWidth,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25)),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 12),
                    child: Column(
                      children: [
                        FittedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    currentIndex = 0;
                                  });
                                },
                                child: Column(
                                  children: [
                                    Text(
                                      getText("Receivedoffers"),
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: currentIndex == 0
                                              ? orange
                                              : Colors.black),
                                    ),
                                    Container(
                                      height: 8,
                                    ),
                                    Container(
                                      height: 2,
                                      width: screenWidth / 3.3,
                                      color: currentIndex == 0
                                          ? orange
                                          : Colors.grey.withOpacity(.5),
                                    )
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    currentIndex = 1;
                                  });
                                },
                                child: Column(
                                  children: [
                                    Text(
                                      getText("Myorders"),
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: currentIndex == 1
                                              ? orange
                                              : Colors.black),
                                    ),
                                    Container(
                                      height: 8,
                                    ),
                                    Container(
                                      height: 2,
                                      width: screenWidth / 3.3,
                                      color: currentIndex == 1
                                          ? orange
                                          : Colors.grey.withOpacity(.5),
                                    )
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    currentIndex = 2;
                                  });
                                },
                                child: Column(
                                  children: [
                                    Text(
                                      getText("Dealers"),
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: currentIndex == 2
                                              ? orange
                                              : Colors.black),
                                    ),
                                    Container(
                                      height: 8,
                                    ),
                                    Container(
                                      height: 2,
                                      width: screenWidth / 3.3,
                                      color: currentIndex == 2
                                          ? orange
                                          : Colors.grey.withOpacity(.5),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            child: currentIndex == 0
                                ? const ReceivedOffers()
                                : currentIndex == 1
                                    ? const MyOrders()
                                    : const Dealers())
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ]),
    ));
  }
}
