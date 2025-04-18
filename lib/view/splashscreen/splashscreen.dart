// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import '/controller/no_imternet.dart';
import '/controller/var.dart';
import 'package:http/http.dart' as http;
import '/view/mainpage.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import '../auth/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoading = true;
  @override
  void initState() {
    determinePosition().then((value) {
      if (value is LatLong) {
        latLng = value;
      } else {
        snackBar(context, value.toString());
      }
    });
    isMerchant();
    getOffers();
    getToken();
    getdata();
    getPoint();
    getLatestOrder();
    getUnSeenNotifications();
    getLanguageCode();
    Future.delayed(const Duration(seconds: 7)).then((value) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder:
              (context) =>
                  token.trim().isEmpty ? const Login() : const MainPage(),
        ),
        (route) => false,
      );
    });
    super.initState();
  }

  getLanguageCode() async {
    String l = await getLanguage();
    setState(() {
      language = l;
    });
  }

  getUnSeenNotifications() async {
    String userId = await getUserId();
    String url =
        isUserNow
            ? '$baseUrl/notification.php?input_key=$input_key&input_secret=$input_secret&user_id=$userId&scenario=0&target=0'
            : '$baseUrl/notification.php?input_key=$input_key&input_secret=$input_secret&STEjari=$sTejariValue&scenario=0&target=1';
    var request = http.Request('GET', Uri.parse(url));

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      Map data = json.decode(await response.stream.bytesToString());
      log(data.toString());
      if (data["status"] == "success") {
        setState(() {
          unSeenNotiNum = data["data"].length;
        });
      }
    }
  }

  isMerchant() async {
    String userId = await getUserId();

    if (userId != "") {
      var headers = {'Cookie': 'PHPSESSID=i1qpmcm7ou7qus9b1l2ou3bfqp'};
      var request = http.Request(
        'GET',
        Uri.parse(
          '$baseUrl/user_fetcher.php?input_key=$input_key&input_secret=$input_secret&fetch_type=1&id=$userId',
        ),
      );

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        try {
          var data = json.decode(await response.stream.bytesToString())["user"];
          log("/////////////////sTejariValue$data");
          if (data.isNotEmpty) {
            merchantAccountStatus = data["status"].toString();
            sTejariValue = data["STejari"];
            if (merchantAccountStatus == "2") {
              sTejariValue = data["STejari"];
              log("/////////////////sTejariValue$sTejariValue");
            }
          }
        } catch (e) {
          log("isMerchant method error : $e");
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
  }

  getdata() async {
    String id = await getUserId();
    log("///////////   $id");
    try {
      favListIndexes = await getFavList();
      userName = await getUserName();
      firmName = await getFirmName();
      firmPhoto = await getFirmPhoto();
      userPhoto = await getUserPhoto();
      var headers = {'Cookie': 'PHPSESSID=pkjgl6qfq25j4hvhl359mma1ej'};

      var request = http.Request(
        'GET',
        Uri.parse(
          '$baseUrl/products.php?input_key=$input_key&input_secret=$input_secret',
        ),
      );

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        try {
          Map data = json.decode(await response.stream.bytesToString());
          log(data.toString());

          fillData(language == "0" ? data["en"] : data["ar"]);
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
    } catch (_) {
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
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: const BoxDecoration(),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth / 2.6,
            vertical: screenHeight / 2.6,
          ),
          child: Image.asset("assets/splash.png"),
        ),
      ),
    );
  }
}
