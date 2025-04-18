// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import '../../controller/language.dart';
import '/controller/var.dart';
import 'package:http/http.dart' as http;
import '/view/auth/verify_pass.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController phone = TextEditingController();
  TextEditingController pass1 = TextEditingController();
  TextEditingController pass2 = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: language == "0" ? TextDirection.ltr : TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Stack(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: orange,
                    size: 30,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getText("ResetPassword"),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextField(
                    controller: phone,
                    decoration: InputDecoration(
                        hintText: getText("message3"),
                        hintStyle:
                            const TextStyle(color: Colors.grey, fontSize: 15),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 5)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: pass1,
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: getText("Password"),
                        hintStyle:
                            const TextStyle(color: Colors.grey, fontSize: 15),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 5)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: pass2,
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: getText("ConfirmPassword"),
                        hintStyle:
                            const TextStyle(color: Colors.grey, fontSize: 15),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 5)),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  InkWell(
                    onTap: () {
                      resetPass();
                    },
                    child: Container(
                      height: 35,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: orange,
                          borderRadius: BorderRadius.circular(5)),
                      child: Center(
                        child: isLoading
                            ? const CircularProgressIndicator()
                            : Text(
                                getText("ResetPassword"),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  resetPass() async {
    if (pass1.text.trim() != pass2.text.trim()) {
      snackBar(context, getText("message4"));
    } else {
      setState(() {
        isLoading = true;
      });
      var headers = {'Cookie': 'PHPSESSID=rsb4c0bf33us53ekrkeku6q2ln'};
      var request = http.Request(
          'GET',
          Uri.parse(
              '$baseUrl/resetpass1.php?input_key=$input_key&input_secret=$input_secret&phone=${phone.text.trim()}'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        Map data = json.decode(await response.stream.bytesToString());

        if (data["status"] != "error") {
          setState(() {
            isLoading = false;
          });

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => VerifyPass(
                        email: phone.text.trim(),
                        newPass: pass1.text,
                        secretNumber: data["secret_number"],
                      )),
              (route) => false);
        } else {
          setState(() {
            isLoading = false;
          });
          try {
            snackBar(context, data["message"]);
          } catch (e) {
            snackBar(context, getText("fillCorrectlly"));
          }
        }
      } else {
        setState(() {
          isLoading = false;
        });

        snackBar(context, getText("checkInternet"));
      }
    }
  }
}
