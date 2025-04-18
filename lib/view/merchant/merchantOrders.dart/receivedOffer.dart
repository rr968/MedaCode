// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import '/controller/language.dart';
import 'package:flutter/material.dart';
import '/controller/var.dart';
import '/model/merchant_order.dart';
import '/view/merchant/merchantOrders.dart/orderdetails.dart';
import 'package:http/http.dart' as http;
import '../../../controller/no_imternet.dart';
import '../../../model/merchant_ordars.dart';

class ReceivedOfferMerchantSide extends StatefulWidget {
  const ReceivedOfferMerchantSide({super.key});

  @override
  State<ReceivedOfferMerchantSide> createState() =>
      _ReceivedOfferMerchantSideState();
}

class _ReceivedOfferMerchantSideState extends State<ReceivedOfferMerchantSide> {
  bool isLoading = false;
  String? cityValue;

  @override
  void initState() {
    if (citiesMerchantFilter.isNotEmpty) {
      cityValue = citiesMerchantFilter[0];
      log("cityValue$cityValue");
      getRecievedOffers(cityValue ?? "");
    }
    super.initState();
  }

  getRecievedOffers(String city) async {
    setState(() {
      isLoading = true;
    });
    merchantOrders = [];

    var headers = {'Cookie': 'PHPSESSID=pkjgl6qfq25j4hvhl359mma1ej'};
    try {
      String lan = language == "0" ? "1" : "0";

      var request = http.Request(
          'GET',
          Uri.parse(
              '$baseUrl/available_orders.php?input_key=$input_key&input_secret=$input_secret&en_ar=$lan&data_level=1&pick_city=$city&STejari=$sTejariValue'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        Map data = {};
        try {
          String a = await response.stream.bytesToString();
          log("here////////$a");
          data = json.decode(a);
        } catch (e) {
          data["status"] = "error";
        }

        log("/////////////");
        log("here 2$data");
        try {
          if (data["status"] == "error") {
            snackBar(context, "error while decode the response");
          } else {
            if (data["data"] != "There are no orders") {
              data["data"].forEach((element) {
                List<MerchantOrderClass> merchantOrds = [];
                element["orders"].forEach((e) {
                  merchantOrds.add(MerchantOrderClass(
                    user_id: e["user_id"].toString(),
                    offer_id: e["offer_id"].toString(),
                    item_status: e["item_status"].toString(),
                    product_idx: e["product_idx"].toString(),
                    quantity: e["quantity"].toString(),
                    level1_id: e["level1_id"].toString(),
                    level2_id: e["level2_id"].toString(),
                    text: e["text"].toString(),
                    lat: e["lat"].toString(),
                    long: e["long"].toString(),
                    city_ar: e["city_ar"].toString(),
                    city_en: e["city_en"].toString(),
                    address: e["address"].toString(),
                    date_created: e["date_created"].toString(),
                    date_paid: e["date_paid"].toString(),
                    duration: e["duration"].toString(),
                    status: e["status"].toString(),
                    price: e["price"].toString().toString(),
                    payment_id: e["payment_id"].toString(),
                    country: e["country"].toString(),
                    expiration_date: e["expiration_date"].toString(),
                    expire_after: e["expire_after"].toString(),
                    category: e["category"].toString(),
                    sub_categories: e["sub_categories"].toString(),
                    sub_icon: e["sub_icon"].toString(),
                    name: e["name"].toString(),
                    description: e["description"].toString(),
                    image: e["image"].toString(),
                    unit: e["unit"].toString(),
                    avg_message: e["avg_message"].toString(),
                    total_price_per_product:
                        e["total_price_per_product"].toString(),
                    total_price_per_product_VAT:
                        e["total_price_per_product_VAT"].toString(),
                    total_price_per_product_only_VAT:
                        e["total_price_per_product_only_VAT"].toString(),
                    adjusted_price_VAT: e["adjusted_price_VAT"].toString(),
                    discount_type: e["discount_type"].toString(),
                    applied_on: e["applied_on"].toString(),
                    original_price: e["original_price"].toString(),
                    adjusted_price: e["adjusted_price"].toString(),
                    discounted_value: e["discounted_value"].toString(),
                    discount_status: e["discount_status"].toString(),
                  ));
                });

                merchantOrders.add(MerchantOrdersClass(
                    user_id: element["user_id"].toString(),
                    order_code: element["order_code"].toString(),
                    orders: merchantOrds,
                    expire_after: element["expire_after"],
                    summedup_prices_before_discount:
                        element["expire_summedup_prices_before_discountafter"]
                            .toString(),
                    summed_adjusted_prices_after_discount:
                        element["summed_adjusted_prices_after_discount"]
                            .toString(),
                    summed_adjusted_prices_after_discount_VAT:
                        element["summed_adjusted_prices_after_discount_VAT"]
                            .toString(),
                    Total_saves: element["Total_saves"].toString()));
              });
            }
          }
        } catch (e) {
          log(e.toString());
        }
        setState(() {
          isLoading = false;
        });
      } else {
        snackBar(context, "ERROR please try again");
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const NoInternet()),
            (route) => false);
      }
    } catch (e) {
      log(e.toString());
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const NoInternet()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenHeight - 175,
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: orange,
              ),
            )
          : cityValue == null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Text(getText("message24")),
                  ),
                )
              : merchantOrders.isEmpty
                  ? ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Center(
                            child: SizedBox(
                              width: screenWidth,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    getText("SelectCity"),
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    width: 15,
                                  ),
                                  SizedBox(
                                    width: 140,
                                    child: DropdownButton<String>(
                                      dropdownColor: Colors.white,
                                      isExpanded: true,
                                      isDense: true,
                                      hint: Text(getText("SelectCity")),
                                      value: cityValue,
                                      borderRadius: BorderRadius.circular(5),
                                      onChanged: (String? newValue) {
                                        cityValue = newValue;
                                        getRecievedOffers(cityValue!);
                                      },
                                      items: citiesMerchantFilter
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Row(
                                            children: [
                                              cityValue == value
                                                  ? const Icon(
                                                      Icons.location_city,
                                                      size: 22,
                                                    )
                                                  : Container(
                                                      width: 20,
                                                    ),
                                              Container(
                                                width: 5,
                                              ),
                                              Expanded(
                                                  child: Text(
                                                value,
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              )),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 100),
                            child: Text(getText("message24")),
                          ),
                        ),
                      ],
                    )
                  : ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Center(
                            child: SizedBox(
                              width: screenWidth,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    getText("SelectCity"),
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    width: 15,
                                  ),
                                  SizedBox(
                                    width: 140,
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      isDense: true,
                                      hint: const Text('City'),
                                      value: cityValue,
                                      borderRadius: BorderRadius.circular(5),
                                      onChanged: (String? newValue) {
                                        cityValue = newValue;
                                        getRecievedOffers(cityValue!);
                                      },
                                      items: citiesMerchantFilter
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Row(
                                            children: [
                                              cityValue == value
                                                  ? const Icon(
                                                      Icons.location_city,
                                                      size: 22,
                                                    )
                                                  : Container(
                                                      width: 20,
                                                    ),
                                              Container(
                                                width: 5,
                                              ),
                                              Expanded(
                                                  child: Text(
                                                value,
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              )),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        for (int i = 0; i < merchantOrders.length; i++)
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 4),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => OrderDetails(
                                                orderIndex: i,
                                                cityValue:
                                                    cityValue ?? "Riyadh",
                                              )));
                                },
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          "assets/clipboard-list.png",
                                          height: 20,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${getText("OrderNo")} ${merchantOrders[i].order_code}",
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 11),
                                              ),
                                              Text(
                                                "${merchantOrders[i].orders[0].country}|${merchantOrders[i].orders[0].city_en}",
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 11),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(child: Container()),
                                        Row(
                                          children: [
                                            Text(
                                              merchantOrders[i].orders.length ==
                                                      1
                                                  ? "1 ${getText("Item")}"
                                                  : "${merchantOrders[i].orders.length} ${getText("Items")}",
                                              style: TextStyle(
                                                  color: orange,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 11),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: Image.asset(
                                                "assets/icon3.png",
                                                height: 20,
                                              ),
                                            ),
                                            const Icon(Icons.arrow_forward_ios,
                                                size: 18, color: Colors.grey)
                                          ],
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                          width: screenWidth - 110,
                                          height: 25,
                                          decoration: BoxDecoration(
                                              color: orange.withOpacity(.07),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Center(
                                            child: Text(
                                              merchantOrders[i].expire_after,
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: orange,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Align(
                                            alignment: Alignment.centerRight,
                                            child: SizedBox(
                                                width: screenWidth - 110,
                                                child: Divider(
                                                  thickness: .6,
                                                  color: greyc,
                                                ))))
                                  ],
                                ),
                              ))
                      ],
                    ),
    );
  }
}
