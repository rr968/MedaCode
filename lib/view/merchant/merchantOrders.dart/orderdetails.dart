// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../controller/language.dart';
import '../../notification/notifications.dart';
import '/controller/no_imternet.dart';
import '/view/merchant/merchantOrders.dart/submit_order.dart';
import '../../../controller/textstyle.dart';
import '../../../controller/var.dart';

class OrderDetails extends StatefulWidget {
  final int orderIndex;
  final String cityValue;
  const OrderDetails(
      {super.key, required this.orderIndex, required this.cityValue});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Directionality(
      textDirection: language == "0" ? TextDirection.ltr : TextDirection.rtl,
      child: Stack(children: [
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
                  padding: const EdgeInsets.only(left: 12, right: 12, top: 10),
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
                          size: 22,
                        ),
                      ),
                      Text(
                        getText("Orderdetails"),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const NotificationPage()));
                            },
                            child: Stack(
                              children: [
                                Image.asset(
                                  "assets/bell.png",
                                  height: 22,
                                ),
                                unSeenNotiNum == 0
                                    ? Container()
                                    : Container(
                                        height: 14,
                                        width: 14,
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        child: Center(
                                          child: Text(
                                            unSeenNotiNum.toString(),
                                            style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.white),
                                          ),
                                        ),
                                      )
                              ],
                            ),
                          ),
                        ),
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
            width: screenWidth,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(25)),
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 22),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Text(
                    "${getText("OrderNo")} ${merchantOrders[widget.orderIndex].order_code}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        width: screenWidth,
                        height: 25,
                        decoration: BoxDecoration(
                            color: orange.withOpacity(.07),
                            borderRadius: BorderRadius.circular(5)),
                        child: Center(
                          child: Text(
                            merchantOrders[widget.orderIndex].expire_after,
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
                    padding: const EdgeInsets.only(top: 10, bottom: 17),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: greyc),
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        children: [
                          for (int i = 0;
                              i <
                                  merchantOrders[widget.orderIndex]
                                      .orders
                                      .length;
                              i++)
                            InkWell(
                              onTap: () {
                                _showItemDetailsPopupMenu(i);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, right: 8, top: 6),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      merchantOrders[widget.orderIndex]
                                          .orders[i]
                                          .category,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11),
                                    ),
                                    Container(
                                      height: 16,
                                    ),
                                    Text(
                                      merchantOrders[widget.orderIndex]
                                          .orders[i]
                                          .sub_categories,
                                      style: const TextStyle(
                                        fontSize: 11,
                                      ),
                                    ),
                                    Container(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          width: screenWidth / 3.6,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                merchantOrders[
                                                        widget.orderIndex]
                                                    .orders[i]
                                                    .product_idx,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 11),
                                              ),
                                              Text(
                                                merchantOrders[
                                                        widget.orderIndex]
                                                    .orders[i]
                                                    .name,
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 11),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: screenWidth / 3.6,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Text("   "),
                                              Text(
                                                "${merchantOrders[widget.orderIndex].orders[i].quantity} ${merchantOrders[widget.orderIndex].orders[i].unit}",
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 11),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: screenWidth / 3.6,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                getText("UnitPrice"),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: orange,
                                                    fontSize: 11),
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  merchantOrders[widget
                                                                  .orderIndex]
                                                              .orders[i]
                                                              .applied_on ==
                                                          "0"
                                                      ? Container()
                                                      : Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              "${merchantOrders[widget.orderIndex].orders[i].original_price} ${getText("SR")}",
                                                              style: const TextStyle(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .lineThrough,
                                                                  fontSize: 11,
                                                                  color: Colors
                                                                      .red),
                                                            ),
                                                            Container(
                                                              width: 3,
                                                            ),
                                                            Text(
                                                              "-${merchantOrders[widget.orderIndex].orders[i].discounted_value}",
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 11),
                                                            ),
                                                          ],
                                                        ),
                                                  Text(
                                                    "${merchantOrders[widget.orderIndex].orders[i].adjusted_price} ${getText("SR")}",
                                                    style: TextStyle(
                                                        color: merchantOrders[widget
                                                                        .orderIndex]
                                                                    .orders[i]
                                                                    .applied_on ==
                                                                "0"
                                                            ? const Color
                                                                .fromARGB(255,
                                                                100, 100, 100)
                                                            : Colors.green,
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    "+ ${(double.parse(merchantOrders[widget.orderIndex].orders[i].adjusted_price_VAT) - double.parse(merchantOrders[widget.orderIndex].orders[i].adjusted_price)).toStringAsFixed(2)} ${getText("VAT")}",
                                                    style: const TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    merchantOrders[widget.orderIndex]
                                                .orders[i]
                                                .discounted_value ==
                                            "0"
                                        ? Container()
                                        : Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Container(
                                                width: screenWidth,
                                                height: 25,
                                                decoration: BoxDecoration(
                                                    color:
                                                        orange.withOpacity(.07),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: Center(
                                                  child: Text(
                                                    "${merchantOrders[widget.orderIndex].orders[i].total_price_per_product_VAT} with ${merchantOrders[widget.orderIndex].orders[i].discounted_value} discount",
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color: orange,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                    i !=
                                            merchantOrders[widget.orderIndex]
                                                    .orders
                                                    .length -
                                                1
                                        ? Divider(
                                            color: greyc,
                                          )
                                        : Container(
                                            height: 10,
                                          )
                                  ],
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SubmitOrder(
                                    orderIndex: widget.orderIndex,
                                    city: widget.cityValue,
                                  )));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Container(
                        height: 35,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: orange,
                            borderRadius: BorderRadius.circular(5)),
                        child: Center(
                          child: Text(
                            getText("Continue"),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ]),
    ));
  }

  void _showItemDetailsPopupMenu(int itemIndex) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Directionality(
          textDirection:
              language == "0" ? TextDirection.ltr : TextDirection.rtl,
          child: Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                  height: MediaQuery.of(context).viewInsets.bottom + 520,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 6),
                        child: Text(
                          "Item details",
                          style: TextStyle(
                              fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 15,
                          bottom: 15,
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: screenWidth,
                            height: 30,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: orange.withOpacity(.2)),
                                color: orange.withOpacity(.07),
                                borderRadius: BorderRadius.circular(4)),
                            child: Center(
                              child: Text(
                                "Price is lower than market price",
                                style: TextStyle(color: orange, fontSize: 11),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Item name",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 11),
                            ),
                            SizedBox(
                              height: 40,
                              width: screenWidth * .5,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  merchantOrders[widget.orderIndex]
                                      .orders[itemIndex]
                                      .name,
                                  style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: greyc,
                      )
                      //Eum et omnis dolore vero quod dolore temporibus temporibus quisquam. Nemo enim maiores nih
                      ,
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Size",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 11),
                            ),
                            SizedBox(
                                height: 40,
                                width: screenWidth * .5,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "${merchantOrders[widget.orderIndex].orders[itemIndex].quantity} ${merchantOrders[widget.orderIndex].orders[itemIndex].unit}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 11),
                                  ),
                                ))
                          ],
                        ),
                      ),
                      Divider(
                        color: greyc,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              getText("Location"),
                              style: const TextStyle(
                                  color: Colors.black54, fontSize: 11),
                            ),
                            InkWell(
                              onTap: () async {
                                showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (BuildContext context) {
                                      double lat = 0;
                                      double long = 0;
                                      try {
                                        lat = double.parse(
                                            merchantOrders[widget.orderIndex]
                                                .orders[itemIndex]
                                                .lat);
                                        long = double.parse(
                                            merchantOrders[widget.orderIndex]
                                                .orders[itemIndex]
                                                .long);
                                      } catch (e) {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const NoInternet()),
                                            (route) => false);
                                      }
                                      return Directionality(
                                        textDirection: language == "0"
                                            ? TextDirection.ltr
                                            : TextDirection.rtl,
                                        child: SizedBox(
                                            height: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom +
                                                460,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 6,
                                                          top: 17,
                                                          left: 12,
                                                          right: 12),
                                                  child: Text(
                                                    getText("Location"),
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 8.0,
                                                          left: 12,
                                                          right: 12),
                                                  child: Text(
                                                    merchantOrders[
                                                            widget.orderIndex]
                                                        .orders[itemIndex]
                                                        .address,
                                                    style: const TextStyle(
                                                        color: Colors.black54,
                                                        fontSize: 11),
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: 380,
                                                    child: FlutterMap(
                                                        options: MapOptions(
                                                            initialZoom: 15,
                                                            initialCenter:
                                                                LatLng(
                                                                    lat, long)),
                                                        children: [
                                                          TileLayer(
                                                            urlTemplate:
                                                                "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                                            subdomains: const [
                                                              'a',
                                                              'b',
                                                              'c'
                                                            ],
                                                          ),
                                                          MarkerLayer(
                                                            markers: [
                                                              Marker(
                                                                width: 80.0,
                                                                height: 80.0,
                                                                point: LatLng(
                                                                    lat, long),
                                                                child: Icon(
                                                                  Icons
                                                                      .location_on,
                                                                  color: orange,
                                                                  size: 40.0,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ])),
                                              ],
                                            )),
                                      );
                                    });
                              },
                              child: SizedBox(
                                height: 40,
                                width: screenWidth * .5,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    merchantOrders[widget.orderIndex]
                                        .orders[itemIndex]
                                        .address,
                                    style: const TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 11),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: greyc,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Description",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 11),
                            ),
                            SizedBox(
                              height: 40,
                              width: screenWidth * .5,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  merchantOrders[widget.orderIndex]
                                      .orders[itemIndex]
                                      .description,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 11),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: greyc,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "User Description",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 11),
                            ),
                            SizedBox(
                              height: 40,
                              width: screenWidth * .5,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  merchantOrders[widget.orderIndex]
                                      .orders[itemIndex]
                                      .text,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 11),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: greyc,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              getText("UnitPrice"),
                              style: const TextStyle(
                                  color: Colors.black54, fontSize: 11),
                            ),
                            SizedBox(
                                height: 40,
                                width: screenWidth * .5,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      merchantOrders[widget.orderIndex]
                                                  .orders[itemIndex]
                                                  .adjusted_price !=
                                              merchantOrders[widget.orderIndex]
                                                  .orders[itemIndex]
                                                  .original_price
                                          ? Text(
                                              "${merchantOrders[widget.orderIndex].orders[itemIndex].original_price} ",
                                              style: const TextStyle(
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                  color: Colors.red,
                                                  fontSize: 11),
                                            )
                                          : Container(),
                                      Text(
                                        " ${merchantOrders[widget.orderIndex].orders[itemIndex].adjusted_price_VAT}",
                                        style: const TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11),
                                      ),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                      Divider(
                        color: greyc,
                      )
                    ],
                  ))),
        );
      },
    );
  }
}
