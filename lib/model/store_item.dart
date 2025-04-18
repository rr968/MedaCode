// ignore_for_file: non_constant_identifier_names

class StoreItem {
  final String STejari;
  final String p_idx;
  final String discount_type;
  final String applied_on;
  String original_price;
  final String adjusted_price;
  final String discounted_value;
  String discount_status;

  StoreItem({
    required this.STejari,
    required this.p_idx,
    required this.discount_type,
    required this.applied_on,
    required this.original_price,
    required this.adjusted_price,
    required this.discounted_value,
    required this.discount_status,
  });
}
