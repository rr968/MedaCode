class ChatInfo {
  String offer_id;
  String lat;
  String long;
  String STejari;
  List<ChatItem> chatItems = [];
  ChatInfo(
      {required this.offer_id,
      required this.lat,
      required this.long,
      required this.STejari,
      required this.chatItems});
}

class ChatItem {
  String Category_AR;
  String sub_category_AR;
  String product_AR;
  String Category_EN;
  String sub_category_EN;
  String product_EN;

  String unit;
  String unit_ar;
  String image;

  String quantity;
  String total_price_per_product;
  String original_price;
  String adjusted_price;
  ChatItem({
    required this.Category_AR,
    required this.sub_category_AR,
    required this.product_AR,
    required this.Category_EN,
    required this.sub_category_EN,
    required this.product_EN,
    required this.unit,
    required this.unit_ar,
    required this.image,
    required this.quantity,
    required this.total_price_per_product,
    required this.original_price,
    required this.adjusted_price,
  });
}
