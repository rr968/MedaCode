// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter/material.dart';

import '../../controller/language.dart';
import '/controller/textstyle.dart';
import '/controller/var.dart';
import '/view/chat/chats.dart';
import '/view/merchant/homeMerchant.dart';
import '/view/merchant/merchantOrders.dart/merchantOrders.dart';
import '/view/profile/profile.dart';
import 'merchantShop/main_marchant_shop.dart';

class MainMerchantPage extends StatefulWidget {
  final int pageindex;
  const MainMerchantPage({super.key, required this.pageindex});

  @override
  State<MainMerchantPage> createState() => _MainMerchantPageState();
}

class _MainMerchantPageState extends State<MainMerchantPage> {
  int currentPageNumber = 1;
  List<Widget> screens = [
    const HomeMerchant(),
    const MerchantOrders(),
    MyChats(
      isUser: false,
      openLastChat: false,
    ),
    const Profile(),
  ];
  @override
  void initState() {
    isUserNow = false;
    currentPageNumber = widget.pageindex + 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: language == "0" ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
          backgroundColor: currentPageNumber == 1
              ? const Color.fromARGB(255, 245, 245, 245)
              : Colors.white,
          bottomNavigationBar: Stack(
            alignment: Alignment.topCenter,
            children: [
              SizedBox(
                height: Platform.isIOS ? 120 : 70,
                child: Column(
                  children: [
                    Container(
                      height: 21,
                    ),
                    Container(
                      height: 49,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          border: Border(top: BorderSide(color: greyc))),
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            bottomItem(getText("Main"), 1),
                            bottomItem(getText("Orders"), 2),
                            const Column(
                              children: [
                                Text(
                                  "          ",
                                ),
                              ],
                            ),
                            bottomItem(getText("Chats"), 3),
                            bottomItem(getText("More"), 4),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const MarchantShop(isEditing: false, globalIndex: 0, globalSubIndex: 0)));
                },
                child: Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey, spreadRadius: 1, blurRadius: 9)
                      ],
                      borderRadius: BorderRadius.circular(50),
                      gradient: gradient),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Image.asset("assets/store.png"),
                  ),
                ),
              ),
            ],
          ),
          body: screens[currentPageNumber - 1]),
    );
  }

  Widget bottomItem(text, pageNumber) {
    return InkWell(
      onTap: () {
        setState(() {
          currentPageNumber = pageNumber;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            pageNumber == 2
                ? "assets/receipt-list.png"
                : "assets/icon$pageNumber.png",
            height: 20,
            color: currentPageNumber == pageNumber ? orange : Colors.black,
          ),
          Text(
            text,
            style: const TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }
}
