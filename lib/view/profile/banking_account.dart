import 'dart:convert';
import 'dart:io';

import '/model/bank.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../../controller/language.dart';
import '../../controller/textstyle.dart';
import '../../controller/var.dart';
import 'add_bank_account.dart';

class BankingAccount extends StatefulWidget {
  const BankingAccount({super.key});

  @override
  State<BankingAccount> createState() => _BankingAccountState();
}

class _BankingAccountState extends State<BankingAccount> {
  bool isLoading = true;
  BankAccountClass? bankDetail;
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    var headers = {'Cookie': 'PHPSESSID=rsb4c0bf33us53ekrkeku6q2ln'};
    String target = isUserNow ? "1" : "2";
    String userId = await getUserId();
    var request = http.Request(
        'GET',
        Uri.parse(
            '$baseUrl/bank_accounts.php?input_key=$input_key&input_secret=$input_secret&target_type=$target&id=$userId&bank=YourBankNamem&iban=YourIBANm&scenario=0'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      Map data = json.decode(await response.stream.bytesToString());

      if (data["status"] != "error") {
        bankDetail = BankAccountClass(
            idx: data["data"]["idx"].toString(),
            target_type: data["data"]["target_type"].toString(),
            id: data["data"]["id"].toString(),
            bank: data["data"]["bank"].toString(),
            iban: data["data"]["iban"].toString());
      }

      setState(() {
        isLoading = false;
      });
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
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            )),
                        Text(
                          getText("BankingAccounts"),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          "     ",
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
                    add(),
                    Container(
                        height: screenHeight - 150,
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
                                    bankDetail == null
                                        ? Padding(
                                            padding:
                                                const EdgeInsets.only(top: 60),
                                            child: Center(
                                              child: Text(
                                                getText("message24"),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            height:
                                                140, // Slightly increased height for a more spacious look
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  orange,
                                                  const Color(0xFFF2994A),
                                                  const Color(
                                                      0xFFF2994A), // Soft orange
                                                  const Color(
                                                      0xFFF2C94C), // Bright yellow
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      15), // Rounded corners
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(
                                                          0.1), // Subtle shadow
                                                  blurRadius: 10,
                                                  offset: const Offset(0,
                                                      5), // Position of shadow
                                                ),
                                              ],
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  // Bank Name
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                          Icons.account_balance,
                                                          color: Colors
                                                              .white), // Icon for bank
                                                      const SizedBox(
                                                          width:
                                                              8), // Spacing between icon and text
                                                      Expanded(
                                                        child: Text(
                                                          "${getText("BankName")}: ${bankDetail?.bank ?? 'Unknown'}",
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                            color: Colors.white,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis, // Handle long bank names
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                      height:
                                                          8), // Space between lines
                                                  // IBAN
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                          Icons.credit_card,
                                                          color: Colors
                                                              .white), // Icon for IBAN
                                                      const SizedBox(
                                                          width:
                                                              8), // Spacing between icon and text
                                                      Expanded(
                                                        child: Text(
                                                          "${getText("IBAN")}: ${bankDetail?.iban ?? 'Not Available'}",
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14,
                                                            color: Colors.white,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis, // Handle long IBANs
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                  ])))
                  ])))
        ]),
      ),
    );
  }

  Widget add() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddBankAccount()));
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4), // Shadow position
              ),
            ],
            border: Border.all(color: orange, width: 1), // Highlight border
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.add_circle,
                color: orange,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                getText("UpdateBankAccount"),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: orange,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
