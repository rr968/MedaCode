// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/model/category.dart';
import '/model/latest_order.dart';
import '/model/offers.dart';
import '/model/product.dart';
import '/model/sub_category.dart';
import '../model/merchant_ordars.dart';

double currentAndroidVersion = 1.3;
double currentIOSVersion = 1.3;
String? notificationToken;
late double screenWidth;
late double screenHeight;
double figmaWidth = 393;
double figmaHeight = 852;
double widthFactor = screenWidth / figmaWidth;
double heightFactor = screenHeight / figmaHeight;
//"0" mean en "1" mean arabic
List<String> favListIndexes = [];
String points = "0";
String language = "0";
String userName = "    ";
String firmName = "    ";
String firmPhoto = "    ";
String userPhoto = "    ";
String merchantAccountStatus =
    "-1"; //-1 there is no request -- 0 pending -- 1 rejected --2 accepted
bool isUserNow = true;

List<MerchantOrdersClass> merchantOrders = [];
List<Category> categories = [];
List<LatestOrder> latestOrder = [];
List<Offers> offers = [];
Color yellow = const Color(0xffFEC302);
Color deepOrange = const Color(0xffFF6100);
Color orange = const Color(0xffEF8B35);
Color greyc = const Color(0xffCFCFCF);
String token = "";
String baseUrl = "https://bxhxjdbfhxjxjdjdjdbxjcuucksnehfj.solutions/meda";
String input_key = "cr3cr3cc3ec3cFEWRCTVR34324c@xcwe3243";
String input_secret = "fmciofnirofmRCCFEDcfr@5342323CFWC";
LatLong? latLng;
List<String> citiesMerchantFilter = [];
int unSeenNotiNum = 0;
String sTejariValue = "0";

snackBar(context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

setFSM(bool id) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setBool("FSM", id);
}

Future<bool> getFSM() async {
  SharedPreferences pref = await SharedPreferences.getInstance();

  return pref.getBool("FSM") ?? false;
}

setUserId(String id) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString("UserId", id);
}

Future<String> getUserId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();

  return pref.getString("UserId") ?? "";
}

setToken(String tokenValue) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString("token", tokenValue);
  token = tokenValue;
}

setUserName(String name) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString("userName", name);
}

setUserphone(String phone) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString("Userphone", phone);
}

setUserpassword(String pass) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString("Userpassword", pass);
}

Future<String> getUserName() async {
  SharedPreferences pref = await SharedPreferences.getInstance();

  return pref.getString("userName") ?? "";
}

////////////////////////
setUserEmail(String email) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString("UserEmail", email);
}

Future<String> getUserEmail() async {
  SharedPreferences pref = await SharedPreferences.getInstance();

  return pref.getString("UserEmail") ?? "";
}

///////////////////////
////////////////////////
setUserPhoto(String UserPhoto) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString("UserPhoto", UserPhoto);
}

Future<String> getUserPhoto() async {
  SharedPreferences pref = await SharedPreferences.getInstance();

  return pref.getString("UserPhoto") ?? "";
}

///////////////////////
////////////////////////
setFirmPhoto(String FirmPhoto) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString("FirmPhoto", FirmPhoto);
}

Future<String> getFirmPhoto() async {
  SharedPreferences pref = await SharedPreferences.getInstance();

  return pref.getString("FirmPhoto") ?? "";
}

///////////////////////
////////////////////////
setFirmName(String FirmName) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString("FirmName", FirmName);
}

Future<String> getFirmName() async {
  SharedPreferences pref = await SharedPreferences.getInstance();

  return pref.getString("FirmName") ?? "";
}
///////////////////////

Future<String> getUserphone() async {
  SharedPreferences pref = await SharedPreferences.getInstance();

  return pref.getString("Userphone") ?? "";
}

Future<String> getUserpassword() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString("Userpassword") ?? "";
}

////////////////////////
setLanguage(String l) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString("Language", l);
}

Future<String> getLanguage() async {
  SharedPreferences pref = await SharedPreferences.getInstance();

  return pref.getString("Language") ?? "0";
}

