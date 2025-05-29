import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '/model/withdrawal.dart';
import '../../controller/language.dart';
import '../../controller/no_imternet.dart';
import '../../controller/sucess_popup.dart';
import '../../controller/textstyle.dart';
import '../../controller/var.dart';
import '../notification/notifications.dart';

class Withdrawal extends StatefulWidget {
  final String balance;
  const Withdrawal({super.key, required this.balance});

  @override
  State<Withdrawal> createState() => _WithdrawalState();
}

class _WithdrawalState extends State<Withdrawal> {
  TextEditingController amount = TextEditingController();
  bool isLoading = true;
  List<WithdrawalClass> data = [];
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    String userId = await getUserId();
    String requesterType = isUserNow ? "1" : "2";
    var headers = {'Cookie': 'PHPSESSID=1ljp80udb4p4rbib2mgqomsue8'};
    var request = http.Request(
      'GET',
      Uri.parse(
        '$baseUrl/withdrawls.php?input_key=$input_key&input_secret=$input_secret&requester_type=$requesterType&id=$userId&amount=1&scenario=2',
      ),
    );

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      try {
        List res = json.decode(await response.stream.bytesToString())["data"];
        log(res.toString());
        for (var e in res) {
          data.add(
            WithdrawalClass(
              idx: e["idx"].toString(),
              requester_type: e["requester_type"].toString(),
              id: e["id"].toString(),
              amount: e["amount"].toString(),
              date: e["date"].toString(),
              status: e["status"].toString(),
            ),
          );
        }
        setState(() {
          isLoading = false;
        });
      } catch (e) {
        log(e.toString());
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const NoInternet()),
          (route) => false,
        );
      }
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const NoInternet()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:
          isLoading
              ? Center(child: CircularProgressIndicator(color: orange))
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
                                        getText("WithdrawalRequests"),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                      const NotificationPage(),
                                            ),
                                          );
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
                                                        BorderRadius.circular(
                                                          100,
                                                        ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      unSeenNotiNum.toString(),
                                                      style: const TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
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
                            Container(height: 12),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                getText("AvailableBalance"),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Text(
                              widget.balance,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                _requestDialog();
                              },
                              child: Container(
                                height: 35,
                                width: 120,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text(
                                    getText("WithdrawalRequests"),
                                    style: TextStyle(
                                      color: orange,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 250),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 14,
                            right: 14,
                            top: 25,
                            bottom: 10,
                          ),
                          child: SizedBox(
                            child: ListView(
                              padding: EdgeInsets.zero,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  child: Text(
                                    getText("message25"),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                data.isEmpty
                                    ? Padding(
                                      padding: const EdgeInsets.only(top: 60),
                                      child: Center(
                                        child: Text(getText("message24")),
                                      ),
                                    )
                                    : Column(
                                      children: [
                                        Container(height: 25),
                                        for (int i = 0; i < data.length; i++)
                                          transaction(i),
                                      ],
                                    ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  void _requestDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Directionality(
          textDirection:
              language == "0" ? TextDirection.ltr : TextDirection.rtl,
          child: SizedBox(
            height: MediaQuery.of(context).viewInsets.bottom + 700,
            child: SingleChildScrollView(
              child: SizedBox(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("    "),
                            Text(
                              getText("WithdrawalRequests"),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            InkWell(
                              onTap: () => Navigator.pop(context),
                              child: const Icon(Icons.close),
                            ),
                          ],
                        ),
                      ),
                      Divider(color: greyc),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(height: 60),
                            Text(
                              getText("EnterAmount"),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            SizedBox(
                              width: 150,
                              child: TextField(
                                controller: amount,
                                cursorColor: orange,
                                decoration: InputDecoration(
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: orange),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: orange),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: orange),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 28),
                              child: InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: screenWidth * .22,
                                            ),
                                            child: AlertDialog(
                                              backgroundColor: Colors.white,
                                              surfaceTintColor: Colors.grey,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              title: SizedBox(
                                                height: 30,
                                                width: 30,
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                        color: orange,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                  requestNow();
                                },
                                child: Container(
                                  height: 35,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    color: orange,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: Text(
                                      getText("Request"),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  requestNow() async {
    String userId = await getUserId();
    String requesterType = isUserNow ? "1" : "2";
    var headers = {'Cookie': 'PHPSESSID=1ljp80udb4p4rbib2mgqomsue8'};
    var request = http.Request(
      'GET',
      Uri.parse(
        '$baseUrl/withdrawls.php?input_key=$input_key&input_secret=$input_secret&requester_type=$requesterType&id=$userId&amount=${amount.text}&scenario=1',
      ),
    );

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var res = json.decode(await response.stream.bytesToString());
      Navigator.pop(context);
      Navigator.pop(context);

      amount.text = "";

      try {
        if (res["status"] == 200) {
          //here back
          snackBar(context, getText("message28"));
        } else {
          showAnimatedErrorPopup(context, "Error Try!");
        }
      } catch (e) {
        snackBar(context, e.toString());
      }
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const NoInternet()),
        (route) => false,
      );
    }
  }

  Column transaction(int i) {
    return Column(
      children: [
        Row(
          children: [
            Image.asset("assets/status1.png", height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data[i].idx, style: const TextStyle(fontSize: 12)),
                  Text(
                    data[i].status == "0"
                        ? getText("Pending")
                        : data[i].status == "1"
                        ? getText("Approved")
                        : getText("Rejected"),
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Expanded(child: Container()),
            Column(
              children: [
                Text(
                  data[i].amount,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                Text(
                  data[i].date,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
            Container(width: 6),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Divider(color: greyc),
        ),
      ],
    );
  }
}
