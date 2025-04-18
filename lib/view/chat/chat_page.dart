// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, deprecated_member_use

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import '/model/chat_items.dart';
import '/view/chat/pdf.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import '../../controller/language.dart';
import '../notification/notifications.dart';
import '/view/bills/mybills.dart';
import '/view/mainpage.dart';
import '/view/merchant/mainMerchentPage.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../controller/no_imternet.dart';
import '../../controller/textstyle.dart';
import 'package:http/http.dart' as http;
import '../../controller/var.dart';
import '../../model/message.dart';

class ChatPage extends StatefulWidget {
  final String userName, firm_name, photo, offer_id, STejari, user_id, sender;
  const ChatPage({
    super.key,
    required this.offer_id,
    required this.userName,
    required this.firm_name,
    required this.photo,
    required this.STejari,
    required this.user_id,
    required this.sender,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  int currentVoiceIndex = -1;
  bool haveText = false;
  FlutterSoundRecorder? _recorder;
  final player = AudioPlayer();
  bool buttonLoading = false;
  bool _isRecording = false;
  bool showMenu = false;
  bool showMenu2 = false;
  bool showUploadDelivaryImage = false;
  List<List> UploadedDeliveryImages = []; //imagename,Image path
  bool sending = false;
  bool isLoading = true;
  List<Message> messages = [];
  int contentType = 0;
  String filePath = "";
  String fileName = "";
  bool isPlaying = false;
  ChatInfo? chatInfo;

  final ScrollController _scrollController = ScrollController();
  @override
  void dispose() {
    _recorder!.closeRecorder();
    super.dispose();
  }

  @override
  void initState() {
    _recorder = FlutterSoundRecorder();
    _recorder!.openRecorder();
    fetchMessages();
    fetchItems();
    player.playbackEventStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        setState(() {
          isPlaying = false;
          currentVoiceIndex = -1;
        });
      }
    });
    super.initState();
  }

  Future<void> _recordAudio() async {
    if (_isRecording) {
      String? path = await _recorder!.stopRecorder();
      contentType = 3;
      if (path != null) {
        fileName = path.split('/').last;
        filePath = path;
        messageTextController.clear();
        haveText = true;
        player.setFilePath(filePath);

        setState(() {});
      } else {
        snackBar(context, getText("message56"));
      }
    } else {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        snackBar(context, getText("message55"));
        return;
      }
      await _recorder!.startRecorder(
        toFile: "voiceMessage.aac",
        codec: Codec.aacADTS,
      );
    }
    setState(() {
      _isRecording = !_isRecording;
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      String fileExtension = pickedFile.path.split('.').last.toLowerCase();
      if (fileExtension == 'png' ||
          fileExtension == 'jpeg' ||
          fileExtension == 'jpg' ||
          fileExtension == 'gif') {
        contentType = 2;
        fileName = pickedFile.name;
        filePath = pickedFile.path;
        messageTextController.clear();
        haveText = true;
        setState(() {});
      } else {
        snackBar(context, getText("message53"));
      }
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      if (result.files.single.path!.split('.').last.toLowerCase() == "pdf") {
        contentType = 1;
        fileName = result.files.single.name;

        filePath = result.files.single.path!;
        messageTextController.clear();
        haveText = true;
        setState(() {});
      } else {
        snackBar(context, getText("message51"));
      }
    }
  }

  fetchMessages() async {
    var headers = {'Cookie': 'PHPSESSID=pkjgl6qfq25j4hvhl359mma1ej'};
    try {
      var request = http.Request(
        'GET',
        Uri.parse(
          '$baseUrl/chat.php?input_key=$input_key&input_secret=$input_secret&offer_id=${widget.offer_id}&STejari=${widget.STejari}&user_id=${widget.user_id}&sender=${widget.sender}&msg_action=1&content=msgContent&content_type=0&msgStatus=0&shipmentStatus=1',
        ),
      );

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        Map data = json.decode(await response.stream.bytesToString());

        if (data["status"] == "success") {
          data["data"].forEach((element) {
            messages.add(
              Message(
                Idx: element["Idx"].toString(),
                offer_id: element["offer_id"].toString(),
                STejari: element["STejari"].toString(),
                user_id: element["user_id"].toString(),
                content: element["content"].toString(),
                content_type: element["content_type"].toString(),
                date_sent: element["date_sent"].toString(),
                msgStatus: element["msgStatus"].toString(),
                shipmentStatus: element["shipmentStatus"].toString(),
                sender: element["sender"].toString(),
                date_obtaind: element["date_obtaind"].toString(),
                user_name: element["user_name"].toString(),
                firm_name: element["firm_name"].toString(),
              ),
            );
          });
          String text = "Hello, your order is being delivered.";
          if (messages.length >= 2 &&
              messages[0].content == text &&
              messages[1].content == text) {
            messages.removeAt(0);
          }
          if (messages.length >= 2 &&
              messages[0].content == text &&
              messages[1].content == text) {
            messages.removeAt(0);
          }
          if (messages.length >= 2 &&
              messages[0].content == text &&
              messages[1].content == text) {
            messages.removeAt(0);
          }
          if (messages.length >= 2 &&
              messages[0].content == text &&
              messages[1].content == text) {
            messages.removeAt(0);
          }

          log(messages.toString());
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
      }
    } catch (e) {
      log(e.toString());
    }
  }

  fetchItems() async {
    var headers = {'Cookie': 'PHPSESSID=pkjgl6qfq25j4hvhl359mma1ej'};
    try {
      var request = http.Request(
        'GET',
        Uri.parse(
          '$baseUrl/chat.php?input_key=$input_key&input_secret=$input_secret&offer_id=${widget.offer_id}&STejari=${widget.STejari}&user_id=${widget.user_id}&sender=${widget.sender}&msg_action=3&content=msgContent&content_type=0&msgStatus=0&shipmentStatus=1',
        ),
      );

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        Map data = json.decode(await response.stream.bytesToString());

        if (data["status"] == "success") {
          List<ChatItem> chatitems = [];
          data["data"]["items"].forEach((element) {
            chatitems.add(
              ChatItem(
                Category_AR: element["Category_AR"],
                sub_category_AR: element["sub_category_AR"],
                product_AR: element["product_AR"],
                Category_EN: element["Category_EN"],
                sub_category_EN: element["sub_category_EN"],
                product_EN: element["product_EN"],
                unit: element["unit"],
                unit_ar: element["unit_ar"],
                image: element["image"],
                quantity: element["quantity"].toString(),
                total_price_per_product:
                    element["total_price_per_product"].toString(),
                original_price: element["original_price"].toString(),
                adjusted_price: element["adjusted_price"].toString(),
              ),
            );
          });
          chatInfo = ChatInfo(
            offer_id: data["data"]["offer_id"],
            lat: data["data"]["lat"].toString(),
            long: data["data"]["long"].toString(),
            STejari: data["data"]["STejari"],
            chatItems: chatitems,
          );
          setState(() {});
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const NoInternet()),
            (route) => false,
          );
        }
      }
    } catch (_) {}
  }

  TextEditingController messageTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Directionality(
        textDirection: language == "0" ? TextDirection.ltr : TextDirection.rtl,
        child: Stack(
          children: [
            Container(
              height: Platform.isIOS ? 90 : 85,
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
                          Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(widget.photo),
                              ),
                              borderRadius: BorderRadius.circular(60),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.sender == "0"
                                      ? widget.firm_name
                                      : widget.userName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  "${getText("OrderNo")}${widget.offer_id}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Expanded(child: Center()),
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
              padding: EdgeInsets.only(top: Platform.isIOS ? 90 : 75),
              child: Container(
                height: screenHeight,
                width: screenWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child:
                      isLoading
                          ? Center(
                            child: CircularProgressIndicator(color: orange),
                          )
                          : Column(
                            children: [
                              Container(height: 10),
                              chatInfo == null
                                  ? Container()
                                  : SizedBox(
                                    height: 100,
                                    child: ListView(
                                      padding: EdgeInsets.zero,
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        for (
                                          int i = 0;
                                          i < chatInfo!.chatItems.length;
                                          i++
                                        )
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 5,
                                            ),
                                            child: Container(
                                              height: 80,
                                              width: 200,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: greyc,
                                                ),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  4,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      language == "0"
                                                          ? chatInfo!
                                                              .chatItems[i]
                                                              .product_EN
                                                          : chatInfo!
                                                              .chatItems[i]
                                                              .product_AR,
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    Text(
                                                      language == "0"
                                                          ? "${chatInfo!.chatItems[i].Category_EN} | ${chatInfo!.chatItems[i].sub_category_EN}"
                                                          : "${chatInfo!.chatItems[i].Category_AR} | ${chatInfo!.chatItems[i].sub_category_AR}",
                                                      style: const TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    Text(
                                                      language == "0"
                                                          ? "${chatInfo!.chatItems[i].quantity} ${chatInfo!.chatItems[i].unit}"
                                                          : "${chatInfo!.chatItems[i].quantity} ${chatInfo!.chatItems[i].unit_ar}",
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${chatInfo!.chatItems[i].adjusted_price} ${getText("SR")}",
                                                      style: const TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.green,
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
                              Expanded(
                                child: SingleChildScrollView(
                                  controller: _scrollController,
                                  child: Column(
                                    children: [
                                      for (int i = 0; i < messages.length; i++)
                                        messages[i].sender == widget.sender
                                            ? sendMessage(i)
                                            : recieveMessage(i),
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(),
                              Row(
                                children: [
                                  widget.sender == "1"
                                      ? InkWell(
                                        onTap: () {
                                          setState(() {
                                            showMenu2 = !showMenu2;
                                            UploadedDeliveryImages = [];
                                            if (showMenu2) {
                                              showMenu = false;
                                              showUploadDelivaryImage = false;
                                            }
                                          });
                                        },
                                        child: Icon(
                                          Icons.delivery_dining_sharp,
                                          color:
                                              showMenu2 ? orange : Colors.grey,
                                          size: 25,
                                        ),
                                      )
                                      : Container(),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        showMenu = !showMenu;
                                        if (showMenu) {
                                          showMenu2 = false;
                                          showUploadDelivaryImage = false;
                                        }
                                      });
                                    },
                                    child: Icon(
                                      Icons.add,
                                      color: showMenu ? orange : Colors.grey,
                                      size: 25,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                      ),
                                      child: SizedBox(
                                        height: 40,
                                        child: Center(
                                          child:
                                              contentType != 0
                                                  ? Row(
                                                    children: [
                                                      Text(fileName),
                                                      InkWell(
                                                        onTap: () {
                                                          fileName = "";
                                                          filePath = "";
                                                          contentType = 0;
                                                          haveText = false;
                                                          setState(() {});
                                                        },
                                                        child: const Icon(
                                                          Icons.close,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                  : TextField(
                                                    controller:
                                                        messageTextController,
                                                    onChanged: (value) {
                                                      if (contentType == 0 &&
                                                          value
                                                              .trim()
                                                              .isEmpty) {
                                                        setState(() {
                                                          haveText = false;
                                                        });
                                                      } else if (contentType ==
                                                              0 &&
                                                          value
                                                              .trim()
                                                              .isNotEmpty) {
                                                        setState(() {
                                                          haveText = true;
                                                        });
                                                      }
                                                    },
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets.only(
                                                            bottom: 5,
                                                            left: 10,
                                                            right: 10,
                                                          ),
                                                      filled: true,
                                                      fillColor: greyc
                                                          .withOpacity(.3),
                                                      border:
                                                          const OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                  Radius.circular(
                                                                    5,
                                                                  ),
                                                                ),
                                                            borderSide:
                                                                BorderSide.none,
                                                          ),
                                                    ),
                                                  ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      send();
                                    },
                                    child:
                                        sending
                                            ? Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: SizedBox(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                      color: orange,
                                                    ),
                                              ),
                                            )
                                            : Icon(
                                              Icons.send,
                                              size: 23,
                                              color:
                                                  !haveText
                                                      ? Colors.grey
                                                      : orange,
                                            ),
                                  ),
                                ],
                              ),
                              showMenu
                                  ? SizedBox(
                                    height: 100,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            _pickFile();
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 55,
                                                width: 55,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                child: Center(
                                                  child: Image.asset(
                                                    "assets/note-text.png",
                                                    width: 30,
                                                  ),
                                                ),
                                              ),
                                              Container(height: 4),
                                              Text(getText("File")),
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            _pickImage();
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 55,
                                                width: 55,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                child: Center(
                                                  child: Image.asset(
                                                    "assets/image-gallery.png",
                                                    width: 30,
                                                  ),
                                                ),
                                              ),
                                              Container(height: 4),
                                              Text(getText("Photo")),
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            _recordAudio();
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 55,
                                                width: 55,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                child: Center(
                                                  child:
                                                      _isRecording
                                                          ? const Icon(
                                                            Icons
                                                                .record_voice_over_outlined,
                                                            color: Colors.red,
                                                          )
                                                          : Image.asset(
                                                            "assets/microphone.png",
                                                            width: 30,
                                                          ),
                                                ),
                                              ),
                                              Container(height: 4),
                                              Text(getText("Audio")),
                                            ],
                                          ),
                                        ),
                                        isUserNow
                                            ? Container()
                                            : InkWell(
                                              onTap: () async {
                                                if (chatInfo != null) {
                                                  String latitude =
                                                      chatInfo!.lat;
                                                  String longitude =
                                                      chatInfo!.long;
                                                  String googleMapsUrl =
                                                      "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";
                                                  String appleMapsUrl =
                                                      "https://maps.apple.com/?q=$latitude,$longitude";

                                                  if (await canLaunch(
                                                    googleMapsUrl,
                                                  )) {
                                                    await launch(googleMapsUrl);
                                                  } else if (await canLaunch(
                                                    appleMapsUrl,
                                                  )) {
                                                    await launch(appleMapsUrl);
                                                  } else {
                                                    throw 'Could not launch map';
                                                  }
                                                }
                                              },
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    height: 55,
                                                    width: 55,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            50,
                                                          ),
                                                      border: Border.all(
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Image.asset(
                                                        "assets/location-pin.png",
                                                        width: 30,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(height: 4),
                                                  Text(getText("Location")),
                                                ],
                                              ),
                                            ),
                                      ],
                                    ),
                                  )
                                  : Container(),
                              showMenu2
                                  ? SizedBox(
                                    height: 100,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              UploadedDeliveryImages = [];
                                              showUploadDelivaryImage = true;
                                              showMenu = false;
                                              showMenu2 = false;
                                            });
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 55,
                                                width: 55,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                child: Center(
                                                  child: Image.asset(
                                                    "assets/image-gallery.png",
                                                    width: 30,
                                                  ),
                                                ),
                                              ),
                                              Container(height: 4),
                                              const Text("End chat"),
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            _showContactInfo();
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 55,
                                                width: 55,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.contact_page_outlined,
                                                  ),
                                                ),
                                              ),
                                              Container(height: 4),
                                              const Text("Contact Info"),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  : Container(),
                              showUploadDelivaryImage
                                  ? SizedBox(
                                    height: 130,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const Text(
                                          "You must upload at least two photos of the delivery",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            if (UploadedDeliveryImages.length >=
                                                6) {
                                              snackBar(
                                                context,
                                                "You have uploaded the maximum number of images",
                                              );
                                            } else {
                                              final picker = ImagePicker();
                                              final pickedFile = await picker
                                                  .pickImage(
                                                    source: ImageSource.gallery,
                                                  );

                                              if (pickedFile != null) {
                                                String fileExtension =
                                                    pickedFile.path
                                                        .split('.')
                                                        .last
                                                        .toLowerCase();
                                                if (fileExtension == 'png' ||
                                                    fileExtension == 'jpeg' ||
                                                    fileExtension == 'jpg' ||
                                                    fileExtension == 'gif') {
                                                  String name = pickedFile.name;
                                                  String path = pickedFile.path;
                                                  UploadedDeliveryImages.add([
                                                    name,
                                                    path,
                                                  ]);
                                                  setState(() {});
                                                } else {
                                                  snackBar(
                                                    context,
                                                    getText("message53"),
                                                  );
                                                }
                                              }
                                            }
                                          },
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.upload),
                                              Text(" click to upload "),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                for (
                                                  int i = 0;
                                                  i <
                                                      UploadedDeliveryImages
                                                          .length;
                                                  i++
                                                )
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        UploadedDeliveryImages[i][0]
                                                            .toString(),
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            UploadedDeliveryImages.removeAt(
                                                              i,
                                                            );
                                                          });
                                                        },
                                                        child: const Icon(
                                                          Icons.close,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            if (UploadedDeliveryImages.length <
                                                2) {
                                              snackBar(
                                                context,
                                                "you should upload at least two images",
                                              );
                                            } else {
                                              if (!buttonLoading) {
                                                var headers = {
                                                  'Cookie':
                                                      'PHPSESSID=pkjgl6qfq25j4hvhl359mma1ej',
                                                };
                                                setState(() {
                                                  buttonLoading = true;
                                                });
                                                int counter =
                                                    UploadedDeliveryImages
                                                        .length;
                                                for (
                                                  int i = 0;
                                                  i <
                                                      UploadedDeliveryImages
                                                          .length;
                                                  i++
                                                ) {
                                                  var uploadrequest =
                                                      http.MultipartRequest(
                                                        'POST',
                                                        Uri.parse(
                                                          '$baseUrl/upload.php',
                                                        ),
                                                      );
                                                  uploadrequest.fields.addAll({
                                                    'subject_id':
                                                        widget.offer_id,
                                                    'user_id': widget.user_id,
                                                    'input_secret':
                                                        input_secret,
                                                    'input_key': input_key,
                                                  });
                                                  uploadrequest.files.add(
                                                    await http
                                                        .MultipartFile.fromPath(
                                                      'file',
                                                      UploadedDeliveryImages[i][1],
                                                    ),
                                                  );
                                                  uploadrequest.headers.addAll(
                                                    headers,
                                                  );

                                                  http.StreamedResponse
                                                  uploadresponse =
                                                      await uploadrequest
                                                          .send();
                                                  String uploadresBody =
                                                      await uploadresponse
                                                          .stream
                                                          .bytesToString();

                                                  if (uploadresponse
                                                          .statusCode ==
                                                      200) {
                                                    Map uploaddata = json
                                                        .decode(uploadresBody);
                                                    if (uploaddata["status"] ==
                                                        "success") {
                                                      var sendrequest =
                                                          http.Request(
                                                            'GET',
                                                            Uri.parse(
                                                              '$baseUrl/chat.php?input_key=$input_key&input_secret=$input_secret&offer_id=${widget.offer_id}&STejari=${widget.STejari}&user_id=${widget.user_id}&sender=${widget.sender}&msg_action=0&content=${uploaddata["path"]}&content_type=2&msgStatus=0&shipmentStatus=1',
                                                            ),
                                                          );

                                                      sendrequest.headers
                                                          .addAll(headers);

                                                      http.StreamedResponse
                                                      sendresponse =
                                                          await sendrequest
                                                              .send();

                                                      if (sendresponse
                                                              .statusCode ==
                                                          200) {
                                                        Map
                                                        sendData = json.decode(
                                                          await sendresponse
                                                              .stream
                                                              .bytesToString(),
                                                        );

                                                        if (sendData["status"] ==
                                                            "success") {
                                                          messages.add(
                                                            Message(
                                                              Idx:
                                                                  "1", //what i should fill the idx
                                                              offer_id:
                                                                  widget
                                                                      .offer_id,
                                                              STejari:
                                                                  widget
                                                                      .STejari,
                                                              user_id:
                                                                  widget
                                                                      .user_id,
                                                              content:
                                                                  uploaddata["url"] +
                                                                  uploaddata["path"],
                                                              content_type: "2",
                                                              date_sent:
                                                                  DateTime.now()
                                                                      .toString(),
                                                              msgStatus: "0",
                                                              shipmentStatus:
                                                                  "1",
                                                              sender:
                                                                  widget.sender,
                                                              date_obtaind:
                                                                  DateTime.now()
                                                                      .toString(),
                                                              user_name:
                                                                  widget
                                                                      .userName,
                                                              firm_name:
                                                                  widget
                                                                      .firm_name,
                                                            ),
                                                          );

                                                          _scrollController.animateTo(
                                                            _scrollController
                                                                    .position
                                                                    .maxScrollExtent +
                                                                320,
                                                            duration:
                                                                const Duration(
                                                                  milliseconds:
                                                                      500,
                                                                ),
                                                            curve:
                                                                Curves.easeOut,
                                                          );
                                                          messageTextController
                                                              .text = "";
                                                          messageTextController
                                                              .clear();
                                                          counter -= 1;
                                                          setState(() {});
                                                          if (counter == 0) {
                                                            var request2 =
                                                                http.Request(
                                                                  'GET',
                                                                  Uri.parse(
                                                                    '$baseUrl/chat.php?input_key=$input_key&input_secret=$input_secret&offer_id=${widget.offer_id}&STejari=${widget.STejari}&user_id=${widget.user_id}&msg_action=4',
                                                                  ),
                                                                );

                                                            request2.headers
                                                                .addAll(
                                                                  headers,
                                                                );

                                                            http.StreamedResponse
                                                            response2 =
                                                                await request2
                                                                    .send();

                                                            if (response2
                                                                    .statusCode ==
                                                                200) {
                                                              Map
                                                              data2 = json.decode(
                                                                await response2
                                                                    .stream
                                                                    .bytesToString(),
                                                              );
                                                              log(
                                                                data2
                                                                    .toString(),
                                                              );

                                                              snackBar(
                                                                context,
                                                                "success process the chat closed",
                                                              );
                                                              if (widget
                                                                      .sender ==
                                                                  "1") {
                                                                Navigator.pushAndRemoveUntil(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (
                                                                          context,
                                                                        ) => const MainMerchantPage(
                                                                          pageindex:
                                                                              0,
                                                                        ),
                                                                  ),
                                                                  (route) =>
                                                                      false,
                                                                );
                                                              } else {
                                                                Navigator.pushAndRemoveUntil(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (
                                                                          context,
                                                                        ) =>
                                                                            const MainPage(),
                                                                  ),
                                                                  (route) =>
                                                                      false,
                                                                );
                                                              }

                                                              showCupertinoDialog(
                                                                context:
                                                                    context,
                                                                builder: (
                                                                  BuildContext
                                                                  context,
                                                                ) {
                                                                  return CupertinoAlertDialog(
                                                                    title: const Text(
                                                                      'the chat closed',
                                                                    ),
                                                                    content:
                                                                        const Text(
                                                                          "the chat closed you can't now send and receive messages",
                                                                        ),
                                                                    actions: <
                                                                      Widget
                                                                    >[
                                                                      CupertinoDialogAction(
                                                                        child: const Text(
                                                                          'Go To Bill',
                                                                        ),
                                                                        onPressed: () {
                                                                          Navigator.pop(
                                                                            context,
                                                                          );

                                                                          Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                              builder:
                                                                                  (
                                                                                    context,
                                                                                  ) => MyBills(
                                                                                    isFirstOpen:
                                                                                        true,
                                                                                  ),
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
                                                                      CupertinoDialogAction(
                                                                        child: Text(
                                                                          getText(
                                                                            "Cancel",
                                                                          ),
                                                                        ),
                                                                        onPressed: () {
                                                                          Navigator.of(
                                                                            context,
                                                                          ).pop();
                                                                        },
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              );

                                                              setState(() {
                                                                UploadedDeliveryImages =
                                                                    [];
                                                                showMenu =
                                                                    false;
                                                                showMenu2 =
                                                                    false;
                                                                showUploadDelivaryImage =
                                                                    false;
                                                                buttonLoading =
                                                                    false;
                                                                messageTextController
                                                                    .text = "";
                                                                messageTextController
                                                                    .clear();
                                                              });
                                                            }
                                                          }
                                                        } else {
                                                          snackBar(
                                                            context,
                                                            sendData.toString(),
                                                          );
                                                        }
                                                        setState(() {
                                                          sending = false;
                                                        });
                                                      }
                                                    } else {
                                                      snackBar(
                                                        context,
                                                        uploaddata.toString(),
                                                      );
                                                      setState(() {
                                                        buttonLoading = false;
                                                      });
                                                    }
                                                  }
                                                }
                                              }
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
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Center(
                                                child:
                                                    buttonLoading
                                                        ? const SizedBox(
                                                          height: 20,
                                                          width: 20,
                                                          child:
                                                              CircularProgressIndicator(
                                                                color:
                                                                    Colors
                                                                        .white,
                                                              ),
                                                        )
                                                        : const Text(
                                                          "End chat",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  : Container(),
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

  void _showContactInfo() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Contact info'),
          content: Material(
            color: Colors.white.withOpacity(0),
            child: InkWell(
              onTap: () async {
                String phone = "+9660000000000";
                final url = 'tel:$phone';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
              child: const Text('Phone : +9660000000000'),
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  send() async {
    if (!haveText) {
      snackBar(context, getText("message57"));
    } else {
      setState(() {
        sending = true;
      });

      try {
        log(contentType.toString());
        if (contentType == 0) {
          sendApi("");
        } else {
          log(filePath);
          uploadFile();
        }
      } catch (_) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const NoInternet()),
          (route) => false,
        );
      }
    }
  }

  uploadFile() async {
    var headers = {'Cookie': 'PHPSESSID=pkjgl6qfq25j4hvhl359mma1ej'};
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/upload.php'),
    );
    request.fields.addAll({
      'subject_id': widget.offer_id,
      'user_id': widget.user_id,
      'input_secret': input_secret,
      'input_key': input_key,
    });
    request.files.add(await http.MultipartFile.fromPath('file', filePath));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    String resBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      Map data = json.decode(resBody);
      if (data["status"] == "success") {
        filePath = data["url"] + data["path"];
        log(filePath);
        log("///////////////////1111");

        sendApi(data["path"].toString());
      } else {
        snackBar(context, "ERROR please try again");
        setState(() {
          sending = false;
        });
      }
    }
  }

  sendApi(String dataPath) async {
    var headers = {'Cookie': 'PHPSESSID=pkjgl6qfq25j4hvhl359mma1ej'};

    var request = http.Request(
      'GET',
      Uri.parse(
        '$baseUrl/chat.php?input_key=$input_key&input_secret=$input_secret&offer_id=${widget.offer_id}&STejari=${widget.STejari}&user_id=${widget.user_id}&sender=${widget.sender}&msg_action=0&content=${contentType == 0 ? messageTextController.text.trim() : dataPath}&content_type=$contentType&msgStatus=0&shipmentStatus=1',
      ),
    );

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      Map data = json.decode(await response.stream.bytesToString());

      if (data["status"] == "success") {
        messages.add(
          Message(
            Idx: "1", //what i should fill the idx
            offer_id: widget.offer_id,
            STejari: widget.STejari,
            user_id: widget.user_id,
            content:
                contentType == 0 ? messageTextController.text.trim() : filePath,
            content_type: contentType.toString(),
            date_sent: DateTime.now().toString(),
            msgStatus: "0",
            shipmentStatus: "1",
            sender: widget.sender,
            date_obtaind: DateTime.now().toString(),
            user_name: widget.userName,
            firm_name: widget.firm_name,
          ),
        );

        fileName = "";
        filePath = "";
        contentType = 0;
        haveText = false;
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 200,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
        messageTextController.text = "";
        messageTextController.clear();
      } else {
        snackBar(context, "ERROR please try again");
      }
      setState(() {
        sending = false;
      });
    } else {
      log("///////////////////errrroe here in else ");
    }
  }

  sendMessage(int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          width: screenWidth * .5,
          decoration: BoxDecoration(
            color: const Color(0xffFF8501).withOpacity(.6),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
          ),
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      messages[index].content.endsWith(".pdf")
                          ? GestureDetector(
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => PDFViewerPage(
                                        pdfUrl: messages[index].content,
                                      ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.picture_as_pdf,
                                    color: Colors.red,
                                  ),
                                  const SizedBox(width: 8.0),
                                  Expanded(
                                    child: Text(
                                      getText("PdfFil"),
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          : messages[index].content.endsWith(".aac")
                          ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              StreamBuilder<Duration>(
                                stream: player.positionStream,
                                builder: (context, snapshot) {
                                  final position =
                                      snapshot.data ?? Duration.zero;
                                  final totalDuration =
                                      player.duration ?? Duration.zero;
                                  final progress =
                                      totalDuration.inMilliseconds > 0
                                          ? position.inMilliseconds /
                                              totalDuration.inMilliseconds
                                          : 0.0;

                                  return Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                          color: Colors.white.withOpacity(.4),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8.0,
                                          ),
                                          child: Row(
                                            children: [
                                              InkWell(
                                                onTap: () async {
                                                  log("heeeererere222");
                                                  if (currentVoiceIndex ==
                                                      index) {
                                                    log("heeeererere");
                                                    if (progress <= 0) {
                                                      player.play();
                                                    } else if (progress >= 1) {
                                                      player.seek(
                                                        Duration.zero,
                                                      );
                                                    } else {
                                                      if (isPlaying) {
                                                        player.pause();
                                                      } else {
                                                        player.play();
                                                      }

                                                      setState(() {
                                                        isPlaying = !isPlaying;
                                                      });
                                                    }
                                                  } else {
                                                    setState(() {
                                                      currentVoiceIndex = index;
                                                      isPlaying = true;
                                                    });
                                                    player.setUrl(
                                                      messages[index].content,
                                                    );

                                                    await player.play();
                                                  }
                                                },
                                                child: Icon(
                                                  isPlaying &&
                                                          currentVoiceIndex ==
                                                              index
                                                      ? Icons.pause
                                                      : Icons.play_arrow,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Container(width: 15),
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                    5,
                                                  ),
                                                  child: LinearProgressIndicator(
                                                    value:
                                                        currentVoiceIndex ==
                                                                index
                                                            ? progress
                                                            : 0,
                                                    minHeight: 10,
                                                    backgroundColor:
                                                        Colors.grey[300],
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                          Color
                                                        >(orange),
                                                  ),
                                                ),
                                              ),
                                              Container(width: 15),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          )
                          : messages[index].content.endsWith(".png") ||
                              messages[index].content.endsWith(".jpeg") ||
                              messages[index].content.endsWith(".jpg") ||
                              messages[index].content.endsWith(".gif")
                          ? Image.network(messages[index].content, height: 220)
                          : Text(
                            messages[index].content,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 7, bottom: 5),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Row(
                    children: [
                      Expanded(child: Container()),
                      Text(
                        "${DateTime.parse(messages[index].date_sent).hour}:${DateTime.parse(messages[index].date_sent).minute}",
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                      Container(width: 4),
                      messages[index].msgStatus == "1"
                          ? const Icon(Icons.done_all, color: Colors.blue)
                          : const Icon(Icons.done, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  recieveMessage(int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: screenWidth * .5,
          decoration: BoxDecoration(
            color: greyc.withOpacity(.3),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(9),
              child: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          messages[index].content.endsWith(".pdf")
                              ? GestureDetector(
                                onTap: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => PDFViewerPage(
                                            pdfUrl: messages[index].content,
                                          ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.picture_as_pdf,
                                        color: Colors.red,
                                      ),
                                      const SizedBox(width: 8.0),
                                      Expanded(
                                        child: Text(
                                          getText("PdfFil"),
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              : messages[index].content.endsWith(".aac")
                              ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  StreamBuilder<Duration>(
                                    stream: player.positionStream,
                                    builder: (context, snapshot) {
                                      final position =
                                          snapshot.data ?? Duration.zero;
                                      final totalDuration =
                                          player.duration ?? Duration.zero;
                                      final progress =
                                          totalDuration.inMilliseconds > 0
                                              ? position.inMilliseconds /
                                                  totalDuration.inMilliseconds
                                              : 0.0;

                                      return Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              color: Colors.white.withOpacity(
                                                .4,
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 8.0,
                                                  ),
                                              child: Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () async {
                                                      log("heeeererere222");
                                                      if (currentVoiceIndex ==
                                                          index) {
                                                        log("heeeererere");
                                                        if (progress <= 0) {
                                                          player.play();
                                                        } else if (progress >=
                                                            1) {
                                                          player.seek(
                                                            Duration.zero,
                                                          );
                                                        } else {
                                                          if (isPlaying) {
                                                            player.pause();
                                                          } else {
                                                            player.play();
                                                          }

                                                          setState(() {
                                                            isPlaying =
                                                                !isPlaying;
                                                          });
                                                        }
                                                      } else {
                                                        setState(() {
                                                          currentVoiceIndex =
                                                              index;
                                                          isPlaying = true;
                                                        });
                                                        player.setUrl(
                                                          messages[index]
                                                              .content,
                                                        );

                                                        await player.play();
                                                      }
                                                    },
                                                    child: Icon(
                                                      isPlaying &&
                                                              currentVoiceIndex ==
                                                                  index
                                                          ? Icons.pause
                                                          : Icons.play_arrow,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Container(width: 15),
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            5,
                                                          ),
                                                      child: LinearProgressIndicator(
                                                        value:
                                                            currentVoiceIndex ==
                                                                    index
                                                                ? progress
                                                                : 0,
                                                        minHeight: 10,
                                                        backgroundColor:
                                                            Colors.grey[300],
                                                        valueColor:
                                                            const AlwaysStoppedAnimation<
                                                              Color
                                                            >(Colors.black),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(width: 15),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              )
                              : messages[index].content.endsWith(".png") ||
                                  messages[index].content.endsWith(".jpeg") ||
                                  messages[index].content.endsWith(".jpg") ||
                                  messages[index].content.endsWith(".gif")
                              ? Image.network(
                                messages[index].content,
                                height: 220,
                              )
                              : Text(
                                messages[index].content,
                                style: const TextStyle(fontSize: 13),
                              ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${DateTime.parse(messages[index].date_sent).hour}:${DateTime.parse(messages[index].date_sent).minute}",
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
