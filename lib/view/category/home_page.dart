import 'dart:developer';
import 'dart:io';

import 'package:finaltest/controller/note_alert.dart';

import '/controller/language.dart';
import '/view/category/oneoffers.dart';
import '/view/notification/notifications.dart';
import '/view/wallet/points_transaction.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '/view/cart/cart.dart';
import '/view/category/main_categories.dart';
import '/controller/textstyle.dart';
import '/controller/var.dart';
import '/view/category/offers.dart';
import '/view/category/sub_category.dart';
import '/view/merchant/mainMerchentPage.dart';
import '/view/merchant/upgradeToMarchant/upgrade_account.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
      body: Directionality(
        textDirection: language == "0" ? TextDirection.ltr : TextDirection.rtl,
        child: SizedBox(
          height: screenHeight,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 255,
                      decoration: BoxDecoration(
                        gradient: gradient,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Image.asset("assets/Logo Shape.png", width: 150),
                          SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        child: InkWell(
                                          onTap: () async {
                                            if (token.trim().isEmpty) {
                                              showSignInDialog(context);
                                            } else {
                                              log(await getUserId());
                                              if (merchantAccountStatus ==
                                                  "2") {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (context) =>
                                                            const MainMerchantPage(
                                                              pageindex: 0,
                                                            ),
                                                  ),
                                                );
                                              } else if (merchantAccountStatus ==
                                                  "0") {
                                                snackBar(
                                                  context,
                                                  getText("message9"),
                                                );
                                              } else if (merchantAccountStatus ==
                                                  "-1") {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (context) =>
                                                            const UpgradeAccount(),
                                                  ),
                                                );
                                              } else if (merchantAccountStatus ==
                                                  "1") {
                                                snackBar(
                                                  context,
                                                  getText("message10"),
                                                );
                                              }
                                            }
                                          },
                                          child: Align(
                                            alignment: Alignment.topCenter,
                                            child: Column(
                                              children: [
                                                Image.asset(
                                                  "assets/userAccount.png",
                                                  height: 25,
                                                ),
                                                Text(
                                                  getText("User"),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            getText("message11"),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            userName,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Expanded(child: Container()),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        child: Align(
                                          alignment: Alignment.topCenter,
                                          child: InkWell(
                                            onTap: () {
                                              if (token.trim().isEmpty) {
                                                showSignInDialog(context);
                                              } else {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (context) =>
                                                            const NotificationPage(),
                                                  ),
                                                );
                                              }
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
                                      InkWell(
                                        onTap: () {
                                          if (token.trim().isEmpty) {
                                            showSignInDialog(context);
                                          } else {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) => const Cart(),
                                              ),
                                            );
                                          }
                                        },
                                        child: Align(
                                          alignment: Alignment.topCenter,
                                          child: Image.asset(
                                            "assets/shopping-cart.png",
                                            height: 24,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 8,
                                    ),
                                    child: Container(
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: deepOrange,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 17,
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            if (token.trim().isEmpty) {
                                              showSignInDialog(context);
                                            } else {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (context) =>
                                                          PointsTransaction(
                                                            balance: points,
                                                          ),
                                                ),
                                              );
                                            }
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                getText("PointsBalance"),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                "$points ${getText("Points")}",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                ),
                                              ),
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
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: Platform.isIOS ? 220 : 125),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 13,
                              vertical: 12,
                            ),
                            child: Container(
                              height: 260,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color.fromARGB(
                                      255,
                                      227,
                                      227,
                                      227,
                                    ).withOpacity(.4),
                                    spreadRadius: 0,
                                    blurRadius: 8,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(6),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            getText("Categories"),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              if (token.trim().isEmpty) {
                                                showSignInDialog(context);
                                              } else {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (context) =>
                                                            const MainCategories(),
                                                  ),
                                                );
                                              }
                                            },
                                            child: Text(
                                              getText("SeeAll"),
                                              style: TextStyle(
                                                color: deepOrange,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 6,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          for (int i = 0; i < 4; i++)
                                            categoryItem(i),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 6,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          for (int i = 0; i < 4; i++)
                                            categoryItem(i + 4),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 22,
                              vertical: 5,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  getText("Offers"),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    if (token.trim().isEmpty) {
                                      showSignInDialog(context);
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const Offers(),
                                        ),
                                      );
                                    }
                                  },
                                  child: Text(
                                    getText("SeeAll"),
                                    style: TextStyle(
                                      color: deepOrange,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: SizedBox(
                              height: 110,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  for (int i = 0; i < offers.length; i++)
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () async {
                                          if (token.trim().isEmpty) {
                                            showSignInDialog(context);
                                          } else {
                                            //0 page 1 link 2 app link
                                            if (offers[i].status != "0") {
                                              String url = offers[i].link;

                                              if (!await launchUrl(
                                                Uri.parse(url),
                                                mode:
                                                    LaunchMode
                                                        .externalApplication,
                                              )) {
                                                snackBar(
                                                  context,
                                                  "error while launch this link",
                                                );
                                              }
                                            } else {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (context) =>
                                                          TheOffer(index: i),
                                                ),
                                              );
                                            }
                                          }
                                        },
                                        child: Container(
                                          width: screenWidth - 95,
                                          decoration: BoxDecoration(
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Color.fromARGB(
                                                  255,
                                                  232,
                                                  232,
                                                  232,
                                                ),
                                                spreadRadius: 0,
                                                blurRadius: 5,
                                              ),
                                            ],
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Container(
                                            height: 120,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  offers[i].image,
                                                ),
                                                fit: BoxFit.fill,
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
                          /*
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 22, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                getText("LatestOrders"),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LatestOrder()));
                                },
                                child: Text(
                                  getText("SeeAll"),
                                  style: TextStyle(
                                      color: deepOrange, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                      
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 12),
                          child: SizedBox(
                            height: 120,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                for (int i = 0; i < latestOrder.length; i++)
                                  Padding(
                                    padding: const EdgeInsets.all(7),
                                    child: InkWell(
                                      onTap: () {},
                                      child: Container(
                                        width: 100,
                                        decoration: BoxDecoration(
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: Color.fromARGB(
                                                      255, 232, 232, 232),
                                                  spreadRadius: 0,
                                                  blurRadius: 5)
                                            ],
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(7)),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 80,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          latestOrder[i].image),
                                                      fit: BoxFit.fill)),
                                            ),
                                            Container(
                                              height: 4,
                                            ),
                                            Text(
                                              latestOrder[i].name,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 11),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                              ],
                            ),
                          ),
                        ),
                       */
                          Container(height: 100),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget categoryItem(int index) {
    return InkWell(
      onTap: () {
        if (token.trim().isEmpty) {
          showSignInDialog(context);
        } else {
          if (index < categories.length) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SubCategoryScreen(categotyIndex: index),
              ),
            );
          }
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          index > categories.length - 1
              ? const SizedBox(height: 40, width: 40)
              : Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: const Color(0xffF7F7F7),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Image.network(categories[index].image),
                ),
              ),
          index > categories.length - 1
              ? Container()
              : Padding(
                padding: const EdgeInsets.only(top: 5),
                child: SizedBox(
                  width: 60,
                  height: 30,
                  child: Text(
                    categories[index].name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 8.5,
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
