// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../controller/language.dart';
import '../../notification/notifications.dart';
import '/controller/textstyle.dart';
import 'package:http/http.dart' as http;
import '/model/category.dart';
import '/view/merchant/mainMerchentPage.dart';
import 'package:provider/provider.dart';
import '../../../controller/no_imternet.dart';
import '../../../controller/provider.dart';
import '../../../controller/var.dart';
import '../../../model/store_item.dart';

class MarchantShop extends StatefulWidget {
  final bool isEditing;
  const MarchantShop({super.key, required this.isEditing});

  @override
  State<MarchantShop> createState() => _MarchantShopState();
}

class _MarchantShopState extends State<MarchantShop> {
  int currentCatIndex = 0;
  int currentSubCatIndex = 0;
  List<StoreItem> storeItems = [];
  bool isEditing = false;
  bool isLoading = true;
  bool isLoading2 = true;
  bool activeDiscount = false;
  int discounttype = 0;
  double discountValue = 0;
  int appliedOn = 0;
  int filterIndex = 0;
  List<Category> filteredCat = categories;
  TextEditingController disValue = TextEditingController();

  @override
  void initState() {
    getDiscountActive();
    getdata();
    getStoreData();
    super.initState();
  }

  getdata() async {
    var headers = {'Cookie': 'PHPSESSID=pkjgl6qfq25j4hvhl359mma1ej'};
    try {
      var request = http.Request(
        'GET',
        Uri.parse(
          '$baseUrl/products.php?input_key=$input_key&input_secret=$input_secret',
        ),
      );

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        try {
          Map data = json.decode(await response.stream.bytesToString());

          fillData(language == "0" ? data["en"] : data["ar"]);
          setState(() {
            isLoading2 = false;
          });
        } catch (_) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const NoInternet()),
            (route) => false,
          );
        }
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const NoInternet()),
          (route) => false,
        );
      }
    } catch (_) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const NoInternet()),
        (route) => false,
      );
    }
  }

  getDiscountActive() async {
    var request = http.Request(
      'GET',
      Uri.parse(
        '$baseUrl/discount_store.php?input_key=$input_key&input_secret=$input_secret&STejari=$sTejariValue&min_value=0&max_value=0&discount_type=0&applied_on=0&discount_value=0&new_value=0',
      ),
    );

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      Map data = json.decode(await response.stream.bytesToString());
      String applied = data["data"]["applied_on"];
      discounttype = int.parse(data["data"]["discount_type"]);
      discountValue = double.parse(data["data"]["discount_value"]);
      appliedOn = int.parse(applied);

      Provider.of<MyProvider>(
        context,
        listen: false,
      ).setradioDiscountValue(discounttype);
      Provider.of<MyProvider>(
        context,
        listen: false,
      ).setappliedDiscountOn(appliedOn != 1 && appliedOn != 2 ? 1 : appliedOn);
      disValue.text = discountValue.toString();
      if (applied != "0") {
        setState(() {
          activeDiscount = true;
        });
      }
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const NoInternet()),
        (route) => false,
      );
    }
  }

  Future getStoreData() async {
    isEditing = widget.isEditing;

    var request = http.Request(
      'GET',
      Uri.parse(
        '$baseUrl/store.php?input_key=$input_key&input_secret=$input_secret&STejari=$sTejariValue&p_idx=1&price=750&min_value=200&max_value=400&discount=5&dis_type=0&sent_variable=3',
      ),
    );

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      Map data = json.decode(await response.stream.bytesToString());
      /////////////////////
      //back here

      List myList = data["data"]["adjusted_json"];
      for (int catIndex = 0; catIndex < categories.length; catIndex++) {
        for (
          int subIndex = 0;
          subIndex < categories[catIndex].subCategory.length;
          subIndex++
        ) {
          for (
            int prodIndex = 0;
            prodIndex <
                categories[catIndex].subCategory[subIndex].products.length;
            prodIndex++
          ) {
            for (var dataelement in myList) {
              if (dataelement["p_idx"] ==
                  categories[catIndex]
                      .subCategory[subIndex]
                      .products[prodIndex]
                      .productIdx) {
                //edit store items data
                StoreItem storeItem = StoreItem(
                  STejari: dataelement["STejari"],
                  p_idx: dataelement["p_idx"],
                  discount_type: dataelement["discount_type"],
                  applied_on: dataelement["applied_on"],
                  original_price: dataelement["original_price"],
                  adjusted_price: dataelement["adjusted_price"].toString(),
                  discounted_value: dataelement["discounted_value"],
                  discount_status: dataelement["discount_status"],
                );
                categories[catIndex]
                    .subCategory[subIndex]
                    .products[prodIndex]
                    .isItMyProduct = true;
                categories[catIndex]
                    .subCategory[subIndex]
                    .products[prodIndex]
                    .storeItem = storeItem;
              }
            }
          }
        }
      }

      setState(() {
        filteredCat = categories;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          isLoading || isLoading2
              ? Center(child: CircularProgressIndicator(color: orange))
              : Directionality(
                textDirection:
                    language == "0" ? TextDirection.ltr : TextDirection.rtl,
                child: Stack(
                  children: [
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        gradient: gradient,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Image.asset("assets/Logo Shape.png", width: 150),
                          SafeArea(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: isEditing ? 2 : 0,
                                horizontal: 6,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                    "          ${getText("Store")}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        child: Align(
                                          alignment: Alignment.topCenter,
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (context) =>
                                                          const NotificationPage(),
                                                ),
                                              );
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
                                                            BorderRadius.circular(
                                                              100,
                                                            ),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          unSeenNotiNum
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                fontSize: 10,
                                                                color:
                                                                    Colors
                                                                        .white,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      isEditing
                                          ? const SizedBox(width: 22)
                                          : InkWell(
                                            onTap: () {
                                              setState(() {
                                                isEditing = true;
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Image.asset(
                                                "assets/edit.png",
                                                height: 22,
                                              ),
                                            ),
                                          ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: Platform.isIOS ? 100 : 68),
                      child: Container(
                        height: screenHeight,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView(
                                  padding: EdgeInsets.zero,
                                  children: [
                                    isEditing
                                        ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              _showDiscountPopupMenu(false);
                                            },
                                            child: Container(
                                              height: 60,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                gradient: LinearGradient(
                                                  begin: Alignment.topRight,
                                                  end: Alignment.bottomLeft,
                                                  colors: [
                                                    activeDiscount
                                                        ? orange
                                                        : const Color(
                                                          0xffB8B8B8,
                                                        ).withOpacity(.5),
                                                    activeDiscount
                                                        ? orange
                                                        : const Color(
                                                          0xffB8B8B8,
                                                        ).withOpacity(.5),
                                                    activeDiscount
                                                        ? yellow
                                                        : const Color(
                                                          0xffB8B8B8,
                                                        ).withOpacity(.5),
                                                  ],
                                                ),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  8.0,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Image.asset(
                                                          "assets/discount-alt.png",
                                                          color:
                                                              activeDiscount
                                                                  ? Colors.white
                                                                  : orange,
                                                          height: 33,
                                                        ),
                                                        Container(width: 10),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              getText(
                                                                "DiscountOffers",
                                                              ),
                                                              style: TextStyle(
                                                                fontSize: 13,
                                                                color:
                                                                    activeDiscount
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            Text(
                                                              appliedOn == 1
                                                                  ? getText(
                                                                    "message66",
                                                                  )
                                                                  : appliedOn ==
                                                                      2
                                                                  ? getText(
                                                                    "message67",
                                                                  )
                                                                  : getText(
                                                                    "message68",
                                                                  ),
                                                              style: TextStyle(
                                                                fontSize: 11,
                                                                color:
                                                                    activeDiscount
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .grey,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    InkWell(
                                                      onTap: () async {
                                                        if (!activeDiscount) {
                                                          _showDiscountPopupMenu(
                                                            false,
                                                          );
                                                        } else {
                                                          var request =
                                                              http.Request(
                                                                'GET',
                                                                Uri.parse(
                                                                  '$baseUrl/discount_store.php?input_key=$input_key&input_secret=$input_secret&STejari=$sTejariValue&min_value=0&max_value=0&discount_type=0&applied_on=0&discount_value=0&new_value=1',
                                                                ),
                                                              );

                                                          http.StreamedResponse
                                                          response =
                                                              await request
                                                                  .send();
                                                          if (response
                                                                  .statusCode ==
                                                              200) {
                                                            var re =
                                                                await response
                                                                    .stream
                                                                    .bytesToString();
                                                            log(
                                                              "////////////////",
                                                            );
                                                            log(re);
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
                                                              (route) => false,
                                                            );
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (
                                                                      context,
                                                                    ) => const MarchantShop(
                                                                      isEditing:
                                                                          true,
                                                                    ),
                                                              ),
                                                            );

                                                            snackBar(
                                                              context,
                                                              "تم التعديل بنجاح",
                                                            );
                                                          } else {
                                                            Navigator.pushAndRemoveUntil(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const NoInternet(),
                                                              ),
                                                              (route) => false,
                                                            );
                                                          }
                                                        }
                                                      },
                                                      child: Container(
                                                        child:
                                                            activeDiscount
                                                                ? Image.asset(
                                                                  "assets/SwitchActive.png",
                                                                  height: 28,
                                                                )
                                                                : Image.asset(
                                                                  "assets/SwitchDeActive.png",
                                                                  height: 28,
                                                                ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                        : Container(),
                                    Text(
                                      getText("MainCategories"),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(
                                      width: screenWidth,
                                      height: 100,
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: [
                                          for (
                                            int i = 0;
                                            i < filteredCat.length;
                                            i++
                                          )
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 16,
                                                    horizontal: 8,
                                                  ),
                                              child: categoryItem(i),
                                            ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      getText("SubCategories"),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(
                                      width: screenWidth,
                                      height: 53,
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        padding: EdgeInsets.zero,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 13,
                                              horizontal: 5,
                                            ),
                                            child: subCategoryItem(-1),
                                          ),
                                          for (
                                            int i = 0;
                                            i <
                                                filteredCat[currentCatIndex]
                                                    .subCategory
                                                    .length;
                                            i++
                                          )
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 13,
                                                    horizontal: 5,
                                                  ),
                                              child: subCategoryItem(i),
                                            ),
                                        ],
                                      ),
                                    ),
                                    Container(height: 4),
                                    currentSubCatIndex == -1
                                        ? getAllMainProducts()
                                        : Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 5,
                                          ),
                                          child: SizedBox(
                                            child: GridView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              padding: EdgeInsets.zero,
                                              itemCount:
                                                  filteredCat[currentCatIndex]
                                                      .subCategory[currentSubCatIndex]
                                                      .products
                                                      .length,
                                              gridDelegate:
                                                  SliverGridDelegateWithMaxCrossAxisExtent(
                                                    //  crossAxisCount: 2
                                                    maxCrossAxisExtent:
                                                        screenWidth / 2,
                                                    mainAxisExtent:
                                                        isEditing ? 225 : 155,
                                                    mainAxisSpacing: 15,
                                                    crossAxisSpacing: 25,
                                                  ),
                                              itemBuilder: (context, index) {
                                                return subItem(
                                                  index,
                                                  currentSubCatIndex,
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                  ],
                                ),
                              ),
                              isEditing
                                  ? Container()
                                  : InkWell(
                                    onTap: () {
                                      setState(() {
                                        isEditing = true;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Container(
                                        height: 35,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: orange,
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            getText("Managetore"),
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
                  ],
                ),
              ),
    );
  }

  Widget getAllMainProducts() {
    List subIndexes = [];

    for (int i = 0; i < filteredCat[currentCatIndex].subCategory.length; i++) {
      for (
        int u = 0;
        u < filteredCat[currentCatIndex].subCategory[i].products.length;
        u++
      ) {
        subIndexes.add(i);
      }
    }
    int realindex = -1;
    int curSub = -1;
    return SizedBox(
      height: screenHeight - 100,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SizedBox(
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: subIndexes.length,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              //  crossAxisCount: 2
              maxCrossAxisExtent: screenWidth / 2,
              mainAxisExtent: isEditing ? 225 : 150,
              mainAxisSpacing: 15,
              crossAxisSpacing: 25,
            ),
            itemBuilder: (context, index) {
              if (curSub != subIndexes[index]) {
                realindex = 0;
              } else {
                realindex++;
              }
              curSub = subIndexes[index];
              return subItem(realindex, subIndexes[index]);
            },
          ),
        ),
      ),
    );
  }

  Widget categoryItem(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          currentCatIndex = index;
          currentSubCatIndex = 0;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 37,
            width: 37,
            decoration: BoxDecoration(
              color:
                  currentCatIndex == index ? orange : const Color(0xffF7F7F7),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Padding(
              padding: const EdgeInsets.all(9),
              child: Image.network(filteredCat[index].image),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: SizedBox(
              width: 60,
              height: 25,
              child: Text(
                filteredCat[index].name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: currentCatIndex == index ? orange : Colors.black,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget subCategoryItem(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          currentSubCatIndex = index;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: currentSubCatIndex == index ? orange : Colors.white,
          border: Border.all(
            color:
                currentSubCatIndex == index
                    ? orange
                    : const Color.fromARGB(255, 194, 194, 194),
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              index == -1
                  ? getText("All")
                  : filteredCat[currentCatIndex].subCategory[index].name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color:
                    currentSubCatIndex == index ? Colors.white : Colors.black45,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget subItem(int index, int subIndex) {
    bool isMyProduct =
        filteredCat[currentCatIndex]
            .subCategory[subIndex]
            .products[index]
            .isItMyProduct;
    StoreItem storeData =
        filteredCat[currentCatIndex]
            .subCategory[subIndex]
            .products[index]
            .storeItem ??
        StoreItem(
          STejari: "",
          p_idx: "1",
          discount_type: "0",
          applied_on: "0",
          original_price: "0",
          adjusted_price: "0",
          discounted_value: "0",
          discount_status: "0",
        );
    return Stack(
      children: [
        InkWell(
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: const Color.fromARGB(255, 198, 198, 198),
              ),
            ),
            child: Stack(
              children: [
                Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(
                                  filteredCat[currentCatIndex]
                                      .subCategory[subIndex]
                                      .products[index]
                                      .image,
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        Container(height: 4),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 2,
                          ),
                          child: Align(
                            alignment:
                                language == "0"
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                            child: Text(
                              filteredCat[currentCatIndex]
                                  .subCategory[subIndex]
                                  .products[index]
                                  .name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                        isEditing
                            ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 0,
                                  ),
                                  child: Text(
                                    getText("Price"),
                                    style: TextStyle(
                                      color: orange,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                storeData.discounted_value != "0" &&
                                        storeData.discounted_value != "0.0"
                                    ? Padding(
                                      padding: const EdgeInsets.only(
                                        top: 5,
                                        left: 6,
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            "${storeData.original_price} ${getText("SR")}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              fontSize: 11,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 0,
                                              left: 6,
                                            ),
                                            child: Text(
                                              " -${storeData.discounted_value} ",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                    : Container(height: 5),
                                Padding(
                                  padding: const EdgeInsets.only(left: 6),
                                  child: Text(
                                    "${storeData.adjusted_price} ${getText("SR")}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        _showEditPopupMenu(index, subIndex);
                                      },
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "assets/edit.png",
                                            color: Colors.grey,
                                            height: 18,
                                          ),
                                          Text(
                                            getText("Edit"),
                                            style: const TextStyle(
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return CupertinoAlertDialog(
                                              title: const Icon(
                                                Icons.warning_amber_outlined,
                                                size: 35,
                                              ),
                                              content: const Text(
                                                "\nهل انت متاكد من حذف العنصر",
                                                style: TextStyle(fontSize: 13),
                                              ),
                                              actions: <Widget>[
                                                CupertinoDialogAction(
                                                  child: const Text('نعم'),
                                                  onPressed: () async {
                                                    String productIndex =
                                                        filteredCat[currentCatIndex]
                                                            .subCategory[subIndex]
                                                            .products[index]
                                                            .productIdx;

                                                    var request = http.Request(
                                                      'GET',
                                                      Uri.parse(
                                                        '$baseUrl/store.php?input_key=$input_key&input_secret=$input_secret&STejari=$sTejariValue&p_idx=$productIndex&price=750&min_value=200&max_value=400&discount=5&dis_type=0&sent_variable=0',
                                                      ),
                                                    );

                                                    http.StreamedResponse
                                                    response =
                                                        await request.send();
                                                    if (response.statusCode ==
                                                        200) {
                                                      Navigator.pushAndRemoveUntil(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder:
                                                              (context) =>
                                                                  const MainMerchantPage(
                                                                    pageindex:
                                                                        0,
                                                                  ),
                                                        ),
                                                        (route) => false,
                                                      );
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder:
                                                              (context) =>
                                                                  const MarchantShop(
                                                                    isEditing:
                                                                        true,
                                                                  ),
                                                        ),
                                                      );
                                                      snackBar(
                                                        context,
                                                        "تم الحذف بنجاح",
                                                      );
                                                    } else {
                                                      Navigator.pushAndRemoveUntil(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder:
                                                              (context) =>
                                                                  const NoInternet(),
                                                        ),
                                                        (route) => false,
                                                      );
                                                    }
                                                  },
                                                ),
                                                CupertinoDialogAction(
                                                  child: const Text('لا'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "assets/trash.png",
                                            height: 12,
                                          ),
                                          Text(
                                            getText("Delete"),
                                            style: const TextStyle(
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                            : Text(
                              "  ${filteredCat[currentCatIndex].subCategory[subIndex].products[index].storeItem?.adjusted_price ?? "0.00"} ${getText("SR")}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: orange,
                                fontSize: 11,
                              ),
                            ),
                      ],
                    ),
                    isEditing && isMyProduct
                        ? Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              bottom: 13,
                              right: 4,
                              top: 88,
                            ),
                            child: Image.asset(
                              "assets/check-circle.png",
                              height: 20,
                            ),
                          ),
                        )
                        : Container(),
                  ],
                ),
                isEditing
                    ? InkWell(
                      onTap: () async {
                        String prodInd =
                            filteredCat[currentCatIndex]
                                .subCategory[subIndex]
                                .products[index]
                                .productIdx;
                        if (isMyProduct) {
                          if (storeData.discount_status == "1") {
                            storeData.discount_status = "0";
                          } else {
                            storeData.discount_status = "1";
                          }

                          var request2 = http.Request(
                            'GET',
                            Uri.parse(
                              '$baseUrl/store.php?input_key=$input_key&input_secret=$input_secret&STejari=$sTejariValue&p_idx=$prodInd&price=${storeData.original_price}&min_value=0&max_value=0&discount=${storeData.discounted_value}&dis_type=${storeData.discount_type}&discount_status=${storeData.discount_status}&sent_variable=1',
                            ),
                          );

                          http.StreamedResponse response2 =
                              await request2.send();
                          if (response2.statusCode == 200) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        const MainMerchantPage(pageindex: 0),
                              ),
                              (route) => false,
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        const MarchantShop(isEditing: true),
                              ),
                            );
                            snackBar(context, "تم التعديل بنجاح");
                          } else {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NoInternet(),
                              ),
                              (route) => false,
                            );
                          }
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: Image.asset(
                          isMyProduct && storeData.discount_status == "1"
                              ? "assets/discount-fill.png"
                              : "assets/discount-alt.png",
                          height: 22,
                        ),
                      ),
                    )
                    : Container(),
              ],
            ),
          ),
        ),
        isMyProduct && isEditing
            ? Container()
            : InkWell(
              onTap: () {
                if (isEditing) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CupertinoAlertDialog(
                        title: const Icon(
                          Icons.warning_amber_outlined,
                          size: 35,
                        ),
                        content: const Text(
                          "\nهل تريد اضافة هذا العنصر الى متجرك",
                          style: TextStyle(fontSize: 16),
                        ),
                        actions: <Widget>[
                          CupertinoDialogAction(
                            child: const Text('نعم'),
                            onPressed: () async {
                              String productIndex =
                                  filteredCat[currentCatIndex]
                                      .subCategory[subIndex]
                                      .products[index]
                                      .productIdx;

                              var request = http.Request(
                                'GET',
                                Uri.parse(
                                  '$baseUrl/store.php?input_key=$input_key&input_secret=$input_secret&STejari=$sTejariValue&p_idx=$productIndex&price=200&min_value=0&max_value=0&discount=0&dis_type=0&discount_status=0&sent_variable=1',
                                ),
                              );

                              http.StreamedResponse response =
                                  await request.send();
                              if (response.statusCode == 200) {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => const MainMerchantPage(
                                          pageindex: 0,
                                        ),
                                  ),
                                  (route) => false,
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            const MarchantShop(isEditing: true),
                                  ),
                                );
                                snackBar(context, "تم الاضافة بنجاح");
                              } else {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const NoInternet(),
                                  ),
                                  (route) => false,
                                );
                              }
                            },
                          ),
                          CupertinoDialogAction(
                            child: const Text('لا'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Container(
                color:
                    !isMyProduct && isEditing
                        ? const Color.fromARGB(
                          255,
                          235,
                          235,
                          235,
                        ).withOpacity(.5)
                        : Colors.white.withOpacity(0),
              ),
            ),
      ],
    );
  }

  void _showDiscountPopupMenu(bool isEditing) {
    //  TextEditingController minValue = TextEditingController();
    // TextEditingController maxValue = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Directionality(
          textDirection:
              language == "0" ? TextDirection.ltr : TextDirection.rtl,
          child: SizedBox(
            height: MediaQuery.of(context).viewInsets.bottom + 480,
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
                          getText("DiscountOffers"),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          getText("message58"),
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color.fromARGB(255, 147, 147, 147),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 6, bottom: 6),
                        child: Text(
                          getText("message59"),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Radio(
                            value: 0,
                            groupValue:
                                Provider.of<MyProvider>(
                                  context,
                                ).getradioDiscountValue(),
                            activeColor: orange,
                            onChanged: (int? x) {
                              Provider.of<MyProvider>(
                                context,
                                listen: false,
                              ).setradioDiscountValue(x!);
                            },
                          ),
                          Text(
                            getText("Persent"),
                            style: const TextStyle(fontSize: 11),
                          ),
                          Expanded(child: Container()),
                          Radio(
                            value: 1,
                            groupValue:
                                Provider.of<MyProvider>(
                                  context,
                                ).getradioDiscountValue(),
                            activeColor: orange,
                            onChanged: (int? x) {
                              Provider.of<MyProvider>(
                                context,
                                listen: false,
                              ).setradioDiscountValue(x!);
                            },
                          ),
                          Text(
                            getText("Value"),
                            style: const TextStyle(fontSize: 11),
                          ),
                          Expanded(child: Container()),
                        ],
                      ),
                      Container(height: 10),
                      Text(
                        getText("Persent"),
                        style: TextStyle(
                          color: orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        controller: disValue,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      Container(height: 12),
                      /* Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Minimum Vlaue",
                                  style: TextStyle(
                                      color: orange, fontWeight: FontWeight.bold),
                                ),
                                TextField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  controller: minValue,
                                  decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.zero),
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: 30,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Maximum Vlaue",
                                  style: TextStyle(
                                      color: orange, fontWeight: FontWeight.bold),
                                ),
                                TextField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  controller: maxValue,
                                  decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.zero),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                     */
                      isEditing
                          ? Container()
                          : Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 8),
                            child: Text(
                              getText("message60"),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                      isEditing
                          ? Container()
                          : Row(
                            children: [
                              Radio(
                                value: 1,
                                groupValue:
                                    Provider.of<MyProvider>(
                                      context,
                                    ).getrappliedDiscountOn(),
                                activeColor: orange,
                                onChanged: (int? x) {
                                  Provider.of<MyProvider>(
                                    context,
                                    listen: false,
                                  ).setappliedDiscountOn(x!);
                                },
                              ),
                              Text(
                                getText("message61"),
                                style: const TextStyle(fontSize: 11),
                              ),
                              Expanded(child: Container()),
                              Radio(
                                value: 2,
                                groupValue:
                                    Provider.of<MyProvider>(
                                      context,
                                    ).getrappliedDiscountOn(),
                                activeColor: orange,
                                onChanged: (int? x) {
                                  Provider.of<MyProvider>(
                                    context,
                                    listen: false,
                                  ).setappliedDiscountOn(x!);
                                },
                              ),
                              Text(
                                getText("message62"),
                                style: const TextStyle(fontSize: 11),
                              ),
                              Expanded(child: Container()),
                            ],
                          ),
                      Container(height: 15),
                      InkWell(
                        onTap: () async {
                          if (double.parse(disValue.text.trim()) <= 0) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CupertinoAlertDialog(
                                  title: const Icon(
                                    Icons.warning_amber_outlined,
                                    size: 35,
                                  ),
                                  content: const Text(
                                    "لم يتم ادخال قيمة الخصم بعد",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  actions: <Widget>[
                                    CupertinoDialogAction(
                                      child: const Text('حسنا'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            int discount_type =
                                Provider.of<MyProvider>(
                                  context,
                                  listen: false,
                                ).getradioDiscountValue();
                            int applied_on =
                                Provider.of<MyProvider>(
                                  context,
                                  listen: false,
                                ).getrappliedDiscountOn();
                            String discount_value = disValue.text;

                            var request = http.Request(
                              'GET',
                              Uri.parse(
                                '$baseUrl/discount_store.php?input_key=$input_key&input_secret=$input_secret&STejari=$sTejariValue&min_value=0&max_value=0&discount_type=$discount_type&applied_on=$applied_on&discount_value=$discount_value&new_value=1',
                              ),
                            );

                            http.StreamedResponse response =
                                await request.send();
                            if (response.statusCode == 200) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          const MainMerchantPage(pageindex: 0),
                                ),
                                (route) => false,
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          const MarchantShop(isEditing: true),
                                ),
                              );
                              snackBar(context, "تم التعديل بنجاح");
                            } else {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const NoInternet(),
                                ),
                                (route) => false,
                              );
                            }
                          }
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
                            child: Center(
                              child: Text(
                                getText("message63"),
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
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(5),
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
                                getText("Cancel"),
                                style: TextStyle(
                                  color: orange,
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

  void _showEditPopupMenu(int prodIndex, int subIndex) {
    TextEditingController newPrice = TextEditingController();
    StoreItem itemData =
        filteredCat[currentCatIndex]
            .subCategory[subIndex]
            .products[prodIndex]
            .storeItem ??
        StoreItem(
          STejari: "",
          p_idx: "1",
          discount_type: "0",
          applied_on: "0",
          original_price: "0",
          adjusted_price: "0",
          discounted_value: "0",
          discount_status: "0",
        );
    String productIndex =
        filteredCat[currentCatIndex]
            .subCategory[subIndex]
            .products[prodIndex]
            .productIdx;

    newPrice.text = itemData.original_price;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Directionality(
          textDirection:
              language == "0" ? TextDirection.ltr : TextDirection.rtl,
          child: SizedBox(
            height: MediaQuery.of(context).viewInsets.bottom + 280,
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
                          getText("Edit"),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          getText("message64"),
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color.fromARGB(255, 147, 147, 147),
                          ),
                        ),
                      ),
                      Container(height: 10),
                      Text(
                        getText("message65"),
                        style: TextStyle(
                          color: orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                      TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        controller: newPrice,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      Container(height: 15),
                      InkWell(
                        onTap: () async {
                          var request2 = http.Request(
                            'GET',
                            Uri.parse(
                              '$baseUrl/store.php?input_key=$input_key&input_secret=$input_secret&STejari=$sTejariValue&p_idx=$productIndex&price=${newPrice.text}&min_value=0&max_value=0&discount=${itemData.discounted_value}&dis_type=${itemData.discount_type}&discount_status=${itemData.discount_status}&sent_variable=1',
                            ),
                          );

                          http.StreamedResponse response2 =
                              await request2.send();
                          if (response2.statusCode == 200) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        const MainMerchantPage(pageindex: 0),
                              ),
                              (route) => false,
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        const MarchantShop(isEditing: true),
                              ),
                            );
                            snackBar(context, "تم التعديل بنجاح");
                          } else {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NoInternet(),
                              ),
                              (route) => false,
                            );
                          }
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
                            child: Center(
                              child: Text(
                                getText("Apply"),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(5),
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
                                getText("Cancel"),
                                style: TextStyle(
                                  color: orange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
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

  /*
  void _showFilterPopupMenu() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).viewInsets.bottom + 220,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 6, bottom: 18),
                      child: Text(
                        "Filter",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            filteredCat = categories;
                            filterIndex = 0;
                          });
                          Navigator.pop(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "All items",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            filterIndex == 0
                                ? Image.asset(
                                    "assets/check.png",
                                    height: 17,
                                  )
                                : Container()
                          ],
                        ),
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: InkWell(
                        onTap: () {
                          /*for (var element in filteredCat) {
                            for (var sub in element.subCategory) {
                              for (var product in sub.products) {
                                if (!product.isItMyProduct) {
                                  sub.products.remove(product);
                                }
                              }
                            }
                          }*/
                          setState(() {
                            filteredCat = [categories[0]];
                            filterIndex = 1;
                          });

                          Navigator.pop(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Store items",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            filterIndex == 1
                                ? Image.asset(
                                    "assets/check.png",
                                    height: 17,
                                  )
                                : Container()
                          ],
                        ),
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            filterIndex = 2;
                          });
                          Navigator.pop(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "New items",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            filterIndex == 2
                                ? Image.asset(
                                    "assets/check.png",
                                    height: 17,
                                  )
                                : Container()
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 20,
                    ), /*
                    InkWell(
                      onTap: () async {},
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Container(
                          height: 40,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: orange,
                              borderRadius: BorderRadius.circular(5)),
                          child: const Center(
                            child: Text(
                              "Apply Discount",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ),
                  */
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
*/
}
