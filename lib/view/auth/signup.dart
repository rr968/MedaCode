// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../controller/language.dart';
import '/controller/var.dart';

import 'verification.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  String codeText = "";
  bool loadingCode = false;
  signup(String name, String pass, String phone, String emailv,
      String code) async {
    if (name.trim().isEmpty || pass.trim().isEmpty || phone.trim().isEmpty) {
      snackBar(context, getText("fillCorrectlly"));
    } else {
      setState(() {
        isLoading = true;
      });
      var headers = {'Cookie': 'PHPSESSID=rsb4c0bf33us53ekrkeku6q2ln'};
      var request = http.Request(
          'POST',
          Uri.parse(
              '$baseUrl/signup.php?input_key=$input_key&input_secret=$input_secret&name=$name&phone=$phone&email=$emailv&password=$pass'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        Map data = json.decode(await response.stream.bytesToString());

        if (data["status"] != "error") {
          setState(() {
            isLoading = false;
          });
          try {
            String secretNum = data["secret_number"];
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Verification(
                        name: name,
                        pass: pass,
                        phone: phone,
                        emailv: emailv,
                        code: code,
                        secretNumber: secretNum,
                      )),
            );
          } catch (e) {
            snackBar(context, getText("checkInternet"));
          }
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

  checkCode(String text) async {
    setState(() {
      loadingCode = true;
    });
    var request = http.Request(
        'GET',
        Uri.parse(
            '$baseUrl/checkcode.php?input_key=$input_key&input_secret=$input_secret&reference=$text'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      try {
        String a = await response.stream.bytesToString();
        setState(() {
          loadingCode = false;
          codeText = a == "0" ? "Valid Code" : "Invalid Code";
        });
      } catch (_) {}
    }
  }

  TextEditingController fullName = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController mobileNumber = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController invitationCode = TextEditingController();
  bool checkBox = false;
  bool passwordVisibillity = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Directionality(
      textDirection: language == "0" ? TextDirection.ltr : TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Stack(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: orange,
                      size: 24,
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight - 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getText("SignUp"),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        getText("message1"),
                        style: const TextStyle(
                            color: Color.fromARGB(255, 131, 131, 131),
                            fontSize: 11),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      TextField(
                        controller: fullName,
                        decoration: InputDecoration(
                            hintText: getText("FullName"),
                            hintStyle: const TextStyle(
                                color: Colors.grey, fontSize: 11),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 5)),
                      ),
                      Text(
                        getText("message2"),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color.fromARGB(255, 131, 131, 131),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextField(
                        controller: password,
                        obscureText: passwordVisibillity,
                        decoration: InputDecoration(
                            suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  passwordVisibillity = !passwordVisibillity;
                                });
                              },
                              child: passwordVisibillity
                                  ? const Icon(Icons.visibility_off)
                                  : const Icon(Icons.visibility),
                            ),
                            hintText: getText("Password"),
                            hintStyle: const TextStyle(
                                color: Colors.grey, fontSize: 11),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 5)),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextField(
                        controller: mobileNumber,
                        decoration: InputDecoration(
                            hintText: getText("MobileNumber"),
                            hintStyle: const TextStyle(
                                color: Colors.grey, fontSize: 11),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 5)),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextField(
                        controller: email,
                        decoration: InputDecoration(
                            hintText: getText("Email"),
                            hintStyle: const TextStyle(
                                color: Colors.grey, fontSize: 11),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 5)),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextField(
                        controller: invitationCode,
                        onChanged: (value) {
                          checkCode(value);
                        },
                        decoration: InputDecoration(
                            hintText: getText("InvitationCode"),
                            hintStyle: const TextStyle(
                                color: Colors.grey, fontSize: 11),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 5)),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      loadingCode
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              codeText,
                              style: TextStyle(
                                  color: codeText != "Invalid Code"
                                      ? Colors.green
                                      : Colors.red),
                            ),
                      const SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () {
                          signup(
                              fullName.text,
                              password.text,
                              mobileNumber.text,
                              email.text,
                              invitationCode.text);
                        },
                        child: Container(
                          height: 35,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: orange,
                              borderRadius: BorderRadius.circular(5)),
                          child: Center(
                            child: isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    getText("SignUp"),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
