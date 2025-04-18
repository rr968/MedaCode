import '/model/store_item.dart';

class Product {
  final String name;
  final String productIdx;
  final String image;
  final String description;
  final String unit;
  bool isItMyProduct;
  StoreItem? storeItem;

  Product(
      {required this.name,
      required this.productIdx,
      required this.image,
      required this.description,
      required this.unit,
      required this.isItMyProduct,
      required this.storeItem});
}
