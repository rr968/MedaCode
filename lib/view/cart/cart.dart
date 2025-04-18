// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import '/controller/language.dart';
import '/view/mainpage.dart';
import 'package:flutter/material.dart';
import '/controller/no_imternet.dart';
import '/controller/var.dart';
import '/model/cart_item.dart';
import '/view/checkout/checkout.dart';
import '/view/splashscreen/splashscreen.dart';
import 'package:http/http.dart' as http;

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<CartItem> cartItems = [];

  bool isLoading = true;
  @override
  void initState() {
    gatCartItems().then((value) {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  Future gatCartItems() async {
    String userId = await getUserId();
    var request = http.Request(
      'GET',
      Uri.parse(
        '$baseUrl/cart_content.php?input_key=$input_key&input_secret=$input_secret&userId=$userId&func_required=0',
      ),
    );

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var data = json.decode(await response.stream.bytesToString());

      if (data is List) {
        for (var element in data) {
          cartItems.add(
            CartItem(
              language == "1" ? element["Category_AR"] : element["Category_EN"],
              language == "1"
                  ? element["sub_category_AR"]
                  : element["sub_category_EN"],
              element["product_idx"],
              language == "1" ? element["product_AR"] : element["product_EN"],
              element["image"],
              language == "1"
                  ? element["description_AR"]
                  : element["description_EN"],
              element["quantity"],
              language == "1" ? element["unit_ar"] : element["unit"],
              element["text"],
              element["level1_id"],
              element["level2_id"],
            ),
          );
        }
      }
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const NoInternet()),
        (route) => false,
      );
    }
  }

  Future deleteOneCartItem(int elementIndex) async {
    String userId = await getUserId();
    String delete1element = cartItems[elementIndex].level2Id;
    var request = http.Request(
      'GET',
      Uri.parse(
        '$baseUrl/cart_content.php?input_key=$input_key&input_secret=$input_secret&userId=$userId&func_required=1&delete1element=$delete1element',
      ),
    );

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      // var data = json.decode(await response.stream.bytesToString());

      setState(() {
        cartItems.removeAt(elementIndex);
      });
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const NoInternet()),
        (route) => false,
      );
    }
  }

  Future deleteCartItems() async {
    String userId = await getUserId();
    var request = http.Request(
      'GET',
      Uri.parse(
        '$baseUrl/cart_content.php?input_key=$input_key&input_secret=$input_secret&userId=$userId&func_required=2',
      ),
    );

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Cart()),
      );
    } else {
      snackBar(context, "تحقق من اتصالك بالانترنت");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: language == "0" ? TextDirection.ltr : TextDirection.rtl,
        child: SafeArea(
          child:
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const MainPage(),
                                  ),
                                  (route) => false,
                                );
                              },
                              child: const Icon(Icons.arrow_back_ios, size: 22),
                            ),
                            Text(
                              getText("Cart"),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Container(width: 25),
                          ],
                        ),
                      ),
                      const Divider(),
                      Expanded(
                        child:
                            cartItems.isEmpty
                                ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/shopping-cart-times.png",
                                      height: 55,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 10,
                                        top: 20,
                                      ),
                                      child: Text(
                                        getText("message33"),
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 30,
                                      ),
                                      child: Text(
                                        getText("message36"),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    ),
                                  ],
                                )
                                : ListView(
                                  children: [
                                    for (int i = 0; i < cartItems.length; i++)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 11,
                                          vertical: 9,
                                        ),
                                        child: Dismissible(
                                          background: Container(
                                            color: Colors.red,
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  15,
                                                ),
                                                child: Image.asset(
                                                  "assets/trash.png",
                                                  color: Colors.white,
                                                  height: 24,
                                                ),
                                              ),
                                            ),
                                          ),
                                          key: ValueKey(cartItems[i]),
                                          onDismissed: (DismissDirection d) {
                                            deleteOneCartItem(i);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: const Color.fromARGB(
                                                  255,
                                                  201,
                                                  201,
                                                  201,
                                                ),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                    6,
                                                  ),
                                                  child: Container(
                                                    height: 55,
                                                    width: 55,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                          cartItems[i]
                                                              .productImage,
                                                        ),
                                                      ),
                                                      border: Border.all(
                                                        color:
                                                            const Color.fromARGB(
                                                              255,
                                                              217,
                                                              217,
                                                              217,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          cartItems[i]
                                                              .productName,
                                                          style:
                                                              const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 14,
                                                              ),
                                                        ),
                                                        Container(
                                                          height: 80,
                                                          child: Text(
                                                            cartItems[i]
                                                                .description,
                                                            style:
                                                                const TextStyle(
                                                                  fontSize: 11,
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 45,
                                                  width: 1.5,
                                                  color: const Color.fromARGB(
                                                    255,
                                                    201,
                                                    201,
                                                    201,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                    10,
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        getText("Quantity"),
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        "${cartItems[i].quentity} ${cartItems[i].unit}",
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                      ),
                      Container(height: 10),
                      cartItems.isEmpty
                          ? Container()
                          : InkWell(
                            onTap: () async {
                              Map address =
                                  await getAddressFromCoordinates(latLng) ?? {};
                              log(address.toString());
                              log(latLng!.latitude.toString());
                              log(latLng!.longitude.toString());
                              String add =
                                  address == {}
                                      ? ""
                                      : language == "0"
                                      ? address["address_en"]
                                      : address["address_ar"];
                              log(
                                "///////////////address from coordinates/////////////",
                              );
                              log(add);
                              if (add != "" && latLng != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => CheckOut(
                                          level1Id: cartItems[0].level1Id,
                                          addressName: add,
                                        ),
                                  ),
                                );
                              } else {
                                snackBar(context, getText("message37"));
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 20,
                              ),
                              child: Container(
                                height: 35,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: orange,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text(
                                    getText("Continue"),
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
                      cartItems.isEmpty
                          ? Container()
                          : InkWell(
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SplashScreen(),
                                ),
                                (route) => false,
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 20,
                              ),
                              child: InkWell(
                                onTap: () {
                                  deleteCartItems();
                                },
                                child: Container(
                                  height: 35,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    //color: Colors.white,
                                    border: Border.all(color: orange),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: Text(
                                      getText("DeleteAll"),
                                      style: TextStyle(
                                        color: orange,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      Container(height: 10),
                    ],
                  ),
        ),
      ),
    );
  }
}
