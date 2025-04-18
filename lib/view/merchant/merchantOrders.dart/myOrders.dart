// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import '/controller/language.dart';
import 'package:flutter/material.dart';
import '/controller/var.dart';
import 'package:http/http.dart' as http;

import '../../../controller/no_imternet.dart';

class MyOrdersMerchantSide extends StatefulWidget {
  const MyOrdersMerchantSide({super.key});

  @override
  State<MyOrdersMerchantSide> createState() => _MyOrdersMerchantSideState();
}

class _MyOrdersMerchantSideState extends State<MyOrdersMerchantSide> {
  bool isLoading = true;
  List merchantOrderStatus = []; //delete this line
  @override
  void initState() {
    getOrders();
    super.initState();
  }

  getOrders() async {
    merchantOrders = [];
    String userId = await getUserId();
    var headers = {'Cookie': 'PHPSESSID=pkjgl6qfq25j4hvhl359mma1ej'};
    try {
      var request = http.Request(
          'GET',
          Uri.parse(
              '$baseUrl/order_status.php?input_key=$input_key&input_secret=$input_secret&user_id=$userId&scenario=0'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var d = await response.stream.bytesToString();
        if (d != "There are no offers.") {
          Map data = json.decode(d);

          data["existing_orders"].forEach((key, value) {
            log('Key: $key, Value: $value');
          });
        }
        setState(() {
          isLoading = false;
        });
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
    return SizedBox(
      height: screenHeight - 220,
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: orange,
              ),
            )
          : merchantOrderStatus.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Text(getText("message24")),
                  ),
                )
              : ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Container(
                      height: 14,
                    ),
                    for (int i = 0; i < merchantOrderStatus.length; i++)
                      Padding(
                          padding: const EdgeInsets.only(),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    "assets/clipboard-list.png",
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${getText("OrderNo")} ${merchantOrderStatus[i].offer_id}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11),
                                        ),
                                        Text(
                                          merchantOrderStatus[i]
                                              .last_updated_date,
                                          style: const TextStyle(
                                              color: Colors.grey, fontSize: 11),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(child: Container()),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 7),
                                        child: Text(
                                          merchantOrderStatus[i].order_code ==
                                                  "0"
                                              ? "Waiting"
                                              : merchantOrderStatus[i]
                                                          .order_code ==
                                                      "1"
                                                  ? "Partially approve"
                                                  : merchantOrderStatus[i]
                                                              .order_code ==
                                                          "2"
                                                      ? "Approve"
                                                      : "Rejected",
                                          style: TextStyle(
                                              color: merchantOrderStatus[i]
                                                          .order_code ==
                                                      "0"
                                                  ? Colors.yellow
                                                  : merchantOrderStatus[i]
                                                              .order_code ==
                                                          "1"
                                                      ? orange
                                                      : merchantOrderStatus[i]
                                                                  .order_code ==
                                                              "2"
                                                          ? Colors.green
                                                          : Colors.red,
                                              fontSize: 11),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          if (merchantOrderStatus[i]
                                                  .order_code !=
                                              "0") bottomMenu(i);
                                        },
                                        child: const Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.grey,
                                          size: 22,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 9),
                                child: Container(
                                  width: screenWidth - 50,
                                  height: 1,
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 214, 214, 214),
                                      borderRadius: BorderRadius.circular(5)),
                                ),
                              )
                            ],
                          ))
                  ],
                ),
    );
  }

  bottomMenu(int i) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Directionality(
            textDirection:
                language == "0" ? TextDirection.ltr : TextDirection.rtl,
            child: SizedBox(
                height: MediaQuery.of(context).viewInsets.bottom +
                    screenHeight -
                    65,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 6, top: 17, left: 12, right: 12),
                      child: Center(
                        child: Text(
                          getText("Orderdetails"),
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 90,
                        decoration: BoxDecoration(
                            color: greyc.withOpacity(.3),
                            border: Border.all(color: greyc)),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Image.asset(
                                  "assets/clipboard-list.png",
                                  height: 20,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${getText("OrderNo")} ${merchantOrderStatus[i].offer_id}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11),
                                  ),
                                  Container(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            getText("Orderdate"),
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 11),
                                          ),
                                          Text(
                                            merchantOrderStatus[i]
                                                .last_updated_date,
                                            style: const TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 7),
                                        child: Container(
                                          height: 25,
                                          width: .6,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            getText("Status"),
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 11),
                                          ),
                                          Text(
                                            merchantOrderStatus[i].order_code ==
                                                    "0"
                                                ? "Waiting"
                                                : merchantOrderStatus[i]
                                                            .order_code ==
                                                        "1"
                                                    ? "Partially approve"
                                                    : merchantOrderStatus[i]
                                                                .order_code ==
                                                            "2"
                                                        ? "Approve"
                                                        : "Rejected",
                                            style: TextStyle(
                                                color: merchantOrderStatus[i]
                                                            .order_code ==
                                                        "0"
                                                    ? Colors.yellow
                                                    : merchantOrderStatus[i]
                                                                .order_code ==
                                                            "1"
                                                        ? orange
                                                        : merchantOrderStatus[i]
                                                                    .order_code ==
                                                                "2"
                                                            ? Colors.green
                                                            : Colors.red,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 11),
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(flex: 1, child: Container()),
                    Center(
                      child: Image.asset(
                        merchantOrderStatus[i].order_code == "1"
                            ? "assets/partiallyApproves.png"
                            : merchantOrderStatus[i].order_code == "2"
                                ? "assets/sucess.png"
                                : "assets/rejected.png",
                        width: 115,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 25, bottom: 10, left: 15, right: 15),
                      child: Text(
                        merchantOrderStatus[i].order_code == "1"
                            ? "Order Partially Approved"
                            : merchantOrderStatus[i].order_code == "2"
                                ? "Order Approved"
                                : "Orderb Rejected",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Text(
                        merchantOrderStatus[i].order_code == "1"
                            ? partially
                            : merchantOrderStatus[i].order_code == "2"
                                ? approved
                                : rejected,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 11),
                      ),
                    ),
                    Expanded(flex: 2, child: Container()),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 20),
                        child: Container(
                          height: 35,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: orange,
                              borderRadius: BorderRadius.circular(5)),
                          child: Center(
                            child: Text(
                              getText("Close"),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 10,
                    )
                  ],
                )),
          );
        });
  }

  String approved =
      """user was approved to order, and we will transfer the money within 48 hours""";
  String rejected =
      """Reasons: The order was not received as the standard specifications \nMEDA will review the rejected reason and will decide who will cover logistics and warehousing fees""";
  String partially =
      """Reasons: The order was not received as per the standard specifications \nMEDA will review the rejected reason and will decide who will cover logistics and warehousing fees""";
}
