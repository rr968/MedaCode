// ignore_for_file: must_be_immutable

import 'dart:io';

import '/controller/var.dart';
import 'package:flutter/material.dart';
import '../view/notification/notifications.dart';
import '/controller/textstyle.dart';

class HeaderBar extends StatelessWidget {
  String title;
  HeaderBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Platform.isIOS ? 90 : 85,
      decoration: BoxDecoration(gradient: gradient),
      child: Stack(
        children: [
          Container(
            width: 150,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/Logo Shape.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const Text("       "),
                  Expanded(
                    child: Center(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationPage(),
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
                                    borderRadius: BorderRadius.circular(100),
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
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset("assets/shopping-cart.png", height: 22),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
