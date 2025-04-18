// ignore_for_file: must_be_immutable

import 'dart:io';

import '/controller/language.dart';
import 'package:flutter/material.dart';
import '../../controller/textstyle.dart';
import '/controller/var.dart';

class TheOffer extends StatefulWidget {
  int index;
  TheOffer({super.key, required this.index});

  @override
  State<TheOffer> createState() => _TheOfferState();
}

class _TheOfferState extends State<TheOffer> {
  bool isArabicAlign = false;
  void isArabic(String text) {
    final RegExp arabicRegex =
        RegExp(r'[\u0600-\u06FF]'); // Arabic Unicode range

    setState(() {
      isArabicAlign = arabicRegex.hasMatch(text);
    });
  }

  @override
  void initState() {
    isArabic(offers[widget.index].title);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                            getText("OffersAds"),
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
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Container(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8, right: 8, left: 8, bottom: 10),
                      child: Align(
                        alignment: isArabicAlign
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Text(
                          offers[widget.index].title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          image: DecorationImage(
                              image: NetworkImage(offers[widget.index].image),
                              fit: BoxFit.fill),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: isArabicAlign
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Text(
                          offers[widget.index].text,
                          textAlign:
                              isArabicAlign ? TextAlign.right : TextAlign.left,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 84, 84, 84),
                              fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
