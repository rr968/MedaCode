// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '/controller/no_imternet.dart';
import '/controller/var.dart';
import '/view/mainpage.dart';
import '../auth/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  bool isLoading = true;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.02,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 40.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.0),
        weight: 40.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 0.02,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 40.0,
      ),
    ]).animate(_controller);

    _controller.repeat(reverse: true); // Make the animation repeat

    // determinePosition().then((value) {
    //   if (value is LatLong) {
    //     latLng = value;
    //   } else {
    //     snackBar(context, value.toString());
    //   }
    // });
    try {
      isMerchant();
      getOffers();
      getToken();
      getdata();
      getPoint();
      getLatestOrder();
      getUnSeenNotifications();
      getLanguageCode();
    } catch (e) {}

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

  @override
  void dispose() {
    _controller.dispose(); // Dispose the animation controller
    super.dispose();
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
      backgroundColor: Colors.white,
      body: SizedBox(
        height: screenHeight,
        width: screenWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(flex: 3),
            FadeTransition(
              opacity: _animation,
              child: Image.asset(
                "assets/splash.png",
                width: screenWidth * 0.35,
                height: screenWidth * 0.35,
              ),
            ),
            Spacer(flex: 2),
            Theme(
              data: Theme.of(context).copyWith(platform: TargetPlatform.iOS),
              child: const CircularProgressIndicator.adaptive(),
            ),
            Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
