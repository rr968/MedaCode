// ignore_for_file: file_names, use_build_context_synchronously, curly_braces_in_flow_control_structures

import 'dart:convert';
import 'dart:developer';

import '/controller/language.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/model/user_order.dart';
import '/view/orders/order_checkout.dart';
import 'package:provider/provider.dart';
import '../../controller/no_imternet.dart';
import '../../controller/provider.dart';
import '../../controller/var.dart';

class ReceivedOffers extends StatefulWidget {
  const ReceivedOffers({super.key});

  @override
  State<ReceivedOffers> createState() => _ReceivedOffersState();
}

class _ReceivedOffersState extends State<ReceivedOffers> {
  double price = 0;
  double priceWithoutVat = 0;
  bool isLoading = true;
  List<UserOrder> userOrders = [];

  Map<String, List> catAndSub = {};

  @override
  void initState() {
    getUserOrders();

    super.initState();
  }

  getUserOrders() async {
    userOrders = [];
    String userId = await getUserId();

    var headers = {'Cookie': 'PHPSESSID=pkjgl6qfq25j4hvhl359mma1ej'};
    try {
      log(userId);
      String lan = language == "0" ? "1" : "0";
      var request = http.Request(
        'GET',
        Uri.parse(
          '$baseUrl/my_offers.php?input_key=$input_key&input_secret=$input_secret&user_id=$userId&first_step_status=0&lan=$lan',
        ),
      );

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        Map data = json.decode(await response.stream.bytesToString());

        if (data["status"] != "error") {
          data["data"].forEach((element) {
            List<MainCat> categories = [];
            element["categories"].forEach((key, value) {
              if (!catAndSub.containsKey(key)) {
                catAndSub[key] = [];
              }
              List<SubCat> subs = [];
              value.forEach((subelement) {
                if (!catAndSub[key]!.contains(subelement["sub_categories"])) {
                  catAndSub[key]!.add(subelement["sub_categories"]);
                }

                subs.add(
                  SubCat(
                    isShowAfterFiltered: true,
                    isSelected: false,
                    idx: subelement["idx"].toString(),
                    offer_id: subelement["offer_id"].toString(),
                    user_id: subelement["user_id"].toString(),
                    product_idx: subelement["product_idx"].toString(),
                    quantity: subelement["quantity"].toString(),
                    level1_id: subelement["level1_id"].toString(),
                    level2_id: subelement["level2_id"].toString(),
                    text: subelement["text"].toString(),
                    lat: subelement["lat"].toString(),
                    long: subelement["long"].toString(),

                    city_ar:
                        language == "0"
                            ? subelement["city_en"].toString()
                            : subelement["city_ar"].toString(), //here
                    city_en:
                        language == "0"
                            ? subelement["city_en"].toString()
                            : subelement["city_ar"].toString(), //here
                    address_ar:
                        language == "0"
                            ? subelement["address_en"].toString()
                            : subelement["address_ar"].toString(), //here
                    address_en:
                        language == "0"
                            ? subelement["address_en"].toString()
                            : subelement["address_ar"].toString(), //here
                    date_created: subelement["date_created"].toString(),
                    date_paid: subelement["date_paid"].toString(),
                    duration: subelement["duration"].toString(),
                    status: subelement["status"].toString(),
                    price: subelement["price"].toString(),
                    payment_id: subelement["payment_id"].toString(),
                    address: subelement["address"].toString(),
                    city: subelement["city"].toString(),

                    country: subelement["country"].toString(),

                    expiration_date: subelement["expiration_date"].toString(),
                    expire_after: subelement["expire_after"].toString(),
                    category: subelement["category"].toString(),
                    sub_categories: subelement["sub_categories"].toString(),
                    sub_icon: subelement["sub_icon"].toString(),
                    name: subelement["name"].toString(),
                    description: subelement["description"].toString(),
                    image: subelement["image"].toString(),
                    unit: subelement["unit"].toString(),
                    avg_message: subelement["avg_message"].toString(),
                    total_price_per_product:
                        subelement["total_price_per_product"].toString(),
                    STejari: subelement["STejari"].toString(),
                    p_idx: subelement["p_idx"].toString(),

                    discount_type: subelement["discount_type"].toString(),
                    applied_on: subelement["applied_on"].toString(),
                    original_price: subelement["original_price"].toString(),
                    adjusted_price: subelement["adjusted_price"].toString(),
                    discounted_value: subelement["discounted_value"].toString(),
                    discount_status: subelement["discount_status"].toString(),
                    date_updated: subelement["date_updated"].toString(),
                    item_status: subelement["item_status"].toString(),
                    total_price_per_product_VAT:
                        subelement["total_price_per_product_VAT"].toString(),
                    total_price_per_product_only_VAT:
                        subelement["total_price_per_product_only_VAT"]
                            .toString(),
                    adjusted_price_VAT:
                        subelement["adjusted_price_VAT"].toString(),
                  ),
                );
              });
              categories.add(
                MainCat(catName: key, subCategories: subs, isSelected: false),
              );
            });
            userOrders.add(
              UserOrder(
                STejari: element["STejari"],
                order_code: element["order_code"],
                firm: element["firm"],
                last_updated_date: element["last_updated_date"],
                offer_id: element["offer_id"],
                categories: categories,
              ),
            );
          });
        }

        setState(() {
          isLoading = false;
        });
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const NoInternet()),
          (route) => false,
        );
      }
    } catch (e) {
      log("/////////////$e");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const NoInternet()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:
          isLoading
              ? Center(child: CircularProgressIndicator(color: orange))
              : userOrders.isEmpty
              ? Center(child: Text(getText("message24")))
              : ListView(
                padding: EdgeInsets.zero,
                children: [
                  Container(height: 7),
                  InkWell(
                    onTap: () {
                      List<List> catdata =
                          Provider.of<MyProvider>(
                            context,
                            listen: false,
                          ).getofferCatUserFilter();
                      for (int i = 0; i < catdata.length; i++)
                        if (catdata[i][1] == false) catdata.removeAt(i);

                      Provider.of<MyProvider>(
                        context,
                        listen: false,
                      ).setofferCatUserFilter(catdata);
                      List<List> subdata =
                          Provider.of<MyProvider>(
                            context,
                            listen: false,
                          ).getofferSubCatUserFilter();
                      for (int i = 0; i < subdata.length; i++)
                        if (subdata[i][1] == false) subdata.removeAt(i);

                      Provider.of<MyProvider>(
                        context,
                        listen: false,
                      ).setofferSubCatUserFilter(subdata);
                      _showFilterMenu();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text("Filter", style: TextStyle(fontSize: 11)),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Image.asset(
                            "assets/filter.png",
                            color: Colors.grey,
                            height: 21,
                          ),
                        ),
                      ],
                    ),
                  ),

                  for (int i = 0; i < userOrders.length; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: greyc),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    userOrders[i].firm,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      for (
                                        int t = 0;
                                        t < userOrders[i].categories.length;
                                        t++
                                      ) {
                                        userOrders[i].categories[t].isSelected =
                                            true;
                                        for (
                                          int ts = 0;
                                          ts <
                                              userOrders[i]
                                                  .categories[t]
                                                  .subCategories
                                                  .length;
                                          ts++
                                        ) {
                                          if (userOrders[i]
                                                  .categories[t]
                                                  .subCategories[ts]
                                                  .isSelected ==
                                              false) {
                                            price += double.parse(
                                              userOrders[i]
                                                  .categories[t]
                                                  .subCategories[ts]
                                                  .total_price_per_product_VAT,
                                            );
                                            priceWithoutVat += double.parse(
                                              userOrders[i]
                                                  .categories[t]
                                                  .subCategories[ts]
                                                  .total_price_per_product,
                                            );
                                            Provider.of<MyProvider>(
                                              context,
                                              listen: false,
                                            ).setofferPrice(price.toString());
                                            Provider.of<MyProvider>(
                                              context,
                                              listen: false,
                                            ).setofferPriceWithoutVat(
                                              priceWithoutVat.toString(),
                                            );
                                          }

                                          userOrders[i]
                                              .categories[t]
                                              .subCategories[ts]
                                              .isSelected = true;
                                        }
                                      }
                                      setState(() {});
                                    },
                                    child: Text(
                                      getText("Select All"),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                        color: orange,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      "No#${userOrders[i].offer_id}",
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 11,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 5,
                                      ),
                                      child: Container(
                                        width: .6,
                                        height: 12,
                                        color: greyc,
                                      ),
                                    ),
                                    Text(
                                      userOrders[i].last_updated_date,
                                      style: TextStyle(
                                        color: deepOrange,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              for (
                                int j = 0;
                                j < userOrders[i].categories.length;
                                j++
                              )
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Checkbox(
                                          activeColor: orange,
                                          value:
                                              userOrders[i]
                                                  .categories[j]
                                                  .isSelected,
                                          onChanged: (v) {
                                            for (
                                              int ts = 0;
                                              ts <
                                                  userOrders[i]
                                                      .categories[j]
                                                      .subCategories
                                                      .length;
                                              ts++
                                            ) {
                                              if (userOrders[i]
                                                          .categories[j]
                                                          .subCategories[ts]
                                                          .isSelected ==
                                                      false &&
                                                  v == true) {
                                                price += double.parse(
                                                  userOrders[i]
                                                      .categories[j]
                                                      .subCategories[ts]
                                                      .total_price_per_product_VAT,
                                                );
                                                priceWithoutVat += double.parse(
                                                  userOrders[i]
                                                      .categories[j]
                                                      .subCategories[ts]
                                                      .total_price_per_product,
                                                );
                                              } else if (userOrders[i]
                                                          .categories[j]
                                                          .subCategories[ts]
                                                          .isSelected ==
                                                      true &&
                                                  v == false) {
                                                price -= double.parse(
                                                  userOrders[i]
                                                      .categories[j]
                                                      .subCategories[ts]
                                                      .total_price_per_product_VAT,
                                                );
                                                priceWithoutVat -= double.parse(
                                                  userOrders[i]
                                                      .categories[j]
                                                      .subCategories[ts]
                                                      .total_price_per_product,
                                                );
                                              }
                                              Provider.of<MyProvider>(
                                                context,
                                                listen: false,
                                              ).setofferPrice(price.toString());
                                              Provider.of<MyProvider>(
                                                context,
                                                listen: false,
                                              ).setofferPriceWithoutVat(
                                                priceWithoutVat.toString(),
                                              );
                                              userOrders[i]
                                                  .categories[j]
                                                  .subCategories[ts]
                                                  .isSelected = v ?? false;
                                            }

                                            setState(() {
                                              userOrders[i]
                                                  .categories[j]
                                                  .isSelected = v ?? false;
                                            });
                                          },
                                        ),
                                        Text(
                                          userOrders[i].categories[j].catName,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    for (
                                      int s = 0;
                                      s <
                                          userOrders[i]
                                              .categories[j]
                                              .subCategories
                                              .length;
                                      s++
                                    )
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 7,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Checkbox(
                                              activeColor: orange,
                                              value:
                                                  userOrders[i]
                                                      .categories[j]
                                                      .subCategories[s]
                                                      .isSelected,
                                              onChanged: (v) {
                                                bool falgAll = true;
                                                userOrders[i]
                                                    .categories[j]
                                                    .subCategories[s]
                                                    .isSelected = v ?? false;
                                                if (v == true) {
                                                  price += double.parse(
                                                    userOrders[i]
                                                        .categories[j]
                                                        .subCategories[s]
                                                        .total_price_per_product_VAT,
                                                  );
                                                  priceWithoutVat += double.parse(
                                                    userOrders[i]
                                                        .categories[j]
                                                        .subCategories[s]
                                                        .total_price_per_product,
                                                  );
                                                } else {
                                                  price -= double.parse(
                                                    userOrders[i]
                                                        .categories[j]
                                                        .subCategories[s]
                                                        .total_price_per_product_VAT,
                                                  );
                                                  priceWithoutVat -= double.parse(
                                                    userOrders[i]
                                                        .categories[j]
                                                        .subCategories[s]
                                                        .total_price_per_product,
                                                  );
                                                }
                                                Provider.of<MyProvider>(
                                                  context,
                                                  listen: false,
                                                ).setofferPrice(
                                                  price.toString(),
                                                );
                                                Provider.of<MyProvider>(
                                                  context,
                                                  listen: false,
                                                ).setofferPriceWithoutVat(
                                                  priceWithoutVat.toString(),
                                                );
                                                //here
                                                for (
                                                  int ts = 0;
                                                  ts <
                                                      userOrders[i]
                                                          .categories[j]
                                                          .subCategories
                                                          .length;
                                                  ts++
                                                ) {
                                                  if (userOrders[i]
                                                          .categories[j]
                                                          .subCategories[ts]
                                                          .isSelected ==
                                                      false)
                                                    falgAll = false;
                                                }

                                                if (falgAll) {
                                                  userOrders[i]
                                                      .categories[j]
                                                      .isSelected = true;
                                                } else {
                                                  userOrders[i]
                                                      .categories[j]
                                                      .isSelected = false;
                                                }
                                                //////
                                                setState(() {});
                                              },
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,

                                              children: [
                                                SizedBox(
                                                  width: screenWidth * .4,
                                                  height: 50,
                                                  child: Text(
                                                    userOrders[i]
                                                        .categories[j]
                                                        .subCategories[s]
                                                        .name,
                                                    style: const TextStyle(
                                                      fontSize: 11,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Expanded(child: Container()),
                                            Text(
                                              "${userOrders[i].categories[j].subCategories[s].total_price_per_product_VAT} ${getText("SR")}",
                                              style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    userOrders[i].categories.length != j + 1
                                        ? const Divider()
                                        : Container(),
                                  ],
                                ),
                              Container(height: 3, color: orange),
                              /*  Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 7),
                                  child: Container(
                                    height: 20,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(2),
                                        color: greyc.withOpacity(.6)),
                                    child: const Center(
                                      child: Text(
                                        "Get 10% discount if you select all items from this merchant",
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ),
                                  ),
                                ),*/
                            ],
                          ),
                        ),
                      ),
                    ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              getText("Price"),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              "$priceWithoutVat ${getText("SR")}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: orange,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              getText("VAT"),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              "${price - priceWithoutVat} ${getText("SR")}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: orange,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              getText("TotalPrice"),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              "$price ${getText("SR")}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: orange,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      _approveOffersPopupMenu();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Container(
                        height: 35,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: orange,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            getText("ApproveSelectedOffers"),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
    );
  }

  void _approveOffersPopupMenu() {
    //[userOrderIndex,CatIndex,SubCatIndex,isSelected]
    List<List> selectedOffers = [];
    for (int i = 0; i < userOrders.length; i++)
      for (int j = 0; j < userOrders[i].categories.length; j++) {
        for (
          int k = 0;
          k < userOrders[i].categories[j].subCategories.length;
          k++
        ) {
          //  if (userOrders[i].categories[j].subCategories[k].isSelected) {

          selectedOffers.add([
            i,
            j,
            k,
            userOrders[i].categories[j].subCategories[k].isSelected,
          ]);
        }
      }
    Provider.of<MyProvider>(
      context,
      listen: false,
    ).setselectedOffers(selectedOffers);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Directionality(
          textDirection:
              language == "0" ? TextDirection.ltr : TextDirection.rtl,
          child: SizedBox(
            height:
                MediaQuery.of(context).viewInsets.bottom + screenHeight - 65,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          getText("Summary"),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(height: 10),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: greyc),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    getText("Bills"),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    getText("Select All"),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                      color: orange,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                getText("Selectpay"),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              for (int i = 0; i < selectedOffers.length; i++)
                                Row(
                                  children: [
                                    Checkbox(
                                      activeColor: orange,
                                      value:
                                          Provider.of<MyProvider>(
                                            context,
                                            listen: true,
                                          ).getselectedOffers()[i][3],
                                      onChanged: (v) {
                                        selectedOffers[i][3] = v;
                                        Provider.of<MyProvider>(
                                          context,
                                          listen: false,
                                        ).setselectedOffers(selectedOffers);
                                        if (v == true) {
                                          Provider.of<MyProvider>(
                                            context,
                                            listen: false,
                                          ).setofferPrice(
                                            (double.parse(
                                                      Provider.of<MyProvider>(
                                                        context,
                                                        listen: false,
                                                      ).getofferPrice(),
                                                    ) +
                                                    double.parse(
                                                      userOrders[selectedOffers[i][0]]
                                                          .categories[selectedOffers[i][1]]
                                                          .subCategories[selectedOffers[i][2]]
                                                          .total_price_per_product_VAT,
                                                    ))
                                                .toString(),
                                          );
                                          Provider.of<MyProvider>(
                                            context,
                                            listen: false,
                                          ).setofferPriceWithoutVat(
                                            (double.parse(
                                                      Provider.of<MyProvider>(
                                                        context,
                                                        listen: false,
                                                      ).getofferPriceWithoutVat(),
                                                    ) +
                                                    double.parse(
                                                      userOrders[selectedOffers[i][0]]
                                                          .categories[selectedOffers[i][1]]
                                                          .subCategories[selectedOffers[i][2]]
                                                          .total_price_per_product,
                                                    ))
                                                .toString(),
                                          );
                                        } else {
                                          Provider.of<MyProvider>(
                                            context,
                                            listen: false,
                                          ).setofferPrice(
                                            (double.parse(
                                                      Provider.of<MyProvider>(
                                                        context,
                                                        listen: false,
                                                      ).getofferPrice(),
                                                    ) -
                                                    double.parse(
                                                      userOrders[selectedOffers[i][0]]
                                                          .categories[selectedOffers[i][1]]
                                                          .subCategories[selectedOffers[i][2]]
                                                          .total_price_per_product_VAT,
                                                    ))
                                                .toString(),
                                          );
                                          Provider.of<MyProvider>(
                                            context,
                                            listen: false,
                                          ).setofferPriceWithoutVat(
                                            (double.parse(
                                                      Provider.of<MyProvider>(
                                                        context,
                                                        listen: false,
                                                      ).getofferPriceWithoutVat(),
                                                    ) -
                                                    double.parse(
                                                      userOrders[selectedOffers[i][0]]
                                                          .categories[selectedOffers[i][1]]
                                                          .subCategories[selectedOffers[i][2]]
                                                          .total_price_per_product,
                                                    ))
                                                .toString(),
                                          );
                                        }

                                        setState(() {
                                          price = double.parse(
                                            Provider.of<MyProvider>(
                                              context,
                                              listen: false,
                                            ).getofferPrice(),
                                          );
                                          priceWithoutVat = double.parse(
                                            Provider.of<MyProvider>(
                                              context,
                                              listen: false,
                                            ).getofferPriceWithoutVat(),
                                          );
                                          userOrders[selectedOffers[i][0]]
                                              .categories[selectedOffers[i][1]]
                                              .subCategories[selectedOffers[i][2]]
                                              .isSelected = selectedOffers[i][3];
                                        });
                                      },
                                    ),
                                    Text(
                                      userOrders[selectedOffers[i][0]]
                                          .categories[selectedOffers[i][1]]
                                          .subCategories[selectedOffers[i][2]]
                                          .name,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    Expanded(child: Container()),
                                    Text(
                                      "${userOrders[selectedOffers[i][0]].categories[selectedOffers[i][1]].subCategories[selectedOffers[i][2]].total_price_per_product_VAT} ${getText("SR")}",
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    Container(width: 4),
                                    Icon(
                                      Icons.info_outline,
                                      color: orange,
                                      size: 22,
                                    ),
                                  ],
                                ),
                              Container(height: 3, color: orange),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          getText("Price"),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                        Text(
                                          "${Provider.of<MyProvider>(context, listen: true).getofferPriceWithoutVat()} ${getText("SR")}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: orange,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          getText("VAT"),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                        Text(
                                          "${double.parse(Provider.of<MyProvider>(context, listen: true).getofferPrice()) - double.parse(Provider.of<MyProvider>(context, listen: true).getofferPriceWithoutVat())} ${getText("SR")}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: orange,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          getText("TotalPrice"),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                        Text(
                                          "${Provider.of<MyProvider>(context, listen: true).getofferPrice()} ${getText("SR")}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: orange,
                                            fontSize: 13,
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
                      ),
                      InkWell(
                        onTap: () {
                          if (price <= 0) {
                            Navigator.pop(context);
                            snackBar(
                              context,
                              "you should select at least one item",
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => OrderCheckOut(
                                      userOrders: userOrders,
                                      totalPrice: price,
                                    ),
                              ),
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Container(
                            height: 35,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: orange,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Text(
                                getText("ContinuePayment"),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
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
            ),
          ),
        );
      },
    );
  }

  // ignore: unused_element
  void _showFilterMenu() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Directionality(
          textDirection:
              language == "0" ? TextDirection.ltr : TextDirection.rtl,
          child: SizedBox(
            height: MediaQuery.of(context).viewInsets.bottom + 400,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: SizedBox(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 6, bottom: 10),
                          child: SizedBox(
                            width: double.infinity,
                            child: Row(
                              children: [
                                Text(
                                  getText("Summary"),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(child: Container()),
                                InkWell(
                                  onTap: () {
                                    Provider.of<MyProvider>(
                                      context,
                                      listen: false,
                                    ).setofferCatUserFilter([]);
                                    Provider.of<MyProvider>(
                                      context,
                                      listen: false,
                                    ).setofferSubCatUserFilter([]);

                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "clear filter",
                                    style: TextStyle(
                                      color: orange,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Container(width: 7),
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    size: 21,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Text(
                          getText("MainCategories"),
                          style: const TextStyle(fontSize: 12),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          child: Wrap(
                            spacing:
                                8.0, // Horizontal spacing between containers
                            runSpacing: 8.0,
                            children: [
                              for (var entry in catAndSub.entries)
                                InkWell(
                                  onTap: () {
                                    List<List> catdata =
                                        Provider.of<MyProvider>(
                                          context,
                                          listen: false,
                                        ).getofferCatUserFilter();
                                    if (catdata.any(
                                      (innerList) =>
                                          innerList.contains(entry.key),
                                    )) {
                                      catdata.removeWhere(
                                        (innerList) =>
                                            innerList.contains(entry.key),
                                      );
                                    } else {
                                      catdata.add([entry.key, false]);
                                    }
                                    Provider.of<MyProvider>(
                                      context,
                                      listen: false,
                                    ).setofferCatUserFilter(catdata);
                                  },
                                  child: Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color:
                                          Provider.of<MyProvider>(
                                                context,
                                                listen: true,
                                              ).getofferCatUserFilter().any(
                                                (innerList) => innerList
                                                    .contains(entry.key),
                                              )
                                              ? orange
                                              : Colors.white,
                                      border: Border.all(color: greyc),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6),
                                      child: Text(
                                        entry.key,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color:
                                              Provider.of<MyProvider>(
                                                    context,
                                                    listen: true,
                                                  ).getofferCatUserFilter().any(
                                                    (innerList) => innerList
                                                        .contains(entry.key),
                                                  )
                                                  ? Colors.white
                                                  : Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const Divider(),
                        const Text(
                          "Sub categories",
                          style: TextStyle(fontSize: 12),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          child: Wrap(
                            spacing:
                                8.0, // Horizontal spacing between containers
                            runSpacing: 8.0,
                            children: [
                              for (var entry in catAndSub.entries)
                                for (var subs in entry.value)
                                  InkWell(
                                    onTap: () {
                                      List<List> subdata =
                                          Provider.of<MyProvider>(
                                            context,
                                            listen: false,
                                          ).getofferSubCatUserFilter();
                                      if (subdata.any(
                                        (innerList) => innerList.contains(subs),
                                      )) {
                                        subdata.removeWhere(
                                          (innerList) =>
                                              innerList.contains(subs),
                                        );
                                      } else {
                                        subdata.add([subs, false]);
                                      }
                                      Provider.of<MyProvider>(
                                        context,
                                        listen: false,
                                      ).setofferSubCatUserFilter(subdata);
                                    },
                                    child: Container(
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color:
                                            Provider.of<MyProvider>(
                                                      context,
                                                      listen: true,
                                                    )
                                                    .getofferSubCatUserFilter()
                                                    .any(
                                                      (innerList) => innerList
                                                          .contains(subs),
                                                    )
                                                ? orange
                                                : Colors.white,
                                        border: Border.all(color: greyc),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(6),
                                        child: Text(
                                          subs,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color:
                                                Provider.of<MyProvider>(
                                                          context,
                                                          listen: true,
                                                        )
                                                        .getofferSubCatUserFilter()
                                                        .any(
                                                          (innerList) =>
                                                              innerList
                                                                  .contains(
                                                                    subs,
                                                                  ),
                                                        )
                                                    ? Colors.white
                                                    : Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            List<List> catdata =
                                Provider.of<MyProvider>(
                                  context,
                                  listen: false,
                                ).getofferCatUserFilter();

                            List<List> subdata =
                                Provider.of<MyProvider>(
                                  context,
                                  listen: false,
                                ).getofferCatUserFilter();

                            for (List innerList in catdata) {
                              innerList[1] = true;
                            }
                            for (List innerList in subdata) {
                              innerList[1] = true;
                            }
                            Provider.of<MyProvider>(
                              context,
                              listen: false,
                            ).setofferCatUserFilter(catdata);
                            Provider.of<MyProvider>(
                              context,
                              listen: false,
                            ).setofferSubCatUserFilter(subdata);
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Container(
                              height: 35,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: orange,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Center(
                                child: Text(
                                  "Show result",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
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
              ),
            ),
          ),
        );
      },
    );
  }
}
