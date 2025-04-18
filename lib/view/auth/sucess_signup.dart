import '/controller/language.dart';
import 'package:flutter/material.dart';
import '/controller/var.dart';
import '/view/merchant/upgradeToMarchant/upgrade_account.dart';
import '/view/splashscreen/splashscreen.dart';

class SucessSignUp extends StatelessWidget {
  const SucessSignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Directionality(
      textDirection: language == "0" ? TextDirection.ltr : TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            Expanded(child: Container()),
            Padding(
              padding: const EdgeInsets.all(60),
              child: Image.asset("assets/Done.png"),
            ),
            Text(
              getText("Congratulations"),
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 17),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              getText("message7"),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54, fontSize: 12),
            ),
            Expanded(child: Container()),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UpgradeAccount()));
              },
              child: Container(
                height: 35,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: orange, borderRadius: BorderRadius.circular(5)),
                child: Center(
                  child: Text(
                    getText("Upgradeaccount"),
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            InkWell(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SplashScreen()),
                    (route) => false);
              },
              child: Container(
                height: 35,
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(color: orange),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
                child: Center(
                  child: Text(
                    getText("GoToMain"),
                    style: TextStyle(
                        color: orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    ));
  }
}

class SuccessReceivedRequest extends StatelessWidget {
  const SuccessReceivedRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            Expanded(child: Container()),
            Padding(
              padding: const EdgeInsets.all(60),
              child: Image.asset("assets/Done.png"),
            ),
            Text(
              getText("Congratulations"),
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              getText("message8"),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54, fontSize: 15),
            ),
            Expanded(child: Container()),
            InkWell(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SplashScreen()),
                      (route) => false);
                },
                child: Container(
                  height: 35,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: orange, borderRadius: BorderRadius.circular(5)),
                  child: Center(
                    child: Text(
                      getText("GoToMain"),
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                  ),
                )),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
