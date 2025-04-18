import 'dart:developer';
import 'dart:io';

import '/controller/language.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../controller/sucess_popup.dart';
import '../notification/notifications.dart';
import '/controller/provider.dart';
import '/model/bills.dart';
import 'package:provider/provider.dart';

import '../../controller/textstyle.dart';
import '../../controller/var.dart';

class BillPage extends StatefulWidget {
  bool isFirstOpen;
  BillClass bill;
  BillPage({super.key, required this.isFirstOpen, required this.bill});

  @override
  State<BillPage> createState() => _BillPageState();
}

class _BillPageState extends State<BillPage> {
  @override
  void initState() {
    super.initState();
    if (widget.isFirstOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        rating();
      });
    }
  }

  rating() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(getText("message31")),
          content: Material(
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Provider.of<MyProvider>(context, listen: false)
                        .setnumOfStars(1);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Provider.of<MyProvider>(context, listen: true)
                                .getnumOfStars() >=
                            1
                        ? Image.asset(
                            "assets/filledstar.png",
                            height: 22,
                          )
                        : Image.asset(
                            "assets/star.png",
                            height: 20,
                            color: Colors.grey,
                          ),
                  ),
                ),
                InkWell(
                    onTap: () {
                      Provider.of<MyProvider>(context, listen: false)
                          .setnumOfStars(2);
                    },
                    child: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Provider.of<MyProvider>(context, listen: true)
                                    .getnumOfStars() >=
                                2
                            ? Image.asset(
                                "assets/filledstar.png",
                                height: 22,
                              )
                            : Image.asset(
                                "assets/star.png",
                                height: 20,
                                color: Colors.grey,
                              ))),
                InkWell(
                    onTap: () {
                      Provider.of<MyProvider>(context, listen: false)
                          .setnumOfStars(3);
                    },
                    child: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Provider.of<MyProvider>(context, listen: true)
                                    .getnumOfStars() >=
                                3
                            ? Image.asset(
                                "assets/filledstar.png",
                                height: 22,
                              )
                            : Image.asset(
                                "assets/star.png",
                                height: 20,
                                color: Colors.grey,
                              ))),
                InkWell(
                    onTap: () {
                      Provider.of<MyProvider>(context, listen: false)
                          .setnumOfStars(4);
                    },
                    child: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Provider.of<MyProvider>(context, listen: true)
                                    .getnumOfStars() >=
                                4
                            ? Image.asset(
                                "assets/filledstar.png",
                                height: 22,
                              )
                            : Image.asset(
                                "assets/star.png",
                                height: 20,
                                color: Colors.grey,
                              ))),
                InkWell(
                    onTap: () {
                      Provider.of<MyProvider>(context, listen: false)
                          .setnumOfStars(5);
                    },
                    child: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Provider.of<MyProvider>(context, listen: true)
                                    .getnumOfStars() >=
                                5
                            ? Image.asset(
                                "assets/filledstar.png",
                                height: 22,
                              )
                            : Image.asset(
                                "assets/star.png",
                                height: 20,
                                color: Colors.grey,
                              ))),
              ],
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(getText('OK')),
              onPressed: () async {
                String rate = Provider.of<MyProvider>(context, listen: false)
                    .getnumOfStars()
                    .toString();

                String userId = await getUserId();
                log(userId);
                var headers = {
                  'Cookie': 'PHPSESSID=1ljp80udb4p4rbib2mgqomsue8'
                };
                var request = http.Request(
                    'GET',
                    Uri.parse(
                        '$baseUrl/ratings.php?input_key=$input_key&input_secret=$input_secret&user_id=$userId&rating=$rate&scenario=0'));

                request.headers.addAll(headers);

                http.StreamedResponse response = await request.send();
                Navigator.pop(context);
                if (response.statusCode == 200) {
                  showAnimatedSuccessPopup(context, "Done Successfully!");
                }
              },
            ),
          ],
        );
      },
    );
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
                        getText("message32"),
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
                      height: screenHeight - 135,
                      width: screenWidth,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25)),
                      child: Padding(
                          padding: const EdgeInsets.only(
                              left: 22, right: 22, top: 22),
                          child: ListView(padding: EdgeInsets.zero, children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: greyc)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              getText("message34"),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              widget.bill.offer_id,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: orange),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              getText("message35"),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              widget.bill.date_updated,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: orange),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              getText("VatNumber"),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              widget.bill.STejari,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: orange),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              getText("Firmname"),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              widget.bill.firm,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: orange),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              getText("TotalPrice"),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              widget.bill.user_total_payments,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: orange),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10, left: 3, right: 3),
                              child: Text(
                                "${getText("Items")} :",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: greyc)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (int i = 0;
                                      i < widget.bill.bills.length;
                                      i++)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                widget.bill.bills[i].name,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "${widget.bill.bills[i].category} | ",
                                                    style: TextStyle(
                                                        color: greyc,
                                                        fontSize: 11),
                                                  ),
                                                  Text(
                                                    widget.bill.bills[i]
                                                        .sub_categories,
                                                    style: TextStyle(
                                                        color: greyc,
                                                        fontSize: 11),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "${widget.bill.bills[i].quantity} ${widget.bill.bills[i].unit}",
                                                    style: TextStyle(
                                                        color: greyc,
                                                        fontSize: 11),
                                                  ),
                                                  Expanded(child: Container()),
                                                  Text(
                                                    "${widget.bill.bills[i].adjusted_price_VAT} ${getText("SR")} ",
                                                    style: TextStyle(
                                                        color: orange,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        i == widget.bill.bills.length - 1
                                            ? Container()
                                            : const Divider()
                                      ],
                                    ),
                                ],
                              ),
                            ),
                            /* Container(
                              height: 35,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: orange,
                                  borderRadius: BorderRadius.circular(5)),
                              child: const Center(
                                child: Text(
                                  "Export the bill",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                              ),
                            ),*/
                          ])))
                ])))
      ]),
    ));
  }
}
