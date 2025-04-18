import 'dart:convert';
import 'dart:developer' as p;
import 'dart:io';
import 'dart:math';

import '/controller/language.dart';
import '/model/ticket.dart';
import '/view/support/support_chat.dart';
import 'package:flutter/material.dart';

import '../../controller/no_imternet.dart';
import 'package:http/http.dart' as http;

import '../../controller/textstyle.dart';
import '../../controller/var.dart';
import '../notification/notifications.dart';

class SupportItems extends StatefulWidget {
  String typeName;
  String ticketType;
  SupportItems({super.key, required this.typeName, required this.ticketType});

  @override
  State<SupportItems> createState() => _SupportItemsState();
}

class _SupportItemsState extends State<SupportItems> {
  bool isLoading = true;
  List<TicketClass> data = [];
  @override
  void initState() {
    getItems();
    super.initState();
  }

  getItems() async {
    String userId = await getUserId(); //for test 9711740509
    String senderType = isUserNow ? "0" : "1";
    var headers = {'Cookie': 'PHPSESSID=1ljp80udb4p4rbib2mgqomsue8'};
    var request = http.Request(
        'GET',
        Uri.parse(
            '$baseUrl/support_chat.php?input_key=$input_key&input_secret=$input_secret&sender_type=$senderType&sender=$senderType&id=$userId&scenario=1'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      try {
        Map d = json.decode(await response.stream.bytesToString());
        if (!d.containsKey("message")) {
          d = d[widget.typeName];
          if (d["count"] != 0) {
            Map ticketsMap = d["tickets"];
            ticketsMap.forEach((key, value) {
              data.add(TicketClass(
                offerId: value["offer_id"].toString(),
                title: value["title"].toString(),
                sender: value["sender"].toString(),
                id: value["id"].toString(),
                dateOpen: value["date_open"].toString(),
                dateClosed: value["date_closed"].toString(),
                ticketType: value["ticket_type"].toString(),
                status: value["status"].toString(),
              ));
            });
          }
        }

        setState(() {
          isLoading = false;
        });
      } catch (_) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const NoInternet()),
            (route) => false);
      }
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const NoInternet()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Directionality(
          textDirection:
              language == "0" ? TextDirection.ltr : TextDirection.rtl,
          child: Stack(children: [
            Container(
              height: Platform.isIOS ? 90 : 85,
              decoration: BoxDecoration(
                gradient: gradient,
              ),
              child: Stack(
                children: [
                  Container(
                    width: 150,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/Logo Shape.png"),
                            fit: BoxFit.cover)),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 22,
                          ),
                          Text(
                            getText("Support"),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
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
                padding: EdgeInsets.only(top: Platform.isIOS ? 90 : 69),
                child: Container(
                    height: screenHeight,
                    width: screenWidth,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: orange,
                                ),
                              )
                            : Column(children: [
                                Container(
                                  height: 15,
                                ),
                                InkWell(
                                  onTap: () {
                                    showCreateTicketDialog(context);
                                  },
                                  child: Column(
                                    children: [
                                      Icon(Icons.add_circle_outline,
                                          color: orange),
                                      Text(
                                        getText("CreateTicket"),
                                        style: TextStyle(
                                            color: orange,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Divider(),
                                ),
                                Expanded(
                                  child: ListView(
                                    children: [
                                      for (int i = 0; i < data.length; i++)
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SupportChat(
                                                          offerId:
                                                              data[i].offerId,
                                                          ticket_type:
                                                              widget.typeName
                                                          /* widget.tabel == "0"
                                                              ? "1"
                                                              : "2"*/
                                                          ,
                                                          ticket_title:
                                                              "Support",
                                                        )));
                                          },
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            data[i].title,
                                                            style: const TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Text(
                                                            "#${data[i].offerId}",
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        11,
                                                                    color: Colors
                                                                        .grey),
                                                          ),
                                                          Text(
                                                            "${getText("opened")}: ${data[i].dateOpen}",
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        11,
                                                                    color: Colors
                                                                        .grey),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                        child: Container()),
                                                    Icon(
                                                      Icons.arrow_back_ios_new,
                                                      size: 18,
                                                      textDirection: language ==
                                                              "0"
                                                          ? TextDirection.rtl
                                                          : TextDirection.ltr,
                                                      color: Colors.grey,
                                                    )
                                                  ],
                                                ),
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                    left: 20,
                                                    top: 9,
                                                    bottom: 9),
                                                child: Divider(),
                                              )
                                            ],
                                          ),
                                        )
                                    ],
                                  ),
                                )
                              ]))))
          ]),
        ));
  }

  void showCreateTicketDialog(BuildContext context) {
    TextEditingController titleController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection:
              language == "0" ? TextDirection.ltr : TextDirection.rtl,
          child: AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: Text(
              getText("CreateChat"),
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            content: Container(
              height: 40, // Adjust the height
              decoration: BoxDecoration(
                border: Border.all(color: orange, width: 2), // Orange border
                borderRadius: BorderRadius.circular(8), // Rounded corners
              ),
              padding: const EdgeInsets.symmetric(
                  horizontal: 10), // Add padding inside the field
              child: TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: getText("Title"),
                  border: InputBorder.none, // Remove default border
                  contentPadding: const EdgeInsets.only(
                      bottom: 10), // Adjust text alignment
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(getText("Cancel"), style: TextStyle(color: orange)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: orange,
                ),
                onPressed: () {
                  String title = titleController.text.trim();
                  if (title.isNotEmpty) {
                    String randomNum = widget.typeName.replaceFirst("ids",
                        (Random().nextInt(90000000) + 10000000).toString());
                    p.log("randomNum: $randomNum");
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SupportChat(
                                  offerId: randomNum,
                                  ticket_type: widget.ticketType,
                                  ticket_title: title,
                                )));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Please enter title"),
                      duration: Duration(seconds: 2),
                    ));
                  }
                },
                child: Text(
                  getText("Add"),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
