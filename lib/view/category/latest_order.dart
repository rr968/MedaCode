// ignore_for_file: must_be_immutable

import 'dart:io';

import '/controller/language.dart';
import 'package:flutter/material.dart';
import '/controller/textstyle.dart';
import '/controller/var.dart';

class LatestOrder extends StatefulWidget {
  const LatestOrder({super.key});

  @override
  State<LatestOrder> createState() => _LatestOrderState();
}

class _LatestOrderState extends State<LatestOrder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: Platform.isIOS ? 135 : 90,
            decoration: BoxDecoration(
              gradient: gradient,
            ),
            child: Stack(
              children: [
                Container(
                  width: 200,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/Logo Shape.png"),
                          fit: BoxFit.cover)),
                ),
                SafeArea(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                        Expanded(
                            child: Center(
                          child: Text(
                            getText("LatestOrders"),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        )),
                        const Text("       "),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: Platform.isIOS ? 110 : 72),
            child: Container(
              height: screenHeight,
              width: screenWidth,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(25)),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Container(
                      height: 15,
                    ),
                    for (int i = 0; i < latestOrder.length; i++) productItem(i)
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  productItem(int index) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(7),
          boxShadow: const [
            BoxShadow(
                color: Color.fromARGB(255, 197, 197, 197),
                spreadRadius: 1,
                blurRadius: 10)
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                image: DecorationImage(
                    image: NetworkImage(latestOrder[index].image),
                    fit: BoxFit.fill),
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    latestOrder[index].name,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  FittedBox(
                    child: Text(
                      "${latestOrder[index].category}/${latestOrder[index].subcategory}",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  Text(
                    latestOrder[index].merchant,
                    style: const TextStyle(fontSize: 13),
                  ),
                  Text(
                    "${latestOrder[index].price} SAR",
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
