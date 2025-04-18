// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'dart:developer';

import '/controller/language.dart';
import 'package:flutter/material.dart';
import '/controller/var.dart';
import '/view/sucess.dart';
import 'package:moyasar/moyasar.dart';
import 'package:http/http.dart' as http;

class PaymentViewScreen extends StatefulWidget {
  final double amount;
  final String publishableSecretKey;
  final String secretKey;
  final int points_discounted;
  final String level1_id;

  const PaymentViewScreen({
    super.key,
    required this.amount,
    required this.publishableSecretKey,
    required this.secretKey,
    required this.points_discounted,
    required this.level1_id,
  });

  @override
  State<PaymentViewScreen> createState() => _PaymentViewScreenState();
}

class _PaymentViewScreenState extends State<PaymentViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(40),
                  child: Image.asset(
                    "assets/splash.png",
                    height: 110,
                  ),
                ),
                CreditCard(
                  config: PaymentConfig(
                    publishableApiKey: widget.publishableSecretKey,
                    amount: widget.amount.toInt() * 100,
                    description: getText("MedaApp"),
                    metadata: {},
                    creditCard:
                        CreditCardConfig(saveCard: false, manual: false),
                  ),
                  onPaymentResult: (result) async {
                    if (result is PaymentResponse) {
                      switch (result.status) {
                        case PaymentStatus.paid:
                          try {
                            String date_created = DateTime.now().toString();
                            double lat = latLng?.latitude ?? 0;
                            double long = latLng?.longitude ?? 0;

                            Map address =
                                await getAddressFromCoordinates(latLng) ?? {};

                            String addressEn = address["address_en"];

                            String addressAr = address["address_ar"];
                            String cityEn = address["city_en"];

                            String cityAr = address["city_ar"];
                            log("///////////////address from coordinates/////////////");
                            log(addressEn);
                            log(addressAr);
                            log(cityEn);
                            log(cityAr);
                            String userId = await getUserId();
                            var headers = {
                              'Cookie': 'PHPSESSID=19g90sr1qvpa8cnqd2f2qgjv9i'
                            };
                            var request = http.Request(
                                'GET',
                                Uri.parse(
                                    "$baseUrl/order_payment.php?input_key=cr3cr3cc3ec3cFEWRCTVR34324c@xcwe3243&input_secret=fmciofnirofmRCCFEDcfr@5342323CFWC&user_id=$userId&level1_id=${widget.level1_id}&date_created=$date_created&date_paid=$date_created&price=${widget.amount}&points_discounted=${widget.points_discounted}&payment_id=${result.id}&address_ar=$addressAr&address_en=$addressEn&lat=$lat&long=$long&city_ar=$cityAr&city_en=$cityEn&duration=3"));

                            request.headers.addAll(headers);

                            http.StreamedResponse response =
                                await request.send();
                            if (response.statusCode == 200) {
                              try {
                                var request = http.Request(
                                    'GET',
                                    Uri.parse(
                                        "$baseUrl/pointdeduction.php?input_key=cr3cr3cc3ec3cFEWRCTVR34324c@xcwe3243&input_secret=fmciofnirofmRCCFEDcfr@5342323CFWC&id=$userId&cost=${widget.points_discounted}"));

                                request.headers.addAll(headers);

                                await request.send();
                              } catch (_) {}
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SucessPage(
                                          text: getText("message23"))),
                                  (route) => false);
                            } else {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const FailPage()),
                                  (route) => false);
                            }
                          } catch (_) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const FailPage()),
                                (route) => false);
                          }
                          break;
                        case PaymentStatus.failed:
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const FailPage()),
                              (route) => false);
                          break;

                        default:
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const FailPage()),
                              (route) => false);
                      }
                      return;
                    }
                  },
                )
              ],
            ),
          ),
        ));
  }
}

class FailPage extends StatelessWidget {
  const FailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fail"),
      ),
      body: const Center(
        child: Text("Payment fail"),
      ),
    );
  }
}
