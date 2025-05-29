// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '/controller/head_bar.dart';
import '/controller/no_imternet.dart';
import '/controller/provider.dart';
import '/controller/var.dart';
import '/model/cart_item.dart';
import '/view/cart/cart.dart';
import '../../controller/language.dart';

class SubCategoryScreen extends StatefulWidget {
  int categotyIndex;

  SubCategoryScreen({super.key, required this.categotyIndex});

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  int currentSubCat = 0;
  String currentCategoryIndex = "-1";
  List<TextEditingController> quantityControllers = [];
  List<TextEditingController> labelControllers = [];
  late String level1Id;
  late String level2Id;

  @override
  void initState() {
    level1Id = (Random().nextInt(90000000) + 10000000).toString();
    super.initState();
  }

  @override
  void dispose() {
    for (var controller in quantityControllers) {
      controller.dispose();
    }
    for (var controller in labelControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> selectProduct =
        Provider.of<MyProvider>(
          context,
          listen: true,
        ).getSelectProductIndexes();

    return Scaffold(
      body: Directionality(
        textDirection: language == "0" ? TextDirection.ltr : TextDirection.rtl,
        child: Stack(
          children: [
            HeaderBar(title: categories[widget.categotyIndex].name),
            Padding(
              padding: EdgeInsets.only(top: Platform.isIOS ? 90 : 70),
              child: Container(
                height: screenHeight,
                width: screenWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 2),
                        child: SizedBox(
                          height: 90,
                          width: screenWidth,
                          child: ListView(
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.horizontal,
                            children: [
                              for (
                                int i = 0;
                                i <
                                    categories[widget.categotyIndex]
                                        .subCategory
                                        .length;
                                i++
                              )
                                categoryItem(i),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: SizedBox(
                            child: GridView.builder(
                              padding: EdgeInsets.zero,
                              itemCount:
                                  categories[widget.categotyIndex]
                                      .subCategory[currentSubCat]
                                      .products
                                      .length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    mainAxisSpacing: 12,
                                    crossAxisSpacing: 20,
                                    childAspectRatio: 1,
                                    crossAxisCount: 2,
                                  ),
                              itemBuilder: (context, index) {
                                return subItem(index);
                              },
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _showPopupMenu();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Container(
                            height: 35,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xffF0F0F0),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    getText("Myorders"),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "${selectProduct.length} ${getText("Items")}",
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      decorationColor: orange,
                                      fontWeight: FontWeight.bold,
                                      color: orange,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SafeArea(
                        top: false,
                        child: InkWell(
                          onTap: () {
                            if (Provider.of<MyProvider>(
                              context,
                              listen: false,
                            ).getSelectProductIndexes().isEmpty) {
                              snackBar(context, getText("message12"));
                            } else {
                              _showOrderPopupMenu();
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 16,
                              bottom: 20,
                              left: 10,
                              right: 10,
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
                                  getText("AddItems"),
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

  void _showPopupMenu() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Directionality(
            textDirection:
                language == "0" ? TextDirection.ltr : TextDirection.rtl,
            child: SizedBox(
              height: 500,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 15,
                        bottom: 17,
                        left: 6,
                        right: 6,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            getText("Myorders"),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Provider.of<MyProvider>(
                                context,
                                listen: false,
                              ).setSelectProductIndexes([]);
                              quantityControllers.clear();
                              labelControllers.clear();
                            },
                            child: Text(
                              getText("DeleteAll"),
                              style: TextStyle(
                                color: orange,
                                decoration: TextDecoration.underline,
                                fontSize: 14,
                                decorationColor: orange,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          for (
                            int i = 0;
                            i <
                                Provider.of<MyProvider>(
                                  context,
                                  listen: true,
                                ).getSelectProductIndexes().length;
                            i++
                          )
                            Column(
                              children: [
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start, // Important for vertical alignment
                                  children: [
                                    Container(
                                      height: 45,
                                      width: 45,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: const Color.fromARGB(
                                            255,
                                            181,
                                            181,
                                            181,
                                          ),
                                        ),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            categories[int.parse(
                                                  Provider.of<MyProvider>(
                                                        context,
                                                        listen: true,
                                                      )
                                                      .getSelectProductIndexes()[i]
                                                      .split(",")[0],
                                                )]
                                                .subCategory[int.parse(
                                                  Provider.of<MyProvider>(
                                                        context,
                                                        listen: true,
                                                      )
                                                      .getSelectProductIndexes()[i]
                                                      .split(",")[1],
                                                )]
                                                .products[int.parse(
                                                  Provider.of<MyProvider>(
                                                        context,
                                                        listen: true,
                                                      )
                                                      .getSelectProductIndexes()[i]
                                                      .split(",")[2],
                                                )]
                                                .image,
                                          ),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      // Allow text to take available space and wrap
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            categories[int.parse(
                                                  Provider.of<MyProvider>(
                                                        context,
                                                        listen: true,
                                                      )
                                                      .getSelectProductIndexes()[i]
                                                      .split(",")[0],
                                                )]
                                                .subCategory[int.parse(
                                                  Provider.of<MyProvider>(
                                                        context,
                                                        listen: true,
                                                      )
                                                      .getSelectProductIndexes()[i]
                                                      .split(",")[1],
                                                )]
                                                .products[int.parse(
                                                  Provider.of<MyProvider>(
                                                        context,
                                                        listen: true,
                                                      )
                                                      .getSelectProductIndexes()[i]
                                                      .split(",")[2],
                                                )]
                                                .name,
                                            textAlign: TextAlign.start,
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            categories[int.parse(
                                                  Provider.of<MyProvider>(
                                                        context,
                                                        listen: true,
                                                      )
                                                      .getSelectProductIndexes()[i]
                                                      .split(",")[0],
                                                )]
                                                .subCategory[int.parse(
                                                  Provider.of<MyProvider>(
                                                        context,
                                                        listen: true,
                                                      )
                                                      .getSelectProductIndexes()[i]
                                                      .split(",")[1],
                                                )]
                                                .products[int.parse(
                                                  Provider.of<MyProvider>(
                                                        context,
                                                        listen: true,
                                                      )
                                                      .getSelectProductIndexes()[i]
                                                      .split(",")[2],
                                                )]
                                                .description,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                            softWrap: true,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    InkWell(
                                      onTap: () {
                                        Provider.of<MyProvider>(
                                          context,
                                          listen: false,
                                        ).removeAtIndex(i);
                                        quantityControllers.removeAt(i);
                                        labelControllers.removeAt(i);
                                      },
                                      child: Image.asset(
                                        "assets/trash.png",
                                        height: 19,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 30,
                                  ),
                                  child: Container(
                                    height: 1,
                                    color: const Color.fromARGB(
                                      255,
                                      199,
                                      199,
                                      199,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    Provider.of<MyProvider>(
                          context,
                          listen: true,
                        ).getSelectProductIndexes().isEmpty
                        ? Container()
                        : InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            _showOrderPopupMenu();
                          },
                          child: Container(
                            height: 35,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color:
                                  Provider.of<MyProvider>(
                                        context,
                                        listen: true,
                                      ).getSelectProductIndexes().isEmpty
                                      ? Colors.grey
                                      : orange,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Text(
                                getText("AddItems"),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
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
        );
      },
    );
  }

  void _showOrderPopupMenu() {
    quantityControllers = [];
    labelControllers = [];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SafeArea(
          child: Directionality(
            textDirection:
                language == "0" ? TextDirection.ltr : TextDirection.rtl,
            child: SizedBox(
              height: screenHeight * 0.8,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("    "),
                          Text(
                            getText("Orders"),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.close,
                              size: 22,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView(
                            children: [
                              for (
                                int i = 0;
                                i <
                                    Provider.of<MyProvider>(
                                      context,
                                      listen: true,
                                    ).getSelectProductIndexes().length;
                                i++
                              )
                                itemInOrder(i),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(height: 10),
                    InkWell(
                      onTap: () {
                        bool flag = true;
                        String errors = "";
                        int i = 1;
                        for (var element in quantityControllers) {
                          if (element.text.trim().isEmpty) {
                            flag = false;
                            errors += "product number $i ,";
                          }
                          i++;
                        }

                        if (flag) {
                          submitFunction();
                        } else {
                          showCupertinoDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CupertinoAlertDialog(
                                title: const Text('ERROR'),
                                content: Text(
                                  "you must fill the quantities in $errors",
                                ),
                                actions: <Widget>[
                                  CupertinoDialogAction(
                                    child: Text(getText('OK')),
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
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Container(
                          height: 35,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color:
                                Provider.of<MyProvider>(
                                      context,
                                      listen: true,
                                    ).getSelectProductIndexes().isEmpty
                                    ? Colors.grey
                                    : orange,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text(
                              getText("GoCart"),
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
                    InkWell(
                      onTap: () {
                        showAppleAlert(context);
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
                              getText("CancelOrder"),
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
                    Container(height: 7),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget subItem(int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              String search = "${widget.categotyIndex},$currentSubCat,$index";
              if (Provider.of<MyProvider>(
                context,
                listen: false,
              ).getSelectProductIndexes().contains(search)) {
                Provider.of<MyProvider>(
                  context,
                  listen: false,
                ).removeVal(search);
              } else {
                Provider.of<MyProvider>(context, listen: false).addVal(search);
              }
              setState(() {});
            },
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 115,
                    height: 110,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(
                          categories[widget.categotyIndex]
                              .subCategory[currentSubCat]
                              .products[index]
                              .image,
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      categories[widget.categotyIndex]
                          .subCategory[currentSubCat]
                          .products[index]
                          .name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              String search = "${widget.categotyIndex},$currentSubCat,$index";
              if (favListIndexes.contains(search)) {
                favListIndexes.remove(search);
              } else {
                favListIndexes.add(search);
              }
              setState(() {});
              setFavList();
            },
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Image.asset(
                favListIndexes.contains(
                      "${widget.categotyIndex},$currentSubCat,$index",
                    )
                    ? "assets/fav.png"
                    : "assets/nonFav.png",
                height: 33,
              ),
            ),
          ),
          Provider.of<MyProvider>(context, listen: true)
                  .getSelectProductIndexes()
                  .contains("${widget.categotyIndex},$currentSubCat,$index")
              ? Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 13, right: 4),
                  child: Image.asset("assets/check-circle.png", height: 27),
                ),
              )
              : Container(),
        ],
      ),
    );
  }

  void showAppleAlert(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(getText("Confirmation")),
          content: Text(getText("message13")),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(getText("Cancel")),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text(getText('OK')),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget itemInOrder(int i) {
    if (i >= quantityControllers.length) {
      quantityControllers.add(TextEditingController());
      labelControllers.add(TextEditingController());
    }

    String value = currentCategoryIndex;

    currentCategoryIndex =
        Provider.of<MyProvider>(
          context,
          listen: true,
        ).getSelectProductIndexes()[i].split(",")[0];

    return Directionality(
      textDirection: language == "0" ? TextDirection.ltr : TextDirection.rtl,
      child: Column(
        children: [
          Container(height: 8),
          value != currentCategoryIndex
              ? Align(
                alignment:
                    language == "0" ? Alignment.topLeft : Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 10,
                  ),
                  child: Text(
                    categories[int.parse(currentCategoryIndex)].name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              )
              : Container(),
          Container(
            decoration: BoxDecoration(
              color: greyc.withOpacity(.5),
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: const Color.fromARGB(255, 212, 212, 212),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: const Color.fromARGB(255, 212, 212, 212),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(
                          categories[int.parse(
                                Provider.of<MyProvider>(
                                  context,
                                  listen: true,
                                ).getSelectProductIndexes()[i].split(",")[0],
                              )]
                              .subCategory[int.parse(
                                Provider.of<MyProvider>(
                                  context,
                                  listen: true,
                                ).getSelectProductIndexes()[i].split(",")[1],
                              )]
                              .products[int.parse(
                                Provider.of<MyProvider>(
                                  context,
                                  listen: true,
                                ).getSelectProductIndexes()[i].split(",")[2],
                              )]
                              .image,
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: screenWidth * .6,
                          child: Text(
                            categories[int.parse(
                                  Provider.of<MyProvider>(
                                    context,
                                    listen: true,
                                  ).getSelectProductIndexes()[i].split(",")[0],
                                )]
                                .subCategory[int.parse(
                                  Provider.of<MyProvider>(
                                    context,
                                    listen: true,
                                  ).getSelectProductIndexes()[i].split(",")[1],
                                )]
                                .products[int.parse(
                                  Provider.of<MyProvider>(
                                    context,
                                    listen: true,
                                  ).getSelectProductIndexes()[i].split(",")[2],
                                )]
                                .name,
                            textAlign: TextAlign.start,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        SizedBox(
                          width: screenWidth * .6,
                          height: 85,
                          child: Text(
                            categories[int.parse(
                                  Provider.of<MyProvider>(
                                    context,
                                    listen: true,
                                  ).getSelectProductIndexes()[i].split(",")[0],
                                )]
                                .subCategory[int.parse(
                                  Provider.of<MyProvider>(
                                    context,
                                    listen: true,
                                  ).getSelectProductIndexes()[i].split(",")[1],
                                )]
                                .products[int.parse(
                                  Provider.of<MyProvider>(
                                    context,
                                    listen: true,
                                  ).getSelectProductIndexes()[i].split(",")[2],
                                )]
                                .description,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(child: Container()),
                  InkWell(
                    onTap: () {
                      Provider.of<MyProvider>(
                        context,
                        listen: false,
                      ).removeAtIndex(i);
                      quantityControllers.removeAt(i);
                      labelControllers.removeAt(i);
                    },
                    child: Image.asset("assets/trash.png", height: 19),
                  ),
                  Container(width: 6),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: quantityControllers[i],
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: getText("Quantity"),
                      hintStyle: const TextStyle(fontSize: 13),
                      hintText: getText("Quantity"),
                      labelStyle: TextStyle(
                        color: orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 25),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    categories[int.parse(
                          Provider.of<MyProvider>(
                            context,
                            listen: true,
                          ).getSelectProductIndexes()[i].split(",")[0],
                        )]
                        .subCategory[int.parse(
                          Provider.of<MyProvider>(
                            context,
                            listen: true,
                          ).getSelectProductIndexes()[i].split(",")[1],
                        )]
                        .products[int.parse(
                          Provider.of<MyProvider>(
                            context,
                            listen: true,
                          ).getSelectProductIndexes()[i].split(",")[2],
                        )]
                        .unit,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: TextField(
          //           controller: labelControllers[i],
          //           decoration: InputDecoration(
          //             labelText: getText("Label"),
          //             hintStyle: const TextStyle(fontSize: 13),
          //             hintText: getText("Label"),
          //             labelStyle: TextStyle(
          //               color: orange,
          //               fontWeight: FontWeight.bold,
          //               fontSize: 13,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget categoryItem(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          currentSubCat = index;
        });
      },
      child: Column(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: index == currentSubCat ? orange : const Color(0xffF7F7F7),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Image.network(
                categories[widget.categotyIndex].subCategory[index].image,
                color: index == currentSubCat ? Colors.white : Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: SizedBox(
              width: 90,
              child: Text(
                categories[widget.categotyIndex].subCategory[index].name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: index == currentSubCat ? orange : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  submitFunction() async {
    List<CartItem> cartItems = [];
    try {
      ///////////////////////
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
          level1Id = data[0]["level1_id"];
        }
      }
      //////////////////////here222
      List<String> data2 =
          Provider.of<MyProvider>(
            context,
            listen: false,
          ).getSelectProductIndexes();
      List<List<int>> a = convertStringToList(data2);
      for (int i = 0; i < a.length; i++) {
        cartItems.add(
          CartItem(
            categories[a[i][0]].name,
            categories[a[i][0]].subCategory[a[i][1]].name,
            categories[a[i][0]]
                .subCategory[a[i][1]]
                .products[a[i][2]]
                .productIdx,
            categories[a[i][0]].subCategory[a[i][1]].products[a[i][2]].name,
            categories[a[i][0]].subCategory[a[i][1]].products[a[i][2]].image,
            categories[a[i][0]]
                .subCategory[a[i][1]]
                .products[a[i][2]]
                .description,
            quantityControllers[i].text,
            categories[a[i][0]].subCategory[a[i][1]].products[a[i][2]].unit,
            labelControllers[i].text,
            level1Id,
            "",
          ),
        );
      }
    } catch (_) {
      Navigator.pushAndRemoveUntil(
        context,
        (MaterialPageRoute(builder: (context) => const NoInternet())),
        (route) => false,
      );
    }

    cartApi(cartItems).then((v) {
      if (v == cartItems.length) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Cart()),
          (route) => false,
        );

        Provider.of<MyProvider>(
          context,
          listen: false,
        ).setSelectProductIndexes([]);
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const NoInternet()),
          (route) => false,
        );
      }
    });
  }

  cartApi(cartItems) async {
    int a = 0;

    String userId = await getUserId();
    for (int i = 0; i < cartItems.length; i++) {
      try {
        String quantity = cartItems[i].quentity;
        String productIdx = cartItems[i].productIdx;
        String text = cartItems[i].notes;
        var headers = {'Cookie': 'PHPSESSID=7vf93c97gl4a6i397udn9vqm2d'};
        var request = http.Request(
          'GET',
          Uri.parse(
            '$baseUrl/cart.php?input_key=$input_key&input_secret=$input_secret&product_idx=$productIdx&quantity=$quantity&level1_id=$level1Id&user_id=$userId&text=$text',
          ),
        );

        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();
        if (response.statusCode == 200) {
          Map data = json.decode(await response.stream.bytesToString());
          if (data["status"] != "error") {
            a++;
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
    return a;
  }
}
