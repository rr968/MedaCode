// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, curly_braces_in_flow_control_structures

import 'dart:convert';
import 'dart:developer' as pri;

import 'dart:math';

import 'package:flutter/material.dart';
import '../../controller/language.dart';
import '../../controller/note_alert.dart';
import '/controller/no_imternet.dart';
import '/controller/var.dart';
import 'package:http/http.dart' as http;
import '/view/chat/chats.dart';
import '/view/pay.dart';

import '../../model/user_order.dart';
import 'payment_view_for_order.dart';

class OrderCheckOut extends StatefulWidget {
  final List<UserOrder> userOrders;
  final double totalPrice;
  const OrderCheckOut(
      {super.key, required this.userOrders, required this.totalPrice});

  @override
  State<OrderCheckOut> createState() => _OrderCheckOutState();
}

class _OrderCheckOutState extends State<OrderCheckOut> {
  bool? checkbox = false;
  bool? walletCheckBox = false;
  bool? moyasarCheckBox = false;

  double price = 100;
  double priceAfterSubThePoints = 100;
  int dividedBy = 10;
  String secretKey = "";
  String publishableKey = "";
  int counter = 0;
  int points_discounted = int.parse(points);
  int walletBalance = 0;
  int detuctedPoints = 0;
  double detuctedWallet = 0;
  bool buttonLoading = false;

