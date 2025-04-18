// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import '../../controller/language.dart';
import '../profile/about.dart';
import '/controller/no_imternet.dart';
import '/controller/provider.dart';
import '/controller/var.dart';
import 'package:http/http.dart' as http;
import '/view/pay.dart';
import '/view/sucess.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:provider/provider.dart';

class CheckOut extends StatefulWidget {
  final String level1Id;
  final String addressName;
  const CheckOut({
    super.key,
    required this.level1Id,
    required this.addressName,
  });

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  bool isloading = false;
  bool priceLoading = false;
  bool? checkbox = false;
  bool switchValue = false;

  double price = 100;
  double priceAfterSubThePoints = 100;
  int dividedBy = 10;
  String typePay = "0";
  String secretKey = "";
  String publishableKey = "";
  int counter = 0;
  String address = "";
  int detuctedPoints = 0;
  void _pickLocation() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => Scaffold(
              appBar: AppBar(title: const Text('Pick Location')),
              body: OpenStreetMapSearchAndPick(
                zoomInIcon: Icons.zoom_in,
                zoomOutIcon: Icons.zoom_out,
                buttonColor: orange,
                locationPinText: "",
                locationPinIconColor: orange,
                onPicked: (PickedData pickedData) async {
                  latLng = pickedData.latLong;

                  // Check if getAddressFromCoordinates() is returning a valid response
                  Map? address = await getAddressFromCoordinates(latLng);

                  if (address == null || address.isEmpty) {
                    print("Error: Address not found or API response invalid");
                    return;
                  }

                  String add =
                      language == "0"
                          ? address["address_en"] ?? "Unknown Address"
                          : address["address_ar"] ?? "Unknown Address";

                  setState(() {
                    Provider.of<MyProvider>(
                      context,
                      listen: false,
                    ).setaddressName(add);
                    Navigator.pop(context);
                  });
                },
              ),
            ),
      ),
    );
  }

  getTypePay() async {
    Provider.of<MyProvider>(
      context,
      listen: false,
    ).setaddressName(widget.addressName);
    var request = http.Request('GET', Uri.parse('$baseUrl/falos_o.php'));

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      Map data = json.decode(await response.stream.bytesToString());
      setState(() {
        typePay = data["type"];

        counter++;
      });
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const NoInternet()),
        (route) => false,
      );
    }
  }

  getDividePoint() async {
    var request = http.Request(
      'GET',
      Uri.parse(
        '$baseUrl/points_division.php?input_key=$input_key&input_secret=$input_secret',
      ),
    );

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      Map data = json.decode(await response.stream.bytesToString());
      setState(() {
        dividedBy = data["division"];
        counter++;
      });
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const NoInternet()),
        (route) => false,
      );
    }
  }

  getPayInfo() async {
    var request = http.Request(
      'GET',
      Uri.parse(
        '$baseUrl/keysa.php?input_key=$input_key&input_secret=$input_secret',
      ),
    );

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      Map data = json.decode(await response.stream.bytesToString());
      setState(() {
        secretKey = data["secret_key"];
        publishableKey = data["publishable_key"];
        counter++;
      });
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const NoInternet()),
        (route) => false,
      );
    }
  }

  @override
  void initState() {
    getTypePay();
    getDividePoint();
    getPayInfo();
    determinePosition().then((value) {
      if (value is LatLong) {
        latLng = value;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: language == "0" ? TextDirection.ltr : TextDirection.rtl,
        child: SafeArea(
          child:
              counter < 3
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 5,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(Icons.arrow_back_ios, size: 22),
                            ),
                            Text(
                              getText("Checkout"),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Container(width: 25),
                          ],
                        ),
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15,
                        ),
                        child: Text(
                          getText("Sitelocation"),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => _pickLocation(),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Icon(
                                Icons.location_pin,
                                size: 22,
                                color: Color.fromARGB(255, 110, 110, 110),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                Provider.of<MyProvider>(
                                      context,
                                      listen: true,
                                    ).getaddressName() ??
                                    "",
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Text(
                                getText("ChangeLocation"),
                                style: TextStyle(color: orange, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                      typePay == "0"
                          ? Container()
                          : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 20,
                                  bottom: 8,
                                  right: 15,
                                  left: 15,
                                ),
                                child: Text(
                                  getText("Payment"),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                                child: Text(
                                  getText("message44"),
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 15,
                                  top: 12,
                                ),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value:
                                          double.parse(points) <= 0
                                              ? false
                                              : checkbox,
                                      activeColor: orange,
                                      onChanged: (value) {
                                        checkbox = value;
                                        detuctedPoints = 0;

                                        priceAfterSubThePoints = price;
                                        if (value == true) {
                                          priceAfterSubThePoints =
                                              price -
                                              int.parse(points) / dividedBy;
                                          detuctedPoints = int.parse(points);
                                          if (priceAfterSubThePoints < 0) {
                                            priceAfterSubThePoints = 0;
                                            detuctedPoints =
                                                int.parse(points) -
                                                (price * dividedBy).toInt();
                                          }
                                        } else {
                                          detuctedPoints = 0;
                                          priceAfterSubThePoints = price;
                                        }

                                        setState(() {});
                                      },
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          getText("message43"),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color:
                                                double.parse(points) <= 0
                                                    ? Colors.grey
                                                    : Colors.black,
                                          ),
                                        ),
                                        Text(
                                          "${getText("pointbalance")} $points",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color:
                                                double.parse(points) <= 0
                                                    ? Colors.grey
                                                    : orange,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Expanded(child: Container()),
                                    Text(
                                      "480 ${getText("points")} = ${480 / dividedBy} ${getText("SR")}",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                      Expanded(child: Container()),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 6,
                        ),
                        child: Row(
                          children: [
                            Text(
                              getText("message41"),
                              style: const TextStyle(fontSize: 12),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const About(),
                                  ),
                                );
                              },
                              child: Text(
                                getText("message42"),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(child: Container()),
                            Transform.scale(
                              scale: .7,
                              child: Switch(
                                value: switchValue,
                                activeColor: Colors.orange,
                                onChanged: (value) {
                                  setState(() {
                                    switchValue = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      typePay == "0"
                          ? Container()
                          : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: InkWell(
                              child: Container(
                                height: 35,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: const Color(0xffF0F0F0),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 25,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        getText("OrderFees"),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "$priceAfterSubThePoints ${getText("SR")}",
                                        style: TextStyle(
                                          decorationColor: orange,
                                          fontWeight: FontWeight.bold,
                                          color: orange,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                      InkWell(
                        onTap: () {
                          if (!isloading) {
                            if (switchValue) {
                              if (priceAfterSubThePoints > 0 &&
                                  typePay != "0") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => PaymentViewScreen(
                                          amount: priceAfterSubThePoints,
                                          publishableSecretKey: publishableKey,
                                          secretKey: secretKey,
                                          points_discounted: detuctedPoints,
                                          level1_id: widget.level1Id,
                                        ),
                                  ),
                                );
                              } else {
                                setState(() {
                                  isloading = true;
                                });
                                orderWithoutPayment(widget.level1Id);
                              }
                            } else {
                              snackBar(context, getText("message40"));
                            }
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 15,
                          ),
                          child: Container(
                            height: 35,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: orange,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child:
                                  isloading
                                      ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      )
                                      : Text(
                                        typePay == "0"
                                            ? getText("Continue")
                                            : getText("Pay"),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
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

  orderWithoutPayment(String leve1) async {
    try {
      String date_created = DateTime.now().toString();
      double lat = latLng?.latitude ?? 0;
      double long = latLng?.longitude ?? 0;
      log("///////////////address from coordinates/////////////");
      Map address = await getAddressFromCoordinates(latLng) ?? {};

      String addressEn = address["address_en"];

      String addressAr = address["address_ar"];
      String cityEn = address["city_en"];

      String cityAr = address["city_ar"];

      log(addressEn);
      log(addressAr);
      log(cityEn);
      log(cityAr);

      String userId = await getUserId();
      var headers = {'Cookie': 'PHPSESSID=19g90sr1qvpa8cnqd2f2qgjv9i'};
      var request = http.Request(
        'GET',
        Uri.parse(
          "$baseUrl/order_nopayment.php?input_key=cr3cr3cc3ec3cFEWRCTVR34324c@xcwe3243&input_secret=fmciofnirofmRCCFEDcfr@5342323CFWC&user_id=$userId&level1_id=$leve1&points_discounted=0&date_created=$date_created&address_ar=$addressAr&address_en=$addressEn&lat=$lat&long=$long.4865848&city_ar=$cityAr&city_en=$cityEn&duration=3&price=0",
        ),
      );

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => SucessPage(text: getText("message23")),
          ),
          (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const FailPage()),
          (route) => false,
        );
      }
    } catch (_) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const FailPage()),
        (route) => false,
      );
    }
  }
}
