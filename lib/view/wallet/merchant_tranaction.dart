import '/controller/language.dart';
import '/model/merchant_transactions.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:developer';
import '../../controller/var.dart';
import 'package:http/http.dart' as http;

import '../../controller/no_imternet.dart';

class MerchantTranaction extends StatefulWidget {
  const MerchantTranaction({super.key});

  @override
  State<MerchantTranaction> createState() => _MerchantTranactionState();
}

class _MerchantTranactionState extends State<MerchantTranaction> {
  bool isLoading = true;
  List<MerchantTransactionsClass> data = [];

  getData() async {
    var headers = {'Cookie': 'PHPSESSID=1ljp80udb4p4rbib2mgqomsue8'};
    var request = http.Request(
        'GET',
        Uri.parse(
            '$baseUrl/merchant_transaction.php?input_key=$input_key&input_secret=$input_secret&STejari=$sTejariValue'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      try {
        List res =
            json.decode(await response.stream.bytesToString())["transactions"];
        log(res.toString());
        for (var e in res) {
          data.add(MerchantTransactionsClass(
              offer_id: e["offer_id"].toString(),
              STejari: e["STejari"].toString(),
              user_id: e["user_id"].toString(),
              date_recieved: e["date_recieved"].toString(),
              date_available: e["date_available"].toString(),
              deduction_percent: e["deduction_percent"].toString(),
              operation_type: e["operation_type"].toString(),
              amount: e["amount"].toString(),
              amount_VAT: e["amount_VAT"].toString(),
              deduction_amount: e["deduction_amount"].toString(),
              Final_amount: e["Final_amount"].toString(),
              Final_amount_VAT: e["Final_amount_VAT"].toString(),
              description: e["description"].toString()));
        }
        setState(() {
          isLoading = false;
        });
      } catch (e) {
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
  void initState() {
    getData();
    super.initState();
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
              child: SizedBox(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        getText("LatestTransactions"),
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    data.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(top: 60),
                            child: Center(
                              child: Text(
                                getText("message24"),
                              ),
                            ),
                          )
                        : Column(
                            children: [
                              Container(
                                height: 25,
                              ),
                              for (int i = 0; i < data.length; i++)
                                transaction(i)
                            ],
                          )
                  ],
                ),
              ),
            ),
    );
  }

  Column transaction(int i) {
    return Column(
      children: [
        Row(
          children: [
            Image.asset(
              "assets/status1.png",
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data[i].description,
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    data[i].operation_type,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  Text(
                    "${getText("amount")} ${data[i].amount}",
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  Text(
                    "${getText("deductionAmount")} ${data[i].deduction_amount}",
                    style: const TextStyle(fontSize: 11, color: Colors.red),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(),
            ),
            Column(
              children: [
                Text(
                  data[i].Final_amount,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
                Text(
                  data[i].date_available,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                )
              ],
            ),
            Container(
              width: 16,
            ),
            /* const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 18,
            )*/
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Divider(
            color: greyc,
          ),
        )
      ],
    );
  }
}
