import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;

import '../../controller/language.dart';
import '../../controller/textstyle.dart';
import '../../controller/var.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  bool isLoading = true;
  String data = "";

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    var headers = {'Cookie': 'PHPSESSID=rsb4c0bf33us53ekrkeku6q2ln'};

    var request = http.Request('GET', Uri.parse('$baseUrl/polices.php'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      data = await response.stream.bytesToString();
      log(data);

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
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
                      getText("AboutMeda"),
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
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(children: [
                Container(
                    height: screenHeight - 120,
                    width: screenWidth,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25)),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 12),
                      child: isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: orange,
                              ),
                            )
                          : Directionality(
                              textDirection: TextDirection.rtl,
                              child: SingleChildScrollView(
                                child: Html(
                                  data: data,
                                ),
                              ),
                            ),
                    ))
              ])))
    ]));
  }
}
