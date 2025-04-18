import 'dart:io';

import '/controller/language.dart';
import 'package:flutter/material.dart';
import '/controller/head_bar.dart';
import '/controller/var.dart';
import '/view/category/sub_category.dart';

class MainCategories extends StatefulWidget {
  const MainCategories({super.key});

  @override
  State<MainCategories> createState() => _MainCategoriesState();
}

class _MainCategoriesState extends State<MainCategories> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: language == "0" ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          children: [
            HeaderBar(title: getText("MainCategory")),
            Padding(
              padding: EdgeInsets.only(top: Platform.isIOS ? 90 : 70),
              child: Container(
                height: screenHeight,
                width: screenWidth,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25)),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Align(
                        alignment: language == "0"
                            ? Alignment.topLeft
                            : Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            getText("Categories"),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight - 220,
                        child: GridView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: categories.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3),
                            itemBuilder: (context, index) {
                              return categoryItem(index);
                            }),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget categoryItem(int index) {
    return InkWell(
      onTap: () {
        if (index < categories.length) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      SubCategoryScreen(categotyIndex: index)));
        }
      },
      child: Column(
        children: [
          Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
                color: const Color(0xffF7F7F7),
                borderRadius: BorderRadius.circular(100)),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Image.network(categories[index].image),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: SizedBox(
                width: 70,
                child: Text(
                  categories[index].name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                )),
          )
        ],
      ),
    );
  }
}
