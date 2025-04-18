import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import '/controller/language.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../notification/notifications.dart';
import '/model/bills.dart';
import '/view/bills/bill.dart';
import '../../controller/no_imternet.dart';
import '../../controller/textstyle.dart';
import '../../controller/var.dart';

class MyBills extends StatefulWidget {
  bool isFirstOpen;
  MyBills({super.key, required this.isFirstOpen});

  @override
  State<MyBills> createState() => _MyBillsState();
}

class _MyBillsState extends State<MyBills> {
  List<BillClass> bills = [];
  bool isLoading = true;
  @override
  void initState() {
    getBills();
    super.initState();
  }

  getBills() async {
    String userId = await getUserId(); //for test 9711740509
    var headers = {'Cookie': 'PHPSESSID=1ljp80udb4p4rbib2mgqomsue8'};
    var request = http.Request(
        'GET',
        Uri.parse(
            '$baseUrl/bill_management.php?input_key=$input_key&input_secret=$input_secret&user_id=$userId&action=0'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      try {
        List data = json.decode(await response.stream.bytesToString());
        log(data.toString());
        for (var element in data) {
          List<Item> items = [];
          List itemsData = element["items"];
          for (var item in itemsData) {
            items.add(Item(
              name: item["name"],
              sub_categories: item["sub_categories"],
              category: item["category"],
              quantity: item["quantity"].toString(),
              unit: item["unit"],
              adjusted_price_VAT: item["adjusted_price_VAT"],
            ));
          }
          bills.add(BillClass(
              offer_id: element["offer_id"].toString(),
              date_updated: element["date_updated"].toString(),
              user_total_payments: element["user_total_payments"].toString(),
              firm: element["firm"].toString(),
              STejari: element["STejari"].toString(),
              bills: items));
        }

        setState(() {
          isLoading = false;
        });
        if (widget.isFirstOpen && bills.isNotEmpty) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BillPage(
                        isFirstOpen: widget.isFirstOpen,
                        bill: bills[bills.length - 1],
                      )));
        }
      } catch (_) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const NoInternet()),
            (route) => false);
      }
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const NoInternet()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Directionality(
      textDirection: language == "0" ? TextDirection.ltr : TextDirection.rtl,
      child: Stack(children: [
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
                        getText("MyBills"),
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(children: [
                  Container(
                      height: screenHeight - 120,
                      width: screenWidth,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25)),
                      child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 12),
                          child: isLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: orange,
                                  ),
                                )
                              : ListView(padding: EdgeInsets.zero, children: [
                                  Container(
                                    height: 16,
                                  ),
                                  for (int i = 0; i < bills.length; i++)
                                    Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        BillPage(
                                                          isFirstOpen: false,
                                                          bill: bills[i],
                                                        )));
                                          },
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                "assets/Bills.png",
                                                height: 33,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${getText("message34")}#${bills[i].offer_id}",
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      bills[i].date_updated,
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          color: greyc),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(child: Container()),
                                              Text(
                                                "${bills[i].user_total_payments} ${getText("SR")}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                    color: orange),
                                              ),
                                              Icon(
                                                Icons.arrow_back_ios_new,
                                                color: Colors.grey,
                                                size: 20,
                                                textDirection: language == "0"
                                                    ? TextDirection.rtl
                                                    : TextDirection.ltr,
                                              )
                                            ],
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Divider(),
                                        )
                                      ],
                                    )
                                ])))
                ])))
      ]),
    ));
  }
}
