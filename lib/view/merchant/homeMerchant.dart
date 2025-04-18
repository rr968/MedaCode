// ignore_for_file: file_names

import 'dart:convert';
import 'dart:developer';

import 'package:finaltest/model/product.dart';
import 'package:finaltest/model/store_item.dart';

import '../../controller/no_imternet.dart';
import '/controller/language.dart';
import 'package:flutter/material.dart';
import '../notification/notifications.dart';
import '/controller/textstyle.dart';
import '/controller/var.dart';
import '/view/mainpage.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:http/http.dart' as http;

class HomeMerchant extends StatefulWidget {
  const HomeMerchant({super.key});

  @override
  State<HomeMerchant> createState() => _HomeMerchantState();
}

class _HomeMerchantState extends State<HomeMerchant> {
  final controller = PageController();

  bool isLoadingStoreData = true;

  List<Product> products = [];

  @override
  void initState() {
    getStoreData2();

    super.initState();
  }

  Future getStoreData2() async {
    var request = http.Request(
      'GET',
      Uri.parse(
        '$baseUrl/store.php?input_key=$input_key&input_secret=$input_secret&STejari=$sTejariValue&p_idx=1&price=750&min_value=200&max_value=400&discount=5&dis_type=0&sent_variable=3',
      ),
    );

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      Map data = json.decode(await response.stream.bytesToString());
      /////////////////////
      //back here

      List myList = data["data"]["adjusted_json"];
      for (int catIndex = 0; catIndex < categories.length; catIndex++) {
        for (
          int subIndex = 0;
          subIndex < categories[catIndex].subCategory.length;
          subIndex++
        ) {
          for (
            int prodIndex = 0;
            prodIndex <
                categories[catIndex].subCategory[subIndex].products.length;
            prodIndex++
          ) {
            for (var dataelement in myList) {
              if (dataelement["p_idx"] ==
                  categories[catIndex]
                      .subCategory[subIndex]
                      .products[prodIndex]
                      .productIdx) {
                //edit store items data
                StoreItem storeItem = StoreItem(
                  STejari: dataelement["STejari"],
                  p_idx: dataelement["p_idx"],
                  discount_type: dataelement["discount_type"],
                  applied_on: dataelement["applied_on"],
                  original_price: dataelement["original_price"],
                  adjusted_price: dataelement["adjusted_price"].toString(),
                  discounted_value: dataelement["discounted_value"],
                  discount_status: dataelement["discount_status"],
                );
                categories[catIndex]
                    .subCategory[subIndex]
                    .products[prodIndex]
                    .isItMyProduct = true;
                categories[catIndex]
                    .subCategory[subIndex]
                    .products[prodIndex]
                    .storeItem = storeItem;
                products.add(
                  categories[catIndex]
                      .subCategory[subIndex]
                      .products[prodIndex],
                );
              }
            }
          }
        }
      }
      setState(() {
        isLoadingStoreData = false;
      });
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const NoInternet()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
      body: Directionality(
        textDirection: language == "0" ? TextDirection.ltr : TextDirection.rtl,
        child: SizedBox(
          height: screenHeight,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 255,
                  child: Stack(
                    children: [
                      Container(
                        height: 190,
                        decoration: BoxDecoration(
                          gradient: gradient,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: Stack(
                          children: [
                            Image.asset("assets/Logo Shape.png", width: 150),
                            SafeArea(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                  right: 2,
                                  left: 2,
                                  bottom: 5,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) =>
                                                        const MainPage(),
                                              ),
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 10,
                                              right: 10,
                                              top: 0,
                                            ),
                                            child: Align(
                                              alignment: Alignment.topCenter,
                                              child: Column(
                                                children: [
                                                  Image.asset(
                                                    "assets/userAccount.png",
                                                    height: 25,
                                                  ),
                                                  Text(
                                                    getText("Merchant"),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              getText("message11"),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              firmName,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Expanded(child: Container()),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                          ),
                                          child: Align(
                                            alignment: Alignment.topCenter,
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (context) =>
                                                            const NotificationPage(),
                                                  ),
                                                );
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
                                                              BorderRadius.circular(
                                                                100,
                                                              ),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            unSeenNotiNum
                                                                .toString(),
                                                            style:
                                                                const TextStyle(
                                                                  fontSize: 10,
                                                                  color:
                                                                      Colors
                                                                          .white,
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
                                    Container(height: 5),
                                    Align(
                                      alignment:
                                          language == "0"
                                              ? Alignment.centerRight
                                              : Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset(
                                          "assets/memberShip.png",
                                          height: 15,
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
                        padding: const EdgeInsets.only(
                          left: 13,
                          right: 13,
                          top: 115,
                        ),
                        child: Container(
                          height: 140,
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: AssetImage("assets/Rectangle 2599.png"),
                              fit: BoxFit.fill,
                            ),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(
                                  255,
                                  227,
                                  227,
                                  227,
                                ).withOpacity(.4),
                                spreadRadius: 0,
                                blurRadius: 8,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(9),
                          ),
                        ),
                      ),
                      Align(
                        alignment:
                            language == "0"
                                ? Alignment.topLeft
                                : Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: 40,
                            left: 40,
                            top: 90,
                          ),
                          child: Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(firmPhoto),
                                fit: BoxFit.fill,
                              ),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromARGB(
                                    255,
                                    227,
                                    227,
                                    227,
                                  ).withOpacity(.4),
                                  spreadRadius: 0,
                                  blurRadius: 8,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Text(
                    getText("BestSellers"),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),

                isLoadingStoreData
                    ? Center(child: CircularProgressIndicator(color: orange))
                    : products.length == 0
                    ? Center(child: Text(getText("message24")))
                    : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: SizedBox(
                            height: 340,
                            child: PageView.builder(
                              controller: controller,
                              itemCount:
                                  products.length % 4 > 0
                                      ? products.length ~/ 4 + 1
                                      : products.length ~/ 4,
                              itemBuilder: (_, index) {
                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        (index * 4) < products.length
                                            ? oneItem(index)
                                            : SizedBox(
                                              height: 165,
                                              width: screenWidth / 2.5,
                                            ),
                                        (index * 4) + 1 < products.length
                                            ? oneItem(index + 1)
                                            : SizedBox(
                                              height: 165,
                                              width: screenWidth / 2.5,
                                            ),
                                      ],
                                    ),
                                    Container(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        (index * 4) + 2 < products.length
                                            ? oneItem(index + 2)
                                            : SizedBox(
                                              height: 165,
                                              width: screenWidth / 2.5,
                                            ),
                                        (index * 4) + 3 < products.length
                                            ? oneItem(index + 3)
                                            : SizedBox(
                                              height: 165,
                                              width: screenWidth / 2.5,
                                            ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Center(
                            child: SmoothPageIndicator(
                              controller: controller,
                              count:
                                  products.length % 4 > 0
                                      ? products.length ~/ 4 + 1
                                      : products.length ~/ 4,
                              effect: WormEffect(
                                activeDotColor: orange,
                                dotColor: greyc,
                                dotHeight: 10,
                                dotWidth: 10,
                                type: WormType.thinUnderground,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  oneItem(int index) {
    return Container(
      width: screenWidth / 2.5,
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 217, 217, 217)),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 98,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              image: DecorationImage(
                image: NetworkImage(products[index].image),
              ),
              color: Colors.white,
            ),
          ),

          Container(
            height: 65,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    products[index].name,
                    style: const TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${products[index].storeItem?.adjusted_price ?? ""} ${getText("SR")}",
                    style: const TextStyle(fontSize: 12),
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
