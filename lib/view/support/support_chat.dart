import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import '/model/message_support.dart';
import '/view/chat/pdf.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../controller/language.dart';
import '../../controller/no_imternet.dart';
import '../../controller/textstyle.dart';
import '../../controller/var.dart';
import 'package:http/http.dart' as http;

class SupportChat extends StatefulWidget {
  String offerId;
  String ticket_type;
  String ticket_title;

  SupportChat({
    super.key,
    required this.offerId,
    required this.ticket_type,
    required this.ticket_title,
  });

  @override
  State<SupportChat> createState() => _SupportChatState();
}

class _SupportChatState extends State<SupportChat> {
  bool haveText = false;
  FlutterSoundRecorder? _recorder;
  final player = AudioPlayer();
  bool buttonLoading = false;

  bool _isRecording = false;
  bool showMenu = false;
  bool showMenu2 = false;

  bool sending = false;
  bool isLoading = true;
  List<MessageSupport> messages = [];
  int contentType = 0;
  String filePath = "";
  String fileName = "";
  bool isPlaying = false;
  int currentVoiceIndex = -1;

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
        await player.play();

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
      String senderType = isUserNow ? "0" : "1";
      String userId = await getUserId();
      log("/////");
      log(userId);
      var request = http.Request(
          'GET',
          Uri.parse(
              '$baseUrl/support_chat.php?input_key=$input_key&input_secret=$input_secret&sender_type=$senderType&offer_id=${widget.offerId}&sender=3&id=$userId&scenario=1'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      log("message:");

      if (response.statusCode == 200) {
        Map data = json.decode(await response.stream.bytesToString());
        log(data.toString());
        if (data["success"].toString() == "true") {
          log("heeererere");
          try {
            data["data"].forEach((element) {
              messages.add(MessageSupport(
                  Idx: element["Idx"].toString(),
                  offer_id: element["offer_id"].toString(),
                  sender: element["sender"].toString(),
                  id: element["id"].toString(),
                  content: element["content"].toString(),
                  content_type: element["content_type"].toString(),
                  date_sent: element["date_sent"].toString()));
            });
          } catch (_) {
            messages = [];
          }

          setState(() {
            isLoading = false;
          });
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const NoInternet()),
              (route) => false);
          snackBar(context, "ERROR please try again");
        }
      }
    } catch (e) {
      log(messages.toString());
      log(e.toString());
    }
  }

  TextEditingController messageTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Directionality(
          textDirection:
              language == "0" ? TextDirection.ltr : TextDirection.rtl,
          child: Stack(children: [
            Container(
              height: Platform.isIOS ? 90 : 110,
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                          ),
                          Image.asset(
                            "assets/helpAndSupport.png",
                            height: 35,
                          ),
                          Container(
                            width: 10,
                          ),
                          Text(
                            getText("Help"),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: Platform.isIOS ? 90 : 90),
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
                          : Column(
                              children: [
                                Expanded(
                                  child: SingleChildScrollView(
                                    controller: _scrollController,
                                    child: Column(
                                      children: [
                                        for (int i = 0;
                                            i < messages.length;
                                            i++)
                                          messages[i].sender == "0" ||
                                                  messages[i].sender == "1"
                                              ? sendMessage(i)
                                              : recieveMessage(i),
                                      ],
                                    ),
                                  ),
                                ),
                                const Divider(),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          showMenu = !showMenu;
                                          if (showMenu) {
                                            showMenu2 = false;
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
                                            horizontal: 6),
                                        child: SizedBox(
                                          height: 40,
                                          child: Center(
                                            child: contentType != 0
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
                                                              Icons.close)),
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
                                                              right: 10),
                                                      filled: true,
                                                      fillColor:
                                                          greyc.withOpacity(.3),
                                                      border:
                                                          const OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5)),
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
                                      child: sending
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
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
                                              color: !haveText
                                                  ? Colors.grey
                                                  : orange,
                                            ),
                                    )
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
                                                            BorderRadius
                                                                .circular(50),
                                                        border: Border.all(
                                                            color:
                                                                Colors.grey)),
                                                    child: Center(
                                                        child: Image.asset(
                                                      "assets/note-text.png",
                                                      width: 30,
                                                    )),
                                                  ),
                                                  Container(
                                                    height: 4,
                                                  ),
                                                  Text(getText("File"))
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
                                                            BorderRadius
                                                                .circular(50),
                                                        border: Border.all(
                                                            color:
                                                                Colors.grey)),
                                                    child: Center(
                                                        child: Image.asset(
                                                      "assets/image-gallery.png",
                                                      width: 30,
                                                    )),
                                                  ),
                                                  Container(
                                                    height: 4,
                                                  ),
                                                  Text(getText("Photo"))
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
                                                            BorderRadius
                                                                .circular(50),
                                                        border: Border.all(
                                                            color:
                                                                Colors.grey)),
                                                    child: Center(
                                                        child: _isRecording
                                                            ? const Icon(
                                                                Icons
                                                                    .record_voice_over_outlined,
                                                                color:
                                                                    Colors.red,
                                                              )
                                                            : Image.asset(
                                                                "assets/microphone.png",
                                                                width: 30,
                                                              )),
                                                  ),
                                                  Container(
                                                    height: 4,
                                                  ),
                                                  Text(getText("Audio"))
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                    )))
          ]),
        ));
  }

  send() async {
    if (!haveText) {
      snackBar(context, getText("message57"));
    } else {
      setState(() {
        sending = true;
      });

      try {
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
            (route) => false);
      }
    }
  }

  uploadFile() async {
    String userId = await getUserId();
    var headers = {'Cookie': 'PHPSESSID=pkjgl6qfq25j4hvhl359mma1ej'};
    var request =
        http.MultipartRequest('POST', Uri.parse('$baseUrl/upload.php'));
    request.fields.addAll({
      'subject_id': widget.offerId,
      'user_id': userId,
      'input_secret': input_secret,
      'input_key': input_key
    });
    request.files.add(await http.MultipartFile.fromPath('file', filePath));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    String resBody = await response.stream.bytesToString();
    log(resBody);
    log(filePath);
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
    String senderType = isUserNow ? "0" : "1";
    String userId = await getUserId();
    var request = http.Request(
        'GET',
        Uri.parse(
            '$baseUrl/support_chat.php?input_key=$input_key&input_secret=$input_secret&sender_type=$senderType&offer_id=${widget.offerId}&sender=$senderType&id=$userId&content_type=$contentType&content=${contentType == 0 ? messageTextController.text.trim() : dataPath}&title=${widget.ticket_title}&ticket_type=${widget.ticket_type}&scenario=0'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      Map data = json.decode(await response.stream.bytesToString());

      if (data["success"].toString() == "true") {
        messages.add(MessageSupport(
            Idx: "1",
            offer_id: widget.offerId,
            sender: senderType,
            id: userId,
            content:
                contentType == 0 ? messageTextController.text.trim() : filePath,
            content_type: contentType.toString(),
            date_sent: DateTime.now().toString()));

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
    } else {}
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
              )),
          child: Column(
            children: [
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: messages[index].content.endsWith(".pdf")
                    ? GestureDetector(
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PDFViewerPage(
                                    pdfUrl: messages[index].content)),
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
                              const Icon(Icons.picture_as_pdf,
                                  color: Colors.red),
                              const SizedBox(width: 8.0),
                              Expanded(
                                  child: Text(
                                getText("PdfFil"),
                                style: const TextStyle(color: Colors.black),
                              )),
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
                                              color:
                                                  Colors.white.withOpacity(.4)),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: Row(
                                              children: [
                                                InkWell(
                                                  onTap: () async {
                                                    if (currentVoiceIndex ==
                                                        index) {
                                                      if (progress <= 0) {
                                                        player.play();
                                                      } else if (progress >=
                                                          1) {
                                                        player.seek(
                                                            Duration.zero);
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
                                                              .content);

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
                                                Container(
                                                  width: 15,
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    child:
                                                        LinearProgressIndicator(
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
                                                              Color>(orange),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: 15,
                                                ),
                                              ],
                                            ),
                                          )),
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
                                style: const TextStyle(
                                    fontSize: 13, color: Colors.white),
                              ),
              )),
              Padding(
                padding: const EdgeInsets.only(right: 7, bottom: 5),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Row(
                    children: [
                      Expanded(child: Container()),
                      Text(
                        "${DateTime.parse(messages[index].date_sent).hour}:${DateTime.parse(messages[index].date_sent).minute}",
                        style:
                            const TextStyle(fontSize: 10, color: Colors.white),
                      ),
                      Container(
                        width: 4,
                      ),
                    ],
                  ),
                ),
              )
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
              )),
          child: Center(
              child: Padding(
            padding: const EdgeInsets.all(9),
            child: Column(
              children: [
                messages[index].content.endsWith(".png") ||
                        messages[index].content.endsWith(".jpeg") ||
                        messages[index].content.endsWith(".jpg") ||
                        messages[index].content.endsWith(".gif")
                    ? Image.network(
                        messages[index].content,
                        height: 220,
                      )
                    : Text(
                        messages[index].content,
                        style:
                            const TextStyle(fontSize: 13, color: Colors.black),
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
          )),
        ),
      ),
    );
  }
}
