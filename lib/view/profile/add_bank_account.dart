import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../controller/language.dart';
import '../../controller/sucess_popup.dart';
import '../../controller/textstyle.dart';
import '../../controller/var.dart';

class AddBankAccount extends StatefulWidget {
  const AddBankAccount({super.key});

  @override
  State<AddBankAccount> createState() => _AddBankAccountState();
}

class _AddBankAccountState extends State<AddBankAccount> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController bankNameController = TextEditingController();
  TextEditingController ibanController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: language == "0" ? TextDirection.ltr : TextDirection.rtl,
        child: Stack(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15))),
              child: Stack(
                children: [
                  Image.asset(
                    "assets/Logo Shape.png",
                    width: 150,
                  ),
                  SafeArea(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 12, right: 12, top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              )),
                          Text(
                            getText("BankingAccounts"),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            "     ",
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: Platform.isIOS ? 100 : 65),
              child: Container(
                height: screenHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildTextField(
                          controller: bankNameController,
                          label: getText("BankName"),
                          hint: getText("BankName"),
                          icon: Icons.account_balance,
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          controller: ibanController,
                          label: getText("IBAN"),
                          hint: getText("IBAN"),
                          icon: Icons.credit_card,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your IBAN';
                            } else if (!RegExp(r'^[A-Z0-9]{15,34}$')
                                .hasMatch(value)) {
                              return 'Please enter a valid IBAN';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              if (!isLoading) {
                                setState(() {
                                  isLoading = true;
                                });
                                await _submitForm();
                              }
                            }
                          },
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  getText("Submit"),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 18),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: orange, width: 2.0),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: orange, width: 1.0),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      style: const TextStyle(fontSize: 14),
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Please fill this field';
            }
            return null;
          },
    );
  }

  Future<void> _submitForm() async {
    var headers = {'Cookie': 'PHPSESSID=rsb4c0bf33us53ekrkeku6q2ln'};
    String target = isUserNow ? "1" : "2";
    String userId = await getUserId();
    var request = http.Request(
      'GET',
      Uri.parse(
          '$baseUrl/bank_accounts.php?input_key=$input_key&input_secret=$input_secret&target_type=$target&id=$userId&bank=${bankNameController.text}&iban=${ibanController.text}&scenario=1'),
    );

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // Map data = json.decode(await response.stream.bytesToString());

      setState(() {
        isLoading = false;
      });

      Navigator.pop(context);
      Navigator.pop(context);

      showAnimatedSuccessPopup(context, "Done Successfully!");
    }
  }
}