  getDividePoint() async {
    price = widget.totalPrice;
    priceAfterSubThePoints = widget.totalPrice;
    var request = http.Request(
        'GET',
        Uri.parse(
            '$baseUrl/points_division.php?input_key=$input_key&input_secret=$input_secret'));

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      Map data = json.decode(await response.stream.bytesToString());
      setState(() {
        pri.log(data["division"].toString());
        dividedBy = data["division"];
        counter++;
      });
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const NoInternet()),
          (route) => false);
    }
  }

  getPayInfo() async {
    var request = http.Request(
        'GET',
        Uri.parse(
            '$baseUrl/keysa.php?input_key=$input_key&input_secret=$input_secret'));

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      Map data = json.decode(await response.stream.bytesToString());
      setState(() {
        secretKey = data["secret_key"];
        publishableKey = data["publishable_key"];
        counter++;
      });
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const NoInternet()),
          (route) => false);
    }
  }

  getWalletBalance() async {
    String userId = await getUserId();

    var request = http.Request(
        'GET',
        Uri.parse(
            '$baseUrl/payment_management.php?input_key=$input_key&input_secret=$input_secret&user_id=$userId&method=0&operation_id=777'));
    pri.log("heere/////////////");
    pri.log(userId);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      Map data = json.decode(await response.stream.bytesToString());
      pri.log(data["wallet"]["balance"].toString());
      if (data["wallet"]["balance"] != null)
        walletBalance = data["wallet"]["balance"];
      setState(() {
        counter++;
      });
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const NoInternet()),
          (route) => false);
    }
  }

  deductWalletAndPoints() async {
    String isWallet = detuctedWallet <= 0 ? "0" : "1";
    String isPoints = detuctedPoints <= 0 ? "0" : "1";

    String userId = await getUserId();
    var random = Random();
    int randomNumber = 10000000 + random.nextInt(90000000);
    String offerIds = "";
    //[[offerId,Stejari],[offerId,Stejari],....]
    List<List> offersToEachMerchant = [];
    for (int i = 0; i < widget.userOrders.length; i++)
      for (int j = 0; j < widget.userOrders[i].categories.length; j++) {
        for (int k = 0;
            k < widget.userOrders[i].categories[j].subCategories.length;
            k++) {
          if (widget.userOrders[i].categories[j].subCategories[k].isSelected) {
            List a = [
              widget.userOrders[i].categories[j].subCategories[k].offer_id,
              widget.userOrders[i].categories[j].subCategories[k].STejari
            ];
            if (!offersToEachMerchant.contains(a)) {
              offersToEachMerchant.add(a);
            }
            offerIds +=
                "${widget.userOrders[i].categories[j].subCategories[k].offer_id},";
          }
        }
      }
    pri.log(offersToEachMerchant.toString());
    //to delete the last simicolun
    offerIds = offerIds.substring(0, offerIds.length - 1);
    pri.log(offerIds.toString());
    var request = http.Request(
        'GET',
        Uri.parse(
            '$baseUrl/payment_management.php?input_key=$input_key&input_secret=$input_secret&user_id=$userId&method=2&points_management=$isPoints&points=$detuctedPoints&wallet_management=$isWallet&money=$detuctedWallet&operation_id=$randomNumber&offer_ids=$offerIds'));

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      Map data = json.decode(await response.stream.bytesToString());
      pri.log("sucess///////////");
      pri.log(data.toString());
      if (data["status"] == "error") {
        setState(() {
          buttonLoading = false;
        });
        snackBar(context, data["message"]);
      } else {
        //here open new chat
        String text = "Hello, your order is being delivered.";
        var headers = {'Cookie': 'PHPSESSID=pkjgl6qfq25j4hvhl359mma1ej'};
        int count = offersToEachMerchant.length;
        for (int i = 0; i < offersToEachMerchant.length; i++) {
          var request = http.Request(
              'GET',
              Uri.parse(
                  '$baseUrl/chat.php?input_key=$input_key&input_secret=$input_secret&offer_id=${offersToEachMerchant[i][0]}&STejari=${offersToEachMerchant[i][1]}&user_id=$userId&sender=1&msg_action=0&content=$text&content_type=0&msgStatus=0&shipmentStatus=1'));

          request.headers.addAll(headers);

          http.StreamedResponse response = await request.send();

          if (response.statusCode == 200) {
            Map datamsg = json.decode(await response.stream.bytesToString());
            pri.log("chaaaat///////");
            pri.log(datamsg.toString());
            if (datamsg["status"] == "success") {
              count -= 1;
              if (count == 0) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyChats(
                              isUser: isUserNow,
                              openLastChat: true,
                            )),
                    (route) => false);
              }
            } else {
              snackBar(context, "ERROR please try again");
            }
          }
        }
      }
    }
  }

  offerApi() async {
    if (walletCheckBox == false && moyasarCheckBox == false) {
      noteAlert2(context);
    } else if ((walletCheckBox == true || checkbox == true) &&
        priceAfterSubThePoints > 0) {
      noteAlert2(context);
    } else {
      setState(() {
        buttonLoading = true;
      });
      List<UserOrder> userOrders = widget.userOrders;
      String userId = await getUserId();
      String level2Id = "";
      for (int i = 0; i < userOrders.length; i++)
        for (int j = 0; j < userOrders[i].categories.length; j++) {
          for (int k = 0;
              k < userOrders[i].categories[j].subCategories.length;
              k++) {
            if (userOrders[i].categories[j].subCategories[k].isSelected) {
              level2Id +=
                  "${userOrders[i].categories[j].subCategories[k].level2_id},";
            }
          }
        }
      level2Id = level2Id.substring(0, level2Id.length - 1);
      var headers = {'Cookie': 'PHPSESSID=pkjgl6qfq25j4hvhl359mma1ej'};

      try {
        pri.log(level2Id.toString());
        pri.log(userId.toString());
        String pass = moyasarCheckBox ?? false ? "0" : "1";
        var request = http.Request(
            'GET',
            Uri.parse(
                '$baseUrl/my_offers.php?input_key=$input_key&input_secret=$input_secret&user_id=$userId&first_step_status=1&pass_to_bill=$pass&level2_id=$level2Id'));

        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          String resData = await response.stream.bytesToString();

          if (!resData.contains("""{"status":"success",""")) {
            setState(() {
              buttonLoading = false;
            });
            snackBar(context, "the is an error please try again");
          } else {
            pri.log("sucess my offers api");
            if (moyasarCheckBox ?? false) {
              setState(() {
                buttonLoading = false;
              });

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PaymentViewForOrder(
                          level2Id: level2Id,
                          amount: priceAfterSubThePoints,
                          publishableSecretKey: publishableKey,
                          secretKey: secretKey,
                          detuctedPoints: detuctedPoints,
                          detuctedWallet: detuctedWallet,
                          userOrders: widget.userOrders)));
            } else {
              deductWalletAndPoints();
            }
          }
        } else {
          pri.log("error here");
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const FailPage()),
              (route) => false);
        }
      } catch (e) {
        pri.log("error here222");
        pri.log(e.toString());
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const FailPage()),
            (route) => false);
      }
    }
  }

  @override
  void initState() {
    getDividePoint();
    getPayInfo();
    getWalletBalance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: language == "0" ? TextDirection.ltr : TextDirection.rtl,
        child: SafeArea(
          child: counter < 3
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 13, vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(
                                Icons.arrow_back_ios,
                                size: 22,
                              )),
                          Text(getText("Payment"),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13)),
                          Container(
                            width: 30,
                          )
                        ],
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            getText("Totalamount"),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          Text(
                            "$priceAfterSubThePoints${getText("SR")}",
                            style: TextStyle(
                                color: orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 15, right: 15, top: 15),
                      child: Text(
                        getText("message44"),
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 10, bottom: 6),
                      child: Row(
                        children: [
                          Checkbox(
                              value:
                                  double.parse(points) <= 0 ? false : checkbox,
                              activeColor: orange,
                              onChanged: (value) {
                                checkbox = value;
                                detuctedPoints = 0;
                                moyasarCheckBox = false;
                                priceAfterSubThePoints = price;
                                if (value == true) {
                                  moyasarCheckBox = false;
                                  priceAfterSubThePoints =
                                      price - int.parse(points) / dividedBy;
                                  detuctedPoints = int.parse(points);
                                  if (priceAfterSubThePoints < 0) {
                                    priceAfterSubThePoints = 0;
                                    detuctedPoints = int.parse(points) -
                                        (price * dividedBy).toInt();
                                  }
                                } else {
                                  detuctedPoints = 0;
                                  priceAfterSubThePoints = price;
                                }
                                if (walletCheckBox == true &&
                                    priceAfterSubThePoints > 0) {
                                  if (walletBalance >= priceAfterSubThePoints) {
                                    detuctedWallet = priceAfterSubThePoints;
                                    priceAfterSubThePoints = 0;
                                  } else {
                                    //200 but need 300
                                    detuctedWallet = walletBalance.toDouble();
                                    priceAfterSubThePoints -= walletBalance;
                                  }
                                } else {
                                  detuctedWallet = 0;
                                }

                                setState(() {});
                              }),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                getText("message43"),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                    color: double.parse(points) <= 0
                                        ? Colors.grey
                                        : Colors.black),
                              ),
                              Text(
                                "${getText("pointbalance")} $points",
                                style: TextStyle(
                                    fontSize: 11,
                                    color: double.parse(points) <= 0
                                        ? Colors.grey
                                        : orange,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Expanded(child: Container()),
                          Text(
                            "480 ${getText("points")} = ${480 / dividedBy} ${getText("SR")}",
                            style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 10, bottom: 6),
                      child: Row(
                        children: [
                          Checkbox(
                              value:
                                  walletBalance == 0 ? false : walletCheckBox,
                              activeColor: orange,
                              onChanged: (value) {
                                moyasarCheckBox = false;
                                detuctedPoints = 0;
                                walletCheckBox = value;
                                priceAfterSubThePoints = price;
                                if (value == true) {
                                  priceAfterSubThePoints =
                                      price - int.parse(points) / dividedBy;
                                  detuctedPoints = int.parse(points);
                                  if (priceAfterSubThePoints < 0) {
                                    priceAfterSubThePoints = 0;
                                    detuctedPoints = int.parse(points) -
                                        (price * dividedBy).toInt();
                                  }
                                } else {
                                  detuctedPoints = 0;
                                  priceAfterSubThePoints = price;
                                }
                                if (walletCheckBox == true &&
                                    priceAfterSubThePoints > 0) {
                                  if (walletBalance >= priceAfterSubThePoints) {
                                    detuctedWallet = priceAfterSubThePoints;
                                    priceAfterSubThePoints = 0;
                                  } else {
                                    //200 but need 300
                                    detuctedWallet = walletBalance.toDouble();
                                    priceAfterSubThePoints -= walletBalance;
                                  }
                                } else {
                                  detuctedWallet = 0;
                                }

                                setState(() {});
                              }),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                getText("Paywallet"),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                    color: walletBalance == 0
                                        ? Colors.grey
                                        : Colors.black),
                              ),
                              Text(
                                "${getText("walletbalance")} $walletBalance",
                                style: TextStyle(
                                    fontSize: 11,
                                    color: walletBalance == 0
                                        ? Colors.grey
                                        : orange,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Expanded(child: Container()),
                          Text(
                            "${getText("balanceDeduction")}\n${walletBalance - detuctedWallet} ${getText("SR")}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 10, bottom: 6),
                      child: Row(
                        children: [
                          Checkbox(
                              value: moyasarCheckBox,
                              activeColor: orange,
                              onChanged: (value) {
                                detuctedPoints = 0;
                                detuctedWallet = 0;
                                walletCheckBox = false;
                                checkbox = false;
                                moyasarCheckBox = value;
                                priceAfterSubThePoints = price;

                                setState(() {});
                              }),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                getText("Paywithmoyasar"),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                          Expanded(child: Container()),
                        ],
                      ),
                    ),
                    Expanded(child: Container()),
                    InkWell(
                      onTap: () {
                        if (!buttonLoading) {
                          offerApi();
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 13, vertical: 16),
                        child: Container(
                          height: 35,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: orange,
                              borderRadius: BorderRadius.circular(5)),
                          child: Center(
                            child: buttonLoading
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    getText("Paynow"),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
