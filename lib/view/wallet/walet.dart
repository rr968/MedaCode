import 'dart:convert';
import 'dart:developer';

import '/controller/textstyle.dart';
import '/controller/var.dart';

import '/view/wallet/merchant_tranaction.dart';
import '/view/wallet/my_bills.dart';
import '/view/wallet/user_transaction.dart';
import '/view/wallet/withdrawal.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../controller/language.dart';
import '../../controller/no_imternet.dart';
import '../../controller/provider.dart';
import '../notification/notifications.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  bool isLoading = true;
  @override
  void initState() {
    if (isUserNow) {
      getWalletBalance();
    } else {
      getMerchantWalletBalance();
    }

    super.initState();
  }

  getWalletBalance() async {
    String userId = await getUserId();

    var request = http.Request(
        'GET',
        Uri.parse(
            '$baseUrl/payment_management.php?input_key=$input_key&input_secret=$input_secret&user_id=$userId&method=0&operation_id=777'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      Map data = json.decode(await response.stream.bytesToString());
      log(data.toString());
      Provider.of<MyProvider>(context, listen: false)
          .setwalletBalance(data["wallet"]["balance"].toString());

      setState(() {
        isLoading = false;
      });
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const NoInternet()),
          (route) => false);
    }
  }

  getMerchantWalletBalance() async {
    String userId = await getUserId();

    var request = http.Request(
        'GET',
        Uri.parse(
            '$baseUrl/merchantBalance.php?input_key=$input_key&input_secret=$input_secret&id=$userId'));

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      Map data = json.decode(await response.stream.bytesToString());
      log(data.toString());
      if (data["status"] == "success") {
        Provider.of<MyProvider>(context, listen: false)
            .setwalletBalance(data["balance"].toString());
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: orange,
                ),
              )
            : Directionality(
                textDirection:
                    language == "0" ? TextDirection.ltr : TextDirection.rtl,
                child: Stack(
                  children: [
                    Container(
                      height: 270,
                      decoration: BoxDecoration(gradient: gradient),
                      child: SafeArea(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const Text("              "),
                                  Expanded(
                                      child: Center(
                                    child: Text(
                                      getText("Wallet"),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                  )),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
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
                                                            BorderRadius
                                                                .circular(100)),
                                                    child: Center(
                                                      child: Text(
                                                        unSeenNotiNum
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontSize: 10,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      "assets/shopping-cart.png",
                                      height: 22,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 12,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                getText("AvailableBalance"),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ),
                            Text(
                              Provider.of<MyProvider>(context, listen: true)
                                  .getwalletBalance(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 17),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  isUserNow
                                      ? InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const WalletBills()));
                                          },
                                          child: Column(
                                            children: [
                                              Image.asset(
                                                "assets/charge.png",
                                                height: 25,
                                              ),
                                              Text(getText("ChargeWallet"),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 11))
                                            ],
                                          ),
                                        )
                                      : Container(),
                                  isUserNow
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: Container(
                                            height: 28,
                                            width: 1.5,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Container(),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Withdrawal(
                                                    balance:
                                                        Provider.of<MyProvider>(
                                                                context,
                                                                listen: false)
                                                            .getwalletBalance(),
                                                  )));
                                    },
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          "assets/transfere.png",
                                          height: 25,
                                        ),
                                        Text(getText("MoneyTransfer"),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 11))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 225),
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30))),
                        //back here
                        child: Padding(
                            padding: const EdgeInsets.only(
                                left: 14, right: 14, top: 25, bottom: 10),
                            child: isUserNow
                                ? UserTransaction(
                                    balance: Provider.of<MyProvider>(context,
                                            listen: false)
                                        .getwalletBalance(),
                                  )
                                : const MerchantTranaction()),
                      ),
                    )
                  ],
                ),
              ));
  }
}
