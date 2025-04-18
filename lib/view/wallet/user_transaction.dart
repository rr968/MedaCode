import 'dart:convert';

import 'dart:developer';
import 'package:flutter/material.dart';

import '../../controller/language.dart';
import '../../controller/var.dart';
import 'package:http/http.dart' as http;

import '../../controller/no_imternet.dart';
import '../../model/user_transaction.dart';

class UserTransaction extends StatefulWidget {
  final String balance;
  const UserTransaction({
    super.key,
    required this.balance,
  });

  @override
  State<UserTransaction> createState() => _UserTransactionState();
}

class _UserTransactionState extends State<UserTransaction> {
  bool isLoading = true;
  List<UserTransactionClass> data = [];
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    String userId = await getUserId();
    var headers = {'Cookie': 'PHPSESSID=1ljp80udb4p4rbib2mgqomsue8'};
    var request = http.Request(
        'GET',
        Uri.parse(
            '$baseUrl/user_transactions.php?input_key=$input_key&input_secret=$input_secret&user_id=$userId'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      try {
        //"Incoming transaction" operation_type 1   "Deduction" operation_type 2
        List res =
            json.decode(await response.stream.bytesToString())["transactions"];
        log(res.toString());
        for (var e in res) {
          data.add(UserTransactionClass(
              operation_id: e["operation_id"].toString(),
              user_id: e["user_id"].toString(),
              operation_type: e["operation_type"].toString(),
              amount: e["amount"].toString(),
              offer_ids: e["offer_ids"].toString(),
              date: e["date"].toString(),
              description: e["description"].toString()));
        }

        setState(() {
          isLoading = false;
        });
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
                    data[i].operation_type == "1"
                        ? getText("IncomingTransaction")
                        : getText("Deduction"),
                    style: const TextStyle(
                      fontSize: 12,
                    ),
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
                  data[i].operation_type == "1"
                      ? "+ ${data[i].amount}"
                      : "- ${data[i].amount}",
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: data[i].operation_type == "1"
                          ? Colors.green
                          : Colors.red),
                ),
                Text(
                  data[i].date,
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
        ),
      ],
    );
  }
}
