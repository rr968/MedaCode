import 'dart:io';

import '/controller/logout.dart';
import '/view/profile/goto_myorders.dart';
import '/view/support/menu.dart';
import '/view/wallet/walet.dart';
import 'package:flutter/material.dart';
import '../../controller/language.dart';
import '../splashscreen/splashscreen.dart';
import '/controller/textstyle.dart';
import '/controller/var.dart';
import '/view/bills/myBills.dart';
import '/view/profile/about.dart';
import '/view/profile/banking_account.dart';
import '/view/profile/settings.dart';

import '../merchant/upgradeToMarchant/upgrade_account.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: language == "0" ? TextDirection.ltr : TextDirection.rtl,
        child: Stack(children: [
          Container(
            height: 140,
            decoration: BoxDecoration(gradient: gradient),
            child: Stack(
              children: [
                Container(
                  width: 150,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/Logo Shape.png"),
                          fit: BoxFit.cover)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                              image: DecorationImage(
                                image: NetworkImage(
                                    isUserNow ? userPhoto : firmPhoto),
                              )),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isUserNow ? userName : firmName,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            isUserNow
                                ? getText("MembershipC")
                                : getText("MembershipMerchant"),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Expanded(child: Container()),
                      merchantAccountStatus == "2"
                          ? Container()
                          : InkWell(
                              onTap: () {
                                if (merchantAccountStatus == "2") {
                                } else if (merchantAccountStatus == "0") {
                                  snackBar(context, getText("message9"));
                                } else if (merchantAccountStatus == "-1") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const UpgradeAccount()));
                                } else if (merchantAccountStatus == "1") {
                                  snackBar(context, getText("message10"));
                                }
                              },
                              child: Container(
                                height: 25,
                                width: 80,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25)),
                                child: Center(
                                    child: Text(
                                  getText("Upgrade"),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11),
                                )),
                              )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: screenHeight,
            child: Padding(
              padding: EdgeInsets.only(top: Platform.isIOS ? 150 : 120),
              child: Container(
                height: screenHeight,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25))),
                child: Padding(
                  padding: const EdgeInsets.only(top: 33),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      isUserNow
                          ? Container()
                          : oneLine("assets/icon2.png", getText("Wallet"),
                              getText("message14"), () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Wallet()));
                            }),
                      /*    oneLine("assets/heart.png", "My Favourite",
                          "View favourite items", () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyFavourite()));
                      }), */
                      oneLine("assets/clipboard-list.png", getText("Myorders"),
                          getText("message15"), () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const GoToMyOrders()));
                      }),
                      oneLine("assets/Bills.png", getText("MyBills"),
                          getText("message16"), () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyBills(
                                      isFirstOpen: false,
                                    )));
                      }),
                      oneLine("assets/credit-card.png",
                          getText("BankingAccounts"), getText("message17"), () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const BankingAccount()));
                      }),
                      // isUserNow
                      //     ? oneLine("assets/users-group-alt.png",
                      //         getText("Partners"), getText("message18"), () {
                      //         Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //                 builder: (context) => const Parteners()));
                      //       })
                      //     : Container(),
                      /* oneLine("assets/user-plus-bottom.png", "Invite friends",
                          "Invite your friends to get MEDA points", () {}),*/
                      oneLine("assets/file-text.png", getText("About"),
                          getText("message19"), () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const About()));
                      }),
                      oneLine("assets/settings.png", getText("Settings"),
                          getText("message20"), () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Settings()));
                      }),
                      oneLine("assets/Help.png", getText("Help"),
                          getText("message21"), () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SupportMenu()));
                      }),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: InkWell(
                          onTap: () {
                            logout();
                            setUserId("");
                            setToken("");
                            setUserName("");
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SplashScreen()),
                                (route) => false);
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/log-out.png",
                                height: 25,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  getText("Logout"),
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
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
            ),
          )
        ]),
      ),
    );
  }

  oneLine(String image, String text1, String subText, void Function()? ontap) {
    return InkWell(
      onTap: ontap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Image.asset(
                  image,
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text1,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        subText,
                        style:
                            const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Expanded(child: Container()),
                Icon(
                  Icons.arrow_back_ios_new,
                  size: 18,
                  textDirection:
                      language == "0" ? TextDirection.rtl : TextDirection.ltr,
                  color: Colors.grey,
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20, top: 9, bottom: 9),
            child: Divider(),
          )
        ],
      ),
    );
  }
}
