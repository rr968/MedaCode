// ignore_for_file: must_be_immutable

import '/controller/language.dart';
import 'package:flutter/material.dart';
import '/controller/var.dart';
import '/view/mainpage.dart';
import '/view/merchant/mainMerchentPage.dart';

class SucessPage extends StatelessWidget {
  String text;
  SucessPage({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: Container()),
          Center(
            child: Image.asset(
              "assets/sucess.png",
              width: 115,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            getText("Success"),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Expanded(child: Container()),
          InkWell(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MainPage()),
                  (route) => false);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: Container(
                height: 35,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: orange, borderRadius: BorderRadius.circular(5)),
                child: Center(
                  child: Text(
                    getText("Close"),
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 30,
          ),
        ],
      ),
    );
  }
}

class SucessPageOffer extends StatelessWidget {
  const SucessPageOffer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: Container()),
          Center(
            child: Image.asset(
              "assets/sucess.png",
              width: 115,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            getText("Success"),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              getText("message22"),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Expanded(child: Container()),
          InkWell(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const MainMerchantPage(pageindex: 1)),
                  (route) => false);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: Container(
                height: 35,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: orange, borderRadius: BorderRadius.circular(5)),
                child: Center(
                  child: Text(
                    getText("Back"),
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 30,
          ),
        ],
      ),
    );
  }
}
