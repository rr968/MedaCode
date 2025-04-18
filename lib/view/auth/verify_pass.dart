// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import '../../controller/language.dart';
import '/controller/var.dart';
import 'package:http/http.dart' as http;
import '/view/auth/login.dart';

class VerifyPass extends StatefulWidget {
  String email;
  String newPass;
  String secretNumber;
  VerifyPass(
      {super.key,
      required this.email,
      required this.newPass,
      required this.secretNumber});

  @override
  State<VerifyPass> createState() => _VerifyPassState();
}

class _VerifyPassState extends State<VerifyPass> {
  bool isLoading = false;

  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;
  bool _otpError = false;
  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(4, (index) => FocusNode());
    _controllers = List.generate(4, (index) => TextEditingController());
    _focusNodes[0].requestFocus();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void clearInputs() {
    setState(() {
      _otpError = true;
      for (var controller in _controllers) {
        controller.clear();
      }
      _focusNodes[0].requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: language == "0" ? TextDirection.ltr : TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getText("Verification"),
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 27),
              ),
              const SizedBox(
                height: 5,
              ),
              RichText(
                text: TextSpan(
                  text: getText("message6"),
                  style: const TextStyle(color: Colors.grey, fontSize: 17),
                  children: [
                    TextSpan(
                      text: widget.email,
                      style: TextStyle(color: orange, fontSize: 17),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  4,
                  (index) => SizedBox(
                    width: 50,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      maxLength: 1,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 3) {
                          _focusNodes[index + 1].requestFocus();
                        }
                        if (_otpError && value.isNotEmpty) {
                          setState(() {
                            _otpError = false;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        counter: const Offstage(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: _otpError ? Colors.red : Colors.grey,
                              width: _otpError ? 2 : 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: _otpError ? Colors.red : orange,
                              width: _otpError ? 2 : 1),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 70,
              ),
              InkWell(
                onTap: () {
                  resetPass();
                },
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: orange, borderRadius: BorderRadius.circular(5)),
                  child: Center(
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : Text(
                            getText("Verify"),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  resetPass() async {
    if (_controllers[0].text +
            _controllers[1].text +
            _controllers[2].text +
            _controllers[3].text ==
        widget.secretNumber) {
      setState(() {
        isLoading = true;
      });
      var headers = {'Cookie': 'PHPSESSID=rsb4c0bf33us53ekrkeku6q2ln'};
      var request = http.Request(
          'POST',
          Uri.parse(
              '$baseUrl/resetpass2.php?input_key=$input_key&input_secret=$input_secret&phone=${widget.email}&newpass=${widget.newPass}'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        Map data = json.decode(await response.stream.bytesToString());

        if (data["status"] != "error") {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const Login()),
              (route) => false);
          snackBar(context, "password reset successfully");
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
    } else {
      clearInputs();
    }
  }
}
