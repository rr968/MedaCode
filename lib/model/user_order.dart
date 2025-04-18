// ignore_for_file: non_constant_identifier_names

class UserOrder {
  final String STejari;
  final String order_code;
  final String firm;
  final String last_updated_date;
  final String offer_id;
  final List<MainCat> categories;

  UserOrder(
      {required this.STejari,
      required this.order_code,
      required this.firm,
      required this.last_updated_date,
      required this.offer_id,
      required this.categories});
}

class MainCat {
  final String catName;
  bool isSelected;
  final List<SubCat> subCategories;

  MainCat(
      {required this.catName,
      required this.subCategories,
      required this.isSelected});
}

class SubCat {
  bool isSelected;
  bool isShowAfterFiltered;
  final String idx;
  final String offer_id;
  final String user_id;
  final String product_idx;
  final String quantity;
  final String level1_id;
  final String level2_id;
  final String text;
  final String lat;
  final String long;
  final String city_ar;
  final String city_en;
  final String address_ar;
  final String address_en;
  final String date_created;
  final String date_paid;
  final String duration;
  final String status;
  final String price;
  final String payment_id;
  final String address;
  final String city;
  final String country;
  final String expiration_date;
  final String expire_after;
  final String category;
  final String sub_categories;
  final String sub_icon;
  final String name;
  final String description;
  final String image;
  final String unit;
  final String avg_message;
  final String total_price_per_product;
  final String total_price_per_product_VAT;
  final String total_price_per_product_only_VAT;
  final String adjusted_price_VAT;
  final String STejari;
  final String p_idx;
  final String discount_type;
  final String applied_on;
  final String original_price;
  final String adjusted_price;
  final String discounted_value;
  final String discount_status;
  final String date_updated;
  final String item_status;

  SubCat(
      {required this.isSelected,
      required this.isShowAfterFiltered,
      required this.idx,
      required this.total_price_per_product_VAT,
      required this.total_price_per_product_only_VAT,
      required this.adjusted_price_VAT,
      required this.offer_id,
      required this.user_id,
      required this.product_idx,
      required this.quantity,
      required this.level1_id,
      required this.level2_id,
      required this.text,
      required this.lat,
      required this.long,
      required this.city_ar,
      required this.city_en,
      required this.address_ar,
      required this.address_en,
      required this.date_created,
      required this.date_paid,
      required this.duration,
      required this.status,
      required this.price,
      required this.payment_id,
      required this.address,
      required this.city,
      required this.country,
      required this.expiration_date,
      required this.expire_after,
      required this.category,
      required this.sub_categories,
      required this.sub_icon,
      required this.name,
      required this.description,
      required this.image,
      required this.unit,
      required this.avg_message,
      required this.total_price_per_product,
      required this.STejari,
      required this.p_idx,
      required this.discount_type,
      required this.applied_on,
      required this.original_price,
      required this.adjusted_price,
      required this.discounted_value,
      required this.discount_status,
      required this.date_updated,
      required this.item_status});
}
