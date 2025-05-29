// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, must_be_immutable

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '/controller/var.dart';
import '/model/my_chats.dart';
import '/view/chat/chat_page.dart';
import '/view/mainpage.dart';
import '/view/merchant/mainMerchentPage.dart';
import '../../controller/language.dart';
import '../../controller/no_imternet.dart';
import '../../controller/textstyle.dart';
import '../notification/notifications.dart';

class MyChats extends StatefulWidget {
  bool isUser;
  bool openLastChat;

  MyChats({super.key, required this.isUser, required this.openLastChat});

  @override
  State<MyChats> createState() => _MyChatsState();
}

class _MyChatsState extends State<MyChats> {
  List<Chats> myChats = [];
  bool isLoading = true;
  @override
  void initState() {
    getChats();
    super.initState();
  }

  getChats() async {
    String userId = await getUserId();
    var headers = {'Cookie': 'PHPSESSID=1ljp80udb4p4rbib2mgqomsue8'};
    String url =
        widget.isUser
            ? '$baseUrl/chat.php?input_key=$input_key&input_secret=$input_secret&user_id=$userId&msg_action=5&status=0'
            : '$baseUrl/chat.php?input_key=$input_key&input_secret=$input_secret&STejari=$sTejariValue&msg_action=5&status=0';
    var request = http.Request('GET', Uri.parse(url));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      Map data = json.decode(await response.stream.bytesToString());
      log(data.toString());
      if (data["status"] == "success") {
        data["data"].forEach((element) {
          myChats.add(
            Chats(
              idx: "0",
              date: element["date"].toString(),
              chat_id: element["chat_id"].toString(),
              messages: element["messages"].toString(),
              non_read_messages: element["non_read_messages"].toString(),
              status: element["status"].toString(),
              user_id: element["user_id"].toString(),
              STejari: element["STejari"].toString(),
              user_name: element["user_name"].toString(),
              firm_name: element["firm_name"].toString(),
              user_photo: element["user_photo"].toString(),
              firm_photo: element["firm_photo"].toString(),
              last_msg: element["last_msg"].toString(),
              total_status_0_sender_0:
                  element["total_status_0_sender_0"].toString(),
              total_status_0_sender_1:
                  element["total_status_0_sender_1"].toString(),
            ),
          );
          log(element["non_read_messages"].toString());
        });
        myChats = myChats.reversed.toList();

        setState(() {
          isLoading = false;
        });
        if (widget.openLastChat) {
          int i = myChats.length - 1;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => ChatPage(
                    userName: myChats[i].user_name,
                    firm_name: myChats[i].firm_name,
                    photo:
                        widget.isUser
                            ? myChats[i].firm_photo
                            : myChats[i].user_photo,
                    offer_id: myChats[i].chat_id,
                    STejari: myChats[i].STejari,
                    user_id: myChats[i].user_id,
                    sender: widget.isUser ? "0" : "1",
                  ),
            ),
          );
        }
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const NoInternet()),
          (route) => false,
        );
        snackBar(context, "ERROR please try again");
      }
    } else {
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
      body: Directionality(
        textDirection: language == "0" ? TextDirection.ltr : TextDirection.rtl,
        child: Stack(
          children: [
            Container(
              height: screenHeight * 0.15,
              decoration: BoxDecoration(gradient: gradient),
              child: Stack(
                children: [
                  Container(
                    width: 150,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/Logo Shape.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 15,
                        right: 15,
                        bottom: 15,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          isUserNow
                                              ? const MainPage()
                                              : const MainMerchantPage(
                                                pageindex: 0,
                                              ),
                                ),
                                (route) => false,
                              );
                            },
                            child: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            getText("Chats"),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
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
                                      builder:
                                          (context) => const NotificationPage(),
                                    ),
                                  );
                                },
                                child: Stack(
                                  children: [
                                    Image.asset("assets/bell.png", height: 22),
                                    unSeenNotiNum == 0
                                        ? Container()
                                        : Container(
                                          height: 14,
                                          width: 14,
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.circular(
                                              100,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              unSeenNotiNum.toString(),
                                              style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.white,
                                              ),
                                            ),
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
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.13),
              child: Container(
                height: screenHeight,
                width: screenWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child:
                      isLoading
                          ? Center(
                            child: CircularProgressIndicator(color: orange),
                          )
                          : myChats.isEmpty
                          ? Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 100),
                              child: Text(getText("message24")),
                            ),
                          )
                          : Column(
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Container(height: 10),
                                      for (int i = 0; i < myChats.length; i++)
                                        Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  myChats[i]
                                                          .total_status_0_sender_1 =
                                                      "0";
                                                  myChats[i]
                                                          .total_status_0_sender_0 =
                                                      "0";
                                                });
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (context) => ChatPage(
                                                          userName:
                                                              myChats[i]
                                                                  .user_name,
                                                          firm_name:
                                                              myChats[i]
                                                                  .firm_name,
                                                          photo:
                                                              widget.isUser
                                                                  ? myChats[i]
                                                                      .firm_photo
                                                                  : myChats[i]
                                                                      .user_photo,
                                                          offer_id:
                                                              myChats[i]
                                                                  .chat_id,
                                                          STejari:
                                                              myChats[i]
                                                                  .STejari,
                                                          user_id:
                                                              myChats[i]
                                                                  .user_id,
                                                          sender:
                                                              widget.isUser
                                                                  ? "0"
                                                                  : "1",
                                                        ),
                                                  ),
                                                );
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  8.0,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      height: 30,
                                                      width: 30,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                            widget.isUser
                                                                ? myChats[i]
                                                                    .firm_photo
                                                                : myChats[i]
                                                                    .user_photo,
                                                          ),
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              60,
                                                            ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 11,
                                                            ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  widget.isUser
                                                                      ? myChats[i]
                                                                          .firm_name
                                                                      : myChats[i]
                                                                          .user_name,
                                                                  style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        13,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "  ${getText("OrderNo")}${myChats[i].chat_id}",
                                                                  style: const TextStyle(
                                                                    color:
                                                                        Colors
                                                                            .grey,
                                                                    fontSize:
                                                                        11,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            !isUserNow
                                                                ? Container()
                                                                : Text(
                                                                  getText(
                                                                        "comReg",
                                                                      ) +
                                                                      myChats[i]
                                                                          .STejari,
                                                                  style: const TextStyle(
                                                                    color:
                                                                        Colors
                                                                            .grey,
                                                                    fontSize:
                                                                        13,
                                                                  ),
                                                                ),
                                                            Text(
                                                              myChats[i]
                                                                  .last_msg,
                                                              style: TextStyle(
                                                                color: greyc,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets.only(
                                                                bottom: 3,
                                                              ),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                "${DateTime.parse(myChats[i].date).day}-${DateTime.parse(myChats[i].date).month}-${DateTime.parse(myChats[i].date).year}",
                                                                style:
                                                                    const TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                    ),
                                                              ),
                                                              Text(
                                                                "${DateTime.parse(myChats[i].date).hour}:${DateTime.parse(myChats[i].date).minute}",
                                                                style:
                                                                    const TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                    ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          height: 18,
                                                          width: 18,
                                                          decoration: BoxDecoration(
                                                            color:
                                                                isUserNow
                                                                    ? myChats[i].total_status_0_sender_1 ==
                                                                            "0"
                                                                        ? Colors
                                                                            .white
                                                                        : orange
                                                                    : myChats[i]
                                                                            .total_status_0_sender_0 ==
                                                                        "0"
                                                                    ? Colors
                                                                        .white
                                                                    : orange,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  15,
                                                                ),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              isUserNow
                                                                  ? myChats[i]
                                                                      .total_status_0_sender_1
                                                                  : myChats[i]
                                                                      .total_status_0_sender_0,
                                                              style: const TextStyle(
                                                                fontSize: 13,
                                                                color:
                                                                    Colors
                                                                        .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            i == myChats.length - 1
                                                ? Container()
                                                : const Divider(),
                                          ],
                                        ),
                                    ],
                                  ),
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
    );
  }
}
