// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, curly_braces_in_flow_control_structures

import 'dart:convert';
import 'dart:developer' as pri;

import '/controller/language.dart';
import 'package:flutter/material.dart';
import '/controller/var.dart';
import 'package:moyasar/moyasar.dart';
import 'package:http/http.dart' as http;

import '../../model/user_order.dart';
import '../chat/chats.dart';
import '../pay.dart';

class PaymentViewForOrder extends StatefulWidget {
  final String level2Id;
  final double amount;
  final String publishableSecretKey;
  final String secretKey;
  final int detuctedPoints;
  final double detuctedWallet;
  final List<UserOrder> userOrders;

  const PaymentViewForOrder({
    super.key,
    required this.level2Id,
    required this.amount,
    required this.publishableSecretKey,
    required this.secretKey,
    required this.detuctedPoints,
    required this.detuctedWallet,
    required this.userOrders,
  });

  @override
  State<PaymentViewForOrder> createState() => _PaymentViewForOrderState();
}

class _PaymentViewForOrderState extends State<PaymentViewForOrder> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(40),
                  child: Image.asset(
                    "assets/splash.png",
                    height: 90,
                  ),
                ),
                CreditCard(
                  config: PaymentConfig(
                    publishableApiKey: widget.publishableSecretKey,
                    amount: widget.amount.toInt() * 100,
                    description: getText("MedaApp"),
                    metadata: {},
                    creditCard:
                        CreditCardConfig(saveCard: false, manual: false),
                  ),
                  onPaymentResult: (result) async {
                    if (result is PaymentResponse) {
                      switch (result.status) {
                        case PaymentStatus.paid:
                          try {
                            String userId = await getUserId();

                            String offerIds = "";
                            //[[offerId,Stejari],[offerId,Stejari],....]
                            List<List> offersToEachMerchant = [];
                            for (int i = 0; i < widget.userOrders.length; i++)
                              for (int j = 0;
                                  j < widget.userOrders[i].categories.length;
                                  j++) {
                                for (int k = 0;
                                    k <
                                        widget.userOrders[i].categories[j]
                                            .subCategories.length;
                                    k++) {
                                  if (widget.userOrders[i].categories[j]
                                      .subCategories[k].isSelected) {
                                    List a = [
                                      widget.userOrders[i].categories[j]
                                          .subCategories[k].offer_id,
                                      widget.userOrders[i].categories[j]
                                          .subCategories[k].STejari
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
                            offerIds =
                                offerIds.substring(0, offerIds.length - 1);
                            pri.log(offerIds.toString());
                            String payID = result.id;
                            var request = http.Request(
                                'GET',
                                Uri.parse(
                                    '$baseUrl/payment_check.php?input_key=$input_key&input_secret=$input_secret&user_id=$userId&payment_id=$payID&offer_ids=$offerIds&level2_id=${widget.level2Id}'));

                            http.StreamedResponse response =
                                await request.send();
                            if (response.statusCode == 200) {
                              Map data = json.decode(
                                  await response.stream.bytesToString());
                              pri.log("sucess////////////////");
                              pri.log(data.toString());
                              if (data["status_"] != "success") {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const FailPage()),
                                    (route) => false);
                              } else {
                                String text =
                                    "Hello, your order is being delivered.";
                                var headers = {
                                  'Cookie':
                                      'PHPSESSID=pkjgl6qfq25j4hvhl359mma1ej'
                                };
                                int count = offersToEachMerchant.length;
                                for (int i = 0;
                                    i < offersToEachMerchant.length;
                                    i++) {
                                  var request = http.Request(
                                      'GET',
                                      Uri.parse(
                                          '$baseUrl/chat.php?input_key=$input_key&input_secret=$input_secret&offer_id=${offersToEachMerchant[i][0]}&STejari=${offersToEachMerchant[i][1]}&user_id=$userId&sender=1&msg_action=0&content=$text&content_type=0&msgStatus=0&shipmentStatus=1'));

                                  request.headers.addAll(headers);

                                  http.StreamedResponse response =
                                      await request.send();

                                  if (response.statusCode == 200) {
                                    Map datamsg = json.decode(
                                        await response.stream.bytesToString());
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
                                      snackBar(
                                          context, "ERROR please try again");
                                    }
                                  }
                                }
                              }
                            }
                          } catch (_) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const FailPage()),
                                (route) => false);
                          }
                          break;
                        case PaymentStatus.failed:
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const FailPage()),
                              (route) => false);
                          break;

                        default:
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const FailPage()),
                              (route) => false);
                      }
                      return;
                    }
                  },
                )
              ],
            ),
          ),
        ));
  }
}
