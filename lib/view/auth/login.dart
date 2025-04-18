// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import '/controller/language.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/view/auth/forget_password.dart';
import '/view/auth/signup.dart';
import '/view/mainpage.dart';
import '/controller/var.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoading = false;

  TextEditingController mobileNumber = TextEditingController();
  TextEditingController password = TextEditingController();
  bool checkBox = false;
  bool passwordVisibillity = true;
  @override
  void initState() {
    getdata().then((v) {});

    super.initState();
  }

  getdata() async {
    getUserphone().then((value) {
      mobileNumber.text = value;
    });
    getUserpassword().then((value) {
      setState(() {
        password.text = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: language == "0" ? TextDirection.ltr : TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Container()),
              Text(
                getText("SignIn"),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                getText("WBack"),
                style: const TextStyle(
                    color: Color.fromARGB(255, 131, 131, 131), fontSize: 13),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: mobileNumber,
                decoration: InputDecoration(
                    hintText: getText("MobileNumber"),
                    hintStyle:
                        const TextStyle(color: Colors.grey, fontSize: 11),
                    contentPadding: const EdgeInsets.symmetric(vertical: 5)),
              ),
              const SizedBox(
                height: 20,
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
                    hintStyle:
                        const TextStyle(color: Colors.grey, fontSize: 11),
                    contentPadding: const EdgeInsets.symmetric(vertical: 5)),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                          value: checkBox,
                          checkColor: Colors.white,
                          activeColor: orange,
                          onChanged: (value) {
                            setState(() {
                              checkBox = value!;
                            });
                          }),
                      Text(
                        getText("RememberMe"),
                        style: const TextStyle(fontSize: 12),
                      )
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ForgetPassword()));
                    },
                    child: Text(
                      getText("ForgetPassword"),
                      style: TextStyle(
                          color: orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 10),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  login(mobileNumber.text, password.text);
                },
                child: Container(
                  height: 35,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: orange, borderRadius: BorderRadius.circular(5)),
                  child: Center(
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : Text(
                            getText("Login"),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                  ),
                ),
              ),
              Expanded(child: Container()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    getText("account"),
                    style: const TextStyle(fontSize: 12),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUp()));
                    },
                    child: Text(
                      getText("SignUp"),
                      style: TextStyle(
                          color: orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  login(String mobile, String password) async {
    if (mobile.trim().isEmpty || password.trim().isEmpty) {
      snackBar(context, getText("fillCorrectlly"));
    } else {
      setState(() {
        isLoading = true;
      });
      var headers = {'Cookie': 'PHPSESSID=rsb4c0bf33us53ekrkeku6q2ln'};
      var request = http.Request(
          'GET',
          Uri.parse(
              '$baseUrl/login.php?input_key=$input_key&input_secret=$input_secret&phone=$mobile&password=$password'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        Map data = json.decode(await response.stream.bytesToString());

        if (data["status"] == "success") {
          setUserphone(mobile);
          setUserpassword(password);
          setUserEmail(data["user"]["email"]);
          setUserPhoto(data["user"]["user_photo"]);
          setFirmPhoto(data["user"]["firm_photo"]);
          setFirmName(data["user"]["firm"]);
          setState(() {
            isLoading = false;
          });
          setUserId(data["user"]["id"]);

          setToken(data["session"]);
          userName = data["user"]["name"];

          firmName = data["user"]["firm"];
          firmPhoto = data["user"]["firm_photo"];
          userPhoto = data["user"]["user_photo"];

          setUserName(data["user"]["name"]).then((v) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const MainPage()),
                (route) => false);
          });
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
