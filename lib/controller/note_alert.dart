import 'package:finaltest/view/auth/login.dart';

import '/controller/language.dart';
import 'package:flutter/material.dart';
import '/controller/var.dart';

noteAlert(context, String text1, Function()? fun) {
  showDialog(
    context: context,
    builder: (context) {
      return FittedBox(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            title: Column(
              children: [
                SizedBox(
                  height: 100,
                  child: Image.asset("assets/note.gif", fit: BoxFit.fill),
                ),
                const SizedBox(height: 20),
                Text(
                  text1,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Container(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: fun,
                      child: Container(
                        height: 40,
                        width: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: orange,
                        ),
                        child: Center(
                          child: Text(
                            getText("Yes"),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 40,
                        width: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: orange,
                        ),
                        child: Center(
                          child: Text(
                            getText("No"),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      );
    },
  );
}

noteAlert2(context) {
  showDialog(
    context: context,
    builder: (context) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Column(
            children: [
              SizedBox(
                height: 100,
                child: Image.asset("assets/note.gif", fit: BoxFit.fill),
              ),
              const SizedBox(height: 20),
              Text(
                getText("message100"),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Container(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 40,
                      width: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: orange,
                      ),
                      child: Center(
                        child: Text(
                          getText("OK2"),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      );
    },
  );
}

loadingAlert(context, String text1, fun) {
  showDialog(
    barrierColor: Colors.white,
    context: context,
    builder: (context) {
      return FittedBox(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
        ),
      );
    },
  );
}

void showSignInDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return FittedBox(
        child: Directionality(
          textDirection: TextDirection.ltr,

          child: AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            title: const Text("Sign In Required"),
            content: const Text("You need to sign in to access this feature."),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("Cancel", style: TextStyle(color: orange)),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: orange, // 🔶 Background color
                ),
                child: Text("Sign In", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    },
  );
}
