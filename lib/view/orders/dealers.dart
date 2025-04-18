import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../controller/language.dart';
import '/model/dealer.dart';

import '../../controller/no_imternet.dart';
import '../../controller/var.dart';

class Dealers extends StatefulWidget {
  const Dealers({super.key});

  @override
  State<Dealers> createState() => _DealersState();
}

class _DealersState extends State<Dealers> {
  bool isLoading = true;
  List<Dealer> dealers = [];
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    var headers = {'Cookie': 'PHPSESSID=1ljp80udb4p4rbib2mgqomsue8'};
    String userId = await getUserId();
    var request = http.Request(
        'GET',
        Uri.parse(
            '$baseUrl/dealers.php?input_key=$input_key&input_secret=$input_secret&user_id=$userId'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      try {
        Map d = json.decode(await response.stream.bytesToString());
        log(d.toString());
        List data = d["dealers"];

        for (var element in data) {
          dealers.add(Dealer(
              STejari: element["STejari"].toString(),
              name: element["name"].toString(),
              firm: element["firm"].toString(),
              firm_photo: element["firm_photo"].toString(),
              user_photo: element["user_photo"].toString(),
              STejari_ratings: element["STejari_ratings"].toString() == "null"
                  ? "0"
                  : element["STejari_ratings"].toString(),
              STejari_avg_rating:
                  element["STejari_avg_rating"].toString() == "null"
                      ? "0"
                      : element["STejari_avg_rating"].toString()));
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
          : ListView(
              children: [
                for (int i = 0; i < dealers.length; i++)
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  image: DecorationImage(
                                      image:
                                          NetworkImage(dealers[i].firm_photo))),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    dealers[i].firm,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 3),
                                        child: int.parse(dealers[i]
                                                    .STejari_avg_rating) >=
                                                1
                                            ? Image.asset(
                                                "assets/filledstar.png",
                                                height: 15,
                                              )
                                            : Image.asset(
                                                "assets/star.png",
                                                height: 15,
                                                color: Colors.grey,
                                              ),
                                      ),
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(right: 3),
                                          child: int.parse(dealers[i]
                                                      .STejari_avg_rating) >=
                                                  2
                                              ? Image.asset(
                                                  "assets/filledstar.png",
                                                  height: 15,
                                                )
                                              : Image.asset(
                                                  "assets/star.png",
                                                  height: 15,
                                                  color: Colors.grey,
                                                )),
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(right: 3),
                                          child: int.parse(dealers[i]
                                                      .STejari_avg_rating) >=
                                                  3
                                              ? Image.asset(
                                                  "assets/filledstar.png",
                                                  height: 15,
                                                )
                                              : Image.asset(
                                                  "assets/star.png",
                                                  height: 15,
                                                  color: Colors.grey,
                                                )),
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(right: 3),
                                          child: int.parse(dealers[i]
                                                      .STejari_avg_rating) >=
                                                  4
                                              ? Image.asset(
                                                  "assets/filledstar.png",
                                                  height: 15,
                                                )
                                              : Image.asset(
                                                  "assets/star.png",
                                                  height: 15,
                                                  color: Colors.grey,
                                                )),
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(right: 3),
                                          child: int.parse(dealers[i]
                                                      .STejari_avg_rating) >=
                                                  5
                                              ? Image.asset(
                                                  "assets/filledstar.png",
                                                  height: 15,
                                                )
                                              : Image.asset(
                                                  "assets/star.png",
                                                  height: 15,
                                                  color: Colors.grey,
                                                )),
                                      Text(
                                        " ${dealers[i].STejari_avg_rating} ( +${dealers[i].STejari_ratings} ${getText("review")} )",
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Expanded(child: Container())
                          ],
                        ),
                      ),
                      const Divider()
                    ],
                  ),
              ],
            ),
    );
  }
}
