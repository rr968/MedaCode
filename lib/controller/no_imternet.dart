import 'package:flutter/material.dart';
import '/view/splashscreen/splashscreen.dart';

class NoInternet extends StatelessWidget {
  const NoInternet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Image.asset(
              'assets/no_internet.gif',
              height: 200,
              fit: BoxFit.contain,
            ),
            Center(
              child: Text("حدث خطا يرجى التحقق من اتصالك بالانترنت",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Colors.black54, fontWeight: FontWeight.normal)),
            ),
            Container(
              height: 40,
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
                height: 40,
                width: 150,
                decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(10)),
                child: const Center(
                    child: Text(
                  "إعادة المحاولة",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                )),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
