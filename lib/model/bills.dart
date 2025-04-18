class BillClass {
  String offer_id;
  String date_updated;
  String user_total_payments;
  String STejari;
  String firm;

  List<Item> bills;
  BillClass({
    required this.offer_id,
    required this.date_updated,
    required this.user_total_payments,
    required this.STejari,
    required this.firm,
    required this.bills,
  });
}

class Item {
  String name;
  String sub_categories;
  String category;
  String quantity;
  String unit;
  String adjusted_price_VAT;
  Item({
    required this.name,
    required this.sub_categories,
    required this.category,
    required this.quantity,
    required this.unit,
    required this.adjusted_price_VAT,
  });
}
