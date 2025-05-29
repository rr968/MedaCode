import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '/model/wallet_charge.dart';
import '../../controller/language.dart';
import '../../controller/no_imternet.dart';
import '../../controller/provider.dart';
import '../../controller/textstyle.dart';
import '../../controller/var.dart';
import '../notification/notifications.dart';

class WalletBills extends StatefulWidget {
  const WalletBills({super.key});

  @override
  State<WalletBills> createState() => _WalletBillsState();
}

class _WalletBillsState extends State<WalletBills> {
  TextEditingController amount = TextEditingController();
  bool isLoading = true;
  bool loadingRefresh = false;

  List<WalletCharge> data = [];

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
        '$baseUrl/sadad_status.php?input_key=$input_key&input_secret=$input_secret&user_id=$userId',
      ),
    );

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      data = [];
      try {
        List res = json.decode(await response.stream.bytesToString())["data"];
        log(res.toString());
        for (var e in res) {
          data.add(
            WalletCharge(
              user_id: e["user_id"].toString(),
              bill_number: e["bill_number"].toString(),
              saddad_number: e["saddad_number"].toString(),
              amount: e["amount"].toString(),
              issue_date: e["issue_date"].toString(),
              date_of_expiration: e["date_of_expiration"].toString(),
              status: e["status"].toString(),
              status_description: e["status_description"].toString(),
              status_code: e["status_code"].toString(),
            ),
          );
        }

        setState(() {
          isLoading = false;
        });
      } catch (_) {
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
                                        getText("Wallet"),
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
                              padding: const EdgeInsets.symmetric(vertical: 17),
                              child: InkWell(
                                onTap: () {
                                  _chargeMenu();
                                },
                                child: Column(
                                  children: [
                                    Image.asset(
                                      "assets/charge.png",
                                      height: 25,
                                    ),
                                    Text(
                                      getText("ChargeWallet"),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                      child: Text(
                                        getText("SadadTransactions"),
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
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

  Column transaction(int i) {
    return Column(
      children: [
        Row(
          children: [
            Image.asset(
              data[i].status_code == "1"
                  ? "assets/status1.png"
                  : data[i].status_code == "3"
                  ? "assets/status2.png"
                  : "assets/status3.png",
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data[i].status_code == "1"
                        ? getText("Paid")
                        : data[i].status_code == "2"
                        ? getText("ExpiredNotpaid")
                        : getText("Pending"),
                    style: const TextStyle(fontSize: 11),
                  ),
                  Text(
                    "${getText("SNumber")} ${data[i].saddad_number}",
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Expanded(child: Container()),
            Column(
              children: [
                Text(
                  "+ ${data[i].amount}",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color:
                        data[i].status_code == "1"
                            ? Colors.green
                            : data[i].status_code == "3"
                            ? orange
                            : Colors.red,
                  ),
                ),
                Text(
                  data[i].issue_date,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
            Container(width: 6),
            data[i].status_code == "3"
                ? InkWell(
                  onTap: () {
                    if (!loadingRefresh) {
                      setState(() {
                        loadingRefresh = true;
                      });
                      checkStatus(data[i].bill_number, i);
                    }
                  },
                  child:
                      loadingRefresh
                          ? CircularProgressIndicator(color: orange)
                          : const Icon(Icons.refresh),
                )
                : Container(),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Divider(color: greyc),
        ),
      ],
    );
  }

  Future<void> checkStatus(String billNumber, int index) async {
    String userId = await getUserId();

    var headers = {'Cookie': 'PHPSESSID=1ljp80udb4p4rbib2mgqomsue8'};
    var request = http.Request(
      'GET',
      Uri.parse(
        '$baseUrl/saddad_transfer_check.php?input_key=$input_key&input_secret=$input_secret&id=$userId&billNumber=$billNumber',
      ),
    );

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      Map res = json.decode(await response.stream.bytesToString());
      try {
        if (res["status"] != "error") {
          try {
            String walletBalance2 =
                Provider.of<MyProvider>(
                  context,
                  listen: false,
                ).getwalletBalance();
            double total =
                double.parse(walletBalance2) + double.parse(data[index].amount);
            Provider.of<MyProvider>(
              context,
              listen: false,
            ).setwalletBalance(total.toString());
          } catch (_) {}

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const WalletBills()),
          );
        } else {
          snackBar(context, res["message"].toString());
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

  void _chargeMenu() {
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
                              getText("ChargeWallet"),
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
                                  payNow();
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
                                      getText("Pay"),
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

  payNow() async {
    String userId = await getUserId();
    String name = await getUserName();
    String mobile = await getUserphone();
    String email = await getUserEmail();

    var headers = {'Cookie': 'PHPSESSID=1ljp80udb4p4rbib2mgqomsue8'};
    var request = http.Request(
      'GET',
      Uri.parse(
        '$baseUrl/saddad.php?input_key=$input_key&input_secret=$input_secret&product_name=product1&quantity=1&unit_price=${amount.text}&discount=0&discount_type=FIXED&vat=0.00&customer_full_name=$name&customer_email_address=$email&customer_mobile_number=$mobile&user_id=$userId',
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
          snackBar(context, getText("message26"));
        } else {
          snackBar(context, res["message"].toString());
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
}
