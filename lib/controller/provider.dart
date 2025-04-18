import 'package:flutter/material.dart';
import '/controller/var.dart';

import '../model/category.dart';

class MyProvider with ChangeNotifier {
  List<String> selectProductIndexes = [];

  String? addressNamke;
  String walletBalance = "0";
  int radioDiscountValue = 0;
  int appliedDiscountOn = 1;
  int currentCountryIndex = 0;
  List<Category> filterCat = [];
  List<List> selectedOffers = [];
  String offerPrice = "0";
  String offerPriceWithoutVat = "0";
  //name,bool Submit
  List<List> offerCatUserFilter = [];
  List<List> offerSubCatUserFilter = [];
  int numOfStars = 5;

  String getwalletBalance() {
    return walletBalance;
  }

  void setwalletBalance(String value) {
    walletBalance = value;
    notifyListeners();
  }

  void setnumOfStars(int value) {
    numOfStars = value;
    notifyListeners();
  }

  int getnumOfStars() {
    return numOfStars;
  }

  void setofferCatUserFilter(List<List> value) {
    offerCatUserFilter = value;
    notifyListeners();
  }

  List<List> getofferCatUserFilter() {
    return offerCatUserFilter;
  }

  void setofferSubCatUserFilter(List<List> value) {
    offerSubCatUserFilter = value;
    notifyListeners();
  }

  List<List> getofferSubCatUserFilter() {
    return offerSubCatUserFilter;
  }

  void setofferPriceWithoutVat(String value) {
    offerPriceWithoutVat = value;
    notifyListeners();
  }

  String getofferPriceWithoutVat() {
    return offerPriceWithoutVat;
  }

  void setofferPrice(String value) {
    offerPrice = value;
    notifyListeners();
  }

  String getofferPrice() {
    return offerPrice;
  }

  void setselectedOffers(List<List> value) {
    selectedOffers = value;
    notifyListeners();
  }

  List<List> getselectedOffers() {
    return selectedOffers;
  }

  void setCurrentCountryIndex(int value) {
    currentCountryIndex = value;
    notifyListeners();
  }

  int getCurrentCountryIndex() {
    return currentCountryIndex;
  }

  void setfilterCat(List<Category> value) {
    filterCat = value;
    notifyListeners();
  }

  List<Category> getfilterCat() {
    return filterCat;
  }

  void setappliedDiscountOn(int value) {
    appliedDiscountOn = value;
    notifyListeners();
  }

  int getrappliedDiscountOn() {
    return appliedDiscountOn;
  }

  void setradioDiscountValue(int value) {
    radioDiscountValue = value;
    notifyListeners();
  }

  int getradioDiscountValue() {
    return radioDiscountValue;
  }

  void setaddressName(String? value) {
    addressNamke = value;
    notifyListeners();
  }

  String? getaddressName() {
    return addressNamke;
  }

  void setSelectProductIndexes(List<String> value) {
    selectProductIndexes = sortArray(value);
    notifyListeners();
  }

  void removeAtIndex(int index) {
    selectProductIndexes.removeAt(index);
    notifyListeners();
  }

  void removeVal(String val) {
    selectProductIndexes.remove(val);
    notifyListeners();
  }

  void addVal(String val) {
    selectProductIndexes.add(val);
    selectProductIndexes = sortArray(selectProductIndexes);
    notifyListeners();
  }

  List<String> getSelectProductIndexes() {
    return selectProductIndexes;
  }
}