///////////////////////
fillData(List data) {
  categories = [];
  for (var element in data) {
    List<SubCategory> subcat = [];
    element["sub_categories"].forEach((key, value) {
      List<Product> products = [];
      List productsData = value['products'];

      for (var productData in productsData) {
        String productName = productData['name'].toString();
        String productIdx = productData['product_idx'].toString();
        String productDescription = productData['description'].toString();
        String productImage = productData['image'].toString();
        String productUnit =
            language == "0"
                ? productData['unit'].toString()
                : productData['unit_ar'].toString();

        products.add(
          Product(
            name: productName,
            productIdx: productIdx,
            image: productImage,
            description: productDescription,
            unit: productUnit,
            isItMyProduct: false,
            storeItem: null,
          ),
        );
      }
      subcat.add(SubCategory(key, value["sub_icon"].toString(), products));
    });
    categories.add(
      Category(
        element["category"].toString(),
        element["icon"].toString(),
        subcat,
      ),
    );
    log(categories[categories.length - 1].image);
  }
}

setFavList() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setStringList("FavList", favListIndexes);
}

Future<List<String>> getFavList() async {
  SharedPreferences pref = await SharedPreferences.getInstance();

  return pref.getStringList("FavList") ?? [];
}

List<List<int>> convertStringToList(List<String> arr) {
  List<List<int>> a = [];
  for (var element in arr) {
    List<String> stringArr = element.split(",");
    List<int> a1 = [
      int.parse(stringArr[0]),
      int.parse(stringArr[1]),
      int.parse(stringArr[2]),
    ];
    a.add(a1);
  }
  return a;
}

List<String> sortArray(List<String> arr) {
  List<List<int>> a = convertStringToList(arr);

  // Sort the list of lists based on all values within each sublist
  a.sort((List<int> sublist1, List<int> sublist2) {
    for (int i = 0; i < sublist1.length; i++) {
      if (sublist1[i] != sublist2[i]) {
        return sublist1[i].compareTo(sublist2[i]);
      }
    }
    return 0;
  });
  List<String> finalOutput = [];
  for (var element in a) {
    finalOutput.add("${element[0]},${element[1]},${element[2]}");
  }
  return finalOutput;
}

Future<String> getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  token = pref.getString("token") ?? "";
  return token;
}

getLatestOrder() async {
  var headers = {'Cookie': 'PHPSESSID=1ljp80udb4p4rbib2mgqomsue8'};
  var request = http.Request(
    'GET',
    Uri.parse(
      '$baseUrl/latest_order.php?input_key=$input_key&input_secret=$input_secret',
    ),
  );

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    try {
      List data = json.decode(await response.stream.bytesToString());
      latestOrder = [];
      for (var element in data) {
        latestOrder.add(
          LatestOrder(
            element["category"],
            element["subcategory"],
            element["name"],
            element["quantity"],
            element["price"],
            element["merchant"],
            element["image"],
          ),
        );
      }
    } catch (_) {}
  }
}

getOffers() async {
  var headers = {'Cookie': 'PHPSESSID=1ljp80udb4p4rbib2mgqomsue8'};
  var request = http.Request(
    'GET',
    Uri.parse(
      '$baseUrl/offers.php?input_key=$input_key&input_secret=$input_secret&first=1&last=1000',
    ),
  );

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    try {
      List data = json.decode(await response.stream.bytesToString());
      log(data.toString());

      offers = [];

      for (var element in data) {
        offers.add(
          Offers(
            element["title"],
            element["text"],
            element["status"],
            element["image"],
            element["views"],
            element["link"],
            element["appearance"],
          ),
        );
      }
    } catch (_) {}
  }
}

getPoint() async {
  String userId = await getUserId();

  var headers = {'Cookie': 'PHPSESSID=m11aj8g4uss0tp9d0q53r3o0bh'};
  var request = http.Request(
    'GET',
    Uri.parse(
      '$baseUrl/points.php?input_key=$input_key&input_secret=$input_secret&id=$userId',
    ),
  );

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    try {
      Map data = json.decode(await response.stream.bytesToString());

      if (data.containsKey("total_points")) {
        points = data["total_points"].toString();
      } else {
        points = "0";
      }
    } catch (_) {
      points = "0";
    }
  }
}

Future determinePosition() async {
  try {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return 'Location services are disabled.';
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return 'Location permissions are denied';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return 'Location permissions are permanently denied, we cannot request permissions.';
    }

    var data = await Geolocator.getCurrentPosition();

    return LatLong(data.latitude, data.longitude);
  } catch (e) {}
}

Future<Map?> getAddressFromCoordinates(LatLong? info) async {
  try {
    if (info != null) {
      var request = http.Request(
        'GET',
        Uri.parse(
          '$baseUrl/reverse_address_api.php?input_key=$input_key&input_secret=$input_secret&lat=${info.latitude}&long=${info.longitude}',
        ),
      );

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        Map data = json.decode(await response.stream.bytesToString())["data"];
        log(data.toString());
        return data;
      }
    }
  } catch (_) {}
  return null;
}
