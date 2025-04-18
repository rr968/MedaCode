import '/model/sub_category.dart';

class Category {
  String name;
  String image;
  List<SubCategory> subCategory;
  Category(this.name, this.image, this.subCategory);
}
