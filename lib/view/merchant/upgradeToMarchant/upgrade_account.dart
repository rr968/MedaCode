import 'dart:convert';
import 'dart:developer';

import '/controller/language.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '/controller/var.dart';
import 'package:http/http.dart' as http;
import '/view/auth/sucess_signup.dart';

class UpgradeAccount extends StatefulWidget {
  const UpgradeAccount({super.key});

  @override
  State<UpgradeAccount> createState() => _UpgradeAccountState();
}

class _UpgradeAccountState extends State<UpgradeAccount> {
  List<List> uploadedFiles = []; //imagename,Image path
  bool buttonLoading = false;
  TextEditingController niid = TextEditingController();

  TextEditingController vatNumber = TextEditingController();
  TextEditingController firmName = TextEditingController();
  TextEditingController comReg = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: language == "0" ? TextDirection.ltr : TextDirection.rtl,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 17, right: 17, top: 15),
                child: Text(
                  getText("UpgradeAccount"),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        child: TextField(
                          controller: niid,
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 2,
                              ),
                            ),
                            hintText: getText("NationalID"),
                            hintStyle: const TextStyle(fontSize: 12),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 5,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: TextField(
                          controller: vatNumber,
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 2,
                              ),
                            ),
                            hintText: getText("VNumber"),
                            hintStyle: const TextStyle(fontSize: 12),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 5,
                            ),
                          ),
                        ),
                      ),
                      Container(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: TextField(
                          controller: firmName,
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 2,
                              ),
                            ),
                            hintText: getText("Firmname"),
                            hintStyle: const TextStyle(fontSize: 12),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 5,
                            ),
                          ),
                        ),
                      ),
                      Container(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: TextField(
                          controller: comReg,
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 2,
                              ),
                            ),
                            hintText: getText("Commercialregister"),
                            hintStyle: const TextStyle(fontSize: 12),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 5,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                          left: 10,
                          right: 10,
                        ),
                        child: Image.asset(
                          "assets/Content.png",
                          width: screenWidth * .85,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          {
                            showPickMenu();
                          }
                        },
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 15,
                              left: 10,
                              right: 10,
                            ),
                            child: Image.asset(
                              "assets/upload.png",
                              width: screenWidth * .85,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          for (int i = 0; i < uploadedFiles.length; i++)
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * .07,
                                vertical: 10,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            "assets/file-text.png",
                                            height: 22,
                                          ),
                                          Container(width: 6),
                                          SizedBox(
                                            height: 20,
                                            width: screenWidth * .6,
                                            child: Text(uploadedFiles[i][0]),
                                          ),
                                        ],
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            uploadedFiles.removeAt(i);
                                          });
                                        },
                                        child: Image.asset(
                                          "assets/trash.png",
                                          height: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(color: Colors.grey),
                                ],
                              ),
                            ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 35,
                          horizontal: 20,
                        ),
                        child: InkWell(
                          onTap: () async {
                            if (!buttonLoading) {
                              if (niid.text.trim().isEmpty) {
                                snackBar(
                                  context,
                                  "please fill the National ID",
                                );
                              } else if (vatNumber.text.trim().isEmpty ||
                                  comReg.text.isEmpty) {
                                snackBar(
                                  context,
                                  "please fill the Vat number and the Commerical register",
                                );
                              } else if (uploadedFiles.isEmpty) {
                                snackBar(
                                  context,
                                  "please upload required files",
                                );
                              } else {
                                String userId = await getUserId();
                                var headers = {
                                  'Cookie':
                                      'PHPSESSID=pkjgl6qfq25j4hvhl359mma1ej',
                                };
                                setState(() {
                                  buttonLoading = true;
                                });
                                int counter = uploadedFiles.length;
                                for (int i = 0; i < uploadedFiles.length; i++) {
                                  var uploadrequest = http.MultipartRequest(
                                    'POST',
                                    Uri.parse('$baseUrl/upload.php'),
                                  );
                                  uploadrequest.fields.addAll({
                                    'subject_id': userId,
                                    'user_id': userId,
                                    'input_secret': input_secret,
                                    'input_key': input_key,
                                  });
                                  uploadrequest.files.add(
                                    await http.MultipartFile.fromPath(
                                      'file',
                                      uploadedFiles[i][1],
                                    ),
                                  );
                                  uploadrequest.headers.addAll(headers);

                                  http.StreamedResponse uploadresponse =
                                      await uploadrequest.send();
                                  String uploadresBody =
                                      await uploadresponse.stream
                                          .bytesToString();

                                  if (uploadresponse.statusCode == 200) {
                                    Map uploaddata = json.decode(uploadresBody);
                                    log(uploaddata.toString());
                                    if (uploaddata["status"] == "success") {
                                      String path = uploaddata["path"];
                                      String document_name =
                                          uploadedFiles[i][0];
                                      counter -= 1;
                                      /////////////////
                                      var requestUpload = http.Request(
                                        'GET',
                                        Uri.parse(
                                          '$baseUrl/upgrade_documents.php?input_key=$input_key&input_secret=$input_secret&user_id=$userId&subject_id=$userId&document_name=$document_name&document_type=1&path=$path&scenario=0&status=0',
                                        ),
                                      );

                                      requestUpload.headers.addAll(headers);

                                      http.StreamedResponse responseUpload =
                                          await requestUpload.send();

                                      // if (responseUpload.statusCode == 200) {
                                      //   Map d = json.decode(await responseUpload
                                      //       .stream
                                      //       .bytesToString());
                                      //   log("////////////new data ///////////$d");
                                      // }
                                      /////////////////
                                      if (counter == 0) {
                                        log("///////////dont uploaded");
                                        var request = http.Request(
                                          'GET',
                                          Uri.parse(
                                            //apprej=0 pending  apprej=2 accepted and 1 for rejected
                                            '$baseUrl/upgrade.php?input_key=$input_key&input_secret=$input_secret&user_id=$userId&subject_id=$userId&apprej=0&NI_id=${niid.text}&STJ_VAT=${vatNumber.text}&STejari=${comReg.text}&firm=${firmName.text}',
                                          ),
                                        );

                                        request.headers.addAll(headers);

                                        http.StreamedResponse response =
                                            await request.send();

                                        if (response.statusCode == 200) {
                                          Map data = json.decode(
                                            await response.stream
                                                .bytesToString(),
                                          );
                                          log(data.toString());
                                          if (data["status"] == "success") {
                                            setFirmName(firmName.text);
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) =>
                                                        const SuccessReceivedRequest(),
                                              ),
                                              (route) => false,
                                            );
                                          } else {
                                            snackBar(
                                              context,
                                              uploaddata["message"].toString(),
                                            );
                                            setState(() {
                                              buttonLoading = false;
                                            });
                                          }
                                        } else {
                                          snackBar(context, "error");
                                          setState(() {
                                            buttonLoading = false;
                                          });
                                        }
                                      }
                                    } else {
                                      // ignore: use_build_context_synchronously
                                      snackBar(
                                        context,
                                        "ERROR please try again",
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
                          child: Container(
                            height: 35,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: orange,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child:
                                  buttonLoading
                                      ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      )
                                      : Text(
                                        getText("Continue"),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
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
            ],
          ),
        ),
      ),
    );
  }

  void showPickMenu() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Directionality(
          textDirection:
              language == "0" ? TextDirection.ltr : TextDirection.rtl,
          child: SizedBox(
            height: MediaQuery.of(context).viewInsets.bottom + 210,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 6, bottom: 4),
                        child: Text(
                          getText("message38"),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        getText("message39"),
                        style: TextStyle(color: greyc, fontSize: 11),
                      ),
                      InkWell(
                        onTap: () async {
                          Navigator.pop(context);
                          FilePickerResult? result = await FilePicker.platform
                              .pickFiles(
                                type: FileType.custom,
                                allowedExtensions: ['pdf'],
                              );

                          if (result != null) {
                            if (result.files.single.path!
                                    .split('.')
                                    .last
                                    .toLowerCase() ==
                                "pdf") {
                              String fileName = result.files.single.name;

                              String filePath = result.files.single.path!;

                              setState(() {
                                uploadedFiles.add([fileName, filePath]);
                              });
                            } else {
                              snackBar(context, getText("message51"));
                            }
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                              color: greyc.withOpacity(.3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    getText("message52"),
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                  Image.asset(
                                    "assets/file-text.png",
                                    height: 22,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          Navigator.pop(context);
                          final picker = ImagePicker();
                          final pickedFile = await picker.pickImage(
                            source: ImageSource.gallery,
                          );

                          if (pickedFile != null) {
                            String fileExtension =
                                pickedFile.path.split('.').last.toLowerCase();
                            if (fileExtension == 'png' ||
                                fileExtension == 'jpeg' ||
                                fileExtension == 'jpg' ||
                                fileExtension == 'gif') {
                              setState(() {
                                uploadedFiles.add([
                                  pickedFile.name,
                                  pickedFile.path,
                                ]);
                              });
                            } else {
                              snackBar(context, getText("message53"));
                            }
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                              color: greyc.withOpacity(.3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    getText("message54"),
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                  Image.asset("assets/Group.png", height: 22),
                                ],
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
}
