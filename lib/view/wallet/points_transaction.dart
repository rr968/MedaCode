import 'dart:convert';

import 'dart:developer';
import '/controller/language.dart';
import 'package:flutter/material.dart';

import '../../controller/textstyle.dart';
import '../../controller/var.dart';
import 'package:http/http.dart' as http;

import '../../controller/no_imternet.dart';
import '../../model/user_transaction.dart';
import '../notification/notifications.dart';

class PointsTransaction extends StatefulWidget {
  final String balance;
  const PointsTransaction({
    super.key,
    required this.balance,
  });

  @override
  State<PointsTransaction> createState() => _PointsTransactionState();
}

class _PointsTransactionState extends State<PointsTransaction> {
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
            '$baseUrl/points_transaction.php?input_key=$input_key&input_secret=$input_secret&user_id=$userId'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      try {
        List res = json.decode(await response.stream.bytesToString())["points"];
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
      } catch (e) {
        log(e.toString());
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
                                      getText("Points"),
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
                                getText("AvaiablePoints"),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ),
                            Text(
                              points,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 190),
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30))),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 14, right: 14, top: 25, bottom: 10),
                          child: SizedBox(
                            child: ListView(
                              padding: EdgeInsets.zero,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: Text(
                                    getText("LatestTransactions"),
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
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
                      ),
                    )
                  ],
                ),
              ));
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
                    getText("message27"),
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  )
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
        )
      ],
    );
  }
}
