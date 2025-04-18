// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import '/controller/language.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../notification/notifications.dart';
import '/view/sucess.dart';
import '../../../controller/no_imternet.dart';
import '../../../controller/textstyle.dart';
import '../../../controller/var.dart';

class SubmitOrder extends StatefulWidget {
  final int orderIndex;
  final String city;
  const SubmitOrder({super.key, required this.orderIndex, required this.city});

  @override
  State<SubmitOrder> createState() => _SubmitOrderState();
}

class _SubmitOrderState extends State<SubmitOrder> {
  bool isloading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: language == "0" ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
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
                  padding: const EdgeInsets.only(left: 12, right: 12, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      Text(
                        getText("Summary"),
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
            width: screenWidth,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(25)),
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 22),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Text(
                    "${getText("OrderNo")} ${merchantOrders[widget.orderIndex].order_code}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 17),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: greyc,
                          ),
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        children: [
                          for (int i = 0;
                              i <
                                  merchantOrders[widget.orderIndex]
                                      .orders
                                      .length;
                              i++)
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    merchantOrders[widget.orderIndex]
                                        .orders[i]
                                        .name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 1),
                                    child: Row(
                                      children: [
                                        Text(
                                          merchantOrders[widget.orderIndex]
                                              .orders[i]
                                              .category,
                                          style: const TextStyle(
                                              color: Colors.grey, fontSize: 11),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 3),
                                          child: Container(
                                            height: 11,
                                            width: 1,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          merchantOrders[widget.orderIndex]
                                              .orders[i]
                                              .sub_categories,
                                          style: const TextStyle(
                                              color: Colors.grey, fontSize: 11),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 1),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${merchantOrders[widget.orderIndex].orders[i].quantity} ${merchantOrders[widget.orderIndex].orders[i].unit}",
                                          style: const TextStyle(
                                              color: Colors.grey, fontSize: 11),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 7),
                                          child: Column(
                                            children: [
                                              Text(
                                                "${merchantOrders[widget.orderIndex].orders[i].adjusted_price} ${getText("SR")}",
                                                style: TextStyle(
                                                    color: orange,
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                "${getText("withVAt")} ${merchantOrders[widget.orderIndex].orders[i].adjusted_price_VAT} ${getText("SR")}",
                                                style: TextStyle(
                                                    color: orange,
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  i !=
                                          merchantOrders[widget.orderIndex]
                                                  .orders
                                                  .length -
                                              1
                                      ? Divider(
                                          color: greyc,
                                        )
                                      : Container(
                                          height: 10,
                                        ),
                                ],
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 8, top: 10),
                            child: Container(
                              height: 3,
                              color: orange,
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 20, top: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    getText("TotalPrice"),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "${merchantOrders[widget.orderIndex].summed_adjusted_prices_after_discount} ${getText("SR")}",
                                        style: TextStyle(
                                            color: orange,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                      Text(
                                        "${getText("withVAt")} ${merchantOrders[widget.orderIndex].summed_adjusted_prices_after_discount_VAT} ${getText("SR")}",
                                        style: TextStyle(
                                            color: orange,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      setState(() {
                        isloading = true;
                      });
                      var headers = {
                        'Cookie': 'PHPSESSID=pkjgl6qfq25j4hvhl359mma1ej'
                      };
                      try {
                        String lan = language == "0" ? "1" : "0";
                        log(merchantOrders[widget.orderIndex].order_code);

                        log(sTejariValue);
                        log(widget.city);
                        log(lan);
                        var request = http.Request(
                            'GET',
                            Uri.parse(
                                '$baseUrl/submit_offer.php?input_key=$input_key&input_secret=$input_secret&order_code=${merchantOrders[widget.orderIndex].order_code}&STejari=$sTejariValue&pick_city=${widget.city}&en_ar=$lan'));

                        request.headers.addAll(headers);

                        http.StreamedResponse response = await request.send();

                        if (response.statusCode == 200) {
                          Map data = json
                              .decode(await response.stream.bytesToString());
                          log(data.toString());
                          if (data["status"] != "error") {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SucessPageOffer()),
                                (route) => false);
                          } else {
                            setState(() {
                              isloading = false;
                            });
                            snackBar(context, data["message"]);
                          }
                        } else {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const NoInternet()),
                              (route) => false);
                        }
                      } catch (_) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const NoInternet()),
                            (route) => false);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Container(
                        height: 35,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: orange,
                            borderRadius: BorderRadius.circular(5)),
                        child: Center(
                          child: isloading
                              ? const SizedBox(
                                  width: 25,
                                  height: 25,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  getText("SubmitOffer"),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ])),
    );
  }
}
