// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';

import '/controller/language.dart';
import '/view/orders/myOrders.dart';
import '../../../controller/textstyle.dart';
import '../../../controller/var.dart';
import '../notification/notifications.dart';

class GoToMyOrders extends StatefulWidget {
  const GoToMyOrders({super.key});

  @override
  State<GoToMyOrders> createState() => _GoToMyOrdersState();
}

class _GoToMyOrdersState extends State<GoToMyOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: Stack(
              children: [
                Image.asset("assets/Logo Shape.png", width: 150),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12, top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("      "),
                        Text(
                          getText("Myorders"),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
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
                                    builder:
                                        (context) => const NotificationPage(),
                                  ),
                                );
                              },
                              child: Stack(
                                children: [
                                  Image.asset("assets/bell.png", height: 22),
                                  unSeenNotiNum == 0
                                      ? Container()
                                      : Container(
                                        height: 14,
                                        width: 14,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(
                                            100,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            unSeenNotiNum.toString(),
                                            style: const TextStyle(
                                              fontSize: 10,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                height: screenHeight - 75,
                width: screenWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 12),
                  child: Column(children: [MyOrders()]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
