// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import '/controller/language.dart';
import '/view/orders/myOrders.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../notification/notifications.dart';
import '/view/merchant/merchantOrders.dart/receivedOffer.dart';

import '../../../controller/no_imternet.dart';
import '../../../controller/textstyle.dart';
import '../../../controller/var.dart';

class MerchantOrders extends StatefulWidget {
  const MerchantOrders({super.key});

  @override
  State<MerchantOrders> createState() => _MerchantOrdersState();
}

class _MerchantOrdersState extends State<MerchantOrders> {
  int currentIndex = 0;
  bool isLoading = true;

  @override
  void initState() {
    getCities();
    super.initState();
  }

  getCities() async {
    var headers = {'Cookie': 'PHPSESSID=pkjgl6qfq25j4hvhl359mma1ej'};
    try {
      String lan = language == "0" ? "1" : "0";
      var request = http.Request(
          'GET',
          Uri.parse(
              '$baseUrl/available_orders.php?input_key=$input_key&input_secret=$input_secret&en_ar=$lan&data_level=0&STejari=$sTejariValue'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        Map data = json.decode(await response.stream.bytesToString());
        log("//////res:$data");
        log("//////tehjari:$sTejariValue");
        citiesMerchantFilter = [];
        data["data"].forEach((element) {
          if (element.toString().trim().isNotEmpty) {
            citiesMerchantFilter.add(element.toString());
          }
        });
        setState(() {
          isLoading = false;
        });
        log("//////cities:$citiesMerchantFilter");
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const NoInternet()),
            (route) => false);
      }
    } catch (_) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const NoInternet()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
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
          height: screenHeight,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: isLoading
              ? Container(
                  height: screenHeight - 135,
                  width: screenWidth,
                  child: Center(
                      child: Container(
                          height: 35,
                          width: 35,
                          child: CircularProgressIndicator(
                            color: orange,
                          ))))
              : Column(
                  children: [
                    Container(
                      height: screenHeight - 135,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
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
                                          getText("Avaiableorders"),
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
                                          width: screenWidth / 2,
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
                                          getText("Approvedorders"),
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
                                          width: screenWidth / 2,
                                          color: currentIndex == 1
                                              ? orange
                                              : Colors.grey.withOpacity(.5),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            currentIndex == 0
                                ? const ReceivedOfferMerchantSide()
                                : const MyOrders()
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      )
    ]));
  }
}
