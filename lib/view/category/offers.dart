// ignore_for_file: must_be_immutable, deprecated_member_use

import 'dart:io';

import '/controller/language.dart';
import 'package:flutter/material.dart';
import '/controller/textstyle.dart';
import '/controller/var.dart';
import '/view/category/oneoffers.dart';
import 'package:url_launcher/url_launcher.dart';

class Offers extends StatefulWidget {
  const Offers({super.key});

  @override
  State<Offers> createState() => _OffersState();
}

class _OffersState extends State<Offers> {
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
          Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: EdgeInsets.only(top: Platform.isIOS ? 110 : 72),
              child: Container(
                height: screenHeight,
                width: screenWidth,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      Container(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          getText("OffersAds"),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                      for (int i = 0; i < offers.length; i++) productItem(i)
                    ],
                  ),
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
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 7),
      child: InkWell(
        onTap: () async {
          //dont forget edit on home page onTap also

          //0 page 1 link 2 app link
          if (offers[index].status != "0") {
            String url = offers[index].link;
            if (!await launchUrl(Uri.parse(url),
                mode: LaunchMode.externalApplication)) {
              snackBar(context, "error while launch this link");
            }
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TheOffer(index: index)));
          }
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: greyc),
            color: Colors.white,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 135,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(7),
                      topRight: Radius.circular(7)),
                  image: DecorationImage(
                      image: NetworkImage(offers[index].image),
                      fit: BoxFit.fill),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 8,
                    ),
                    Text(
                      offers[index].title,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      height: 8,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
