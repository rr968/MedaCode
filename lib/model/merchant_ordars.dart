// ignore_for_file: non_constant_identifier_names

import '/model/merchant_order.dart';

class MerchantOrdersClass {
  final String user_id;
  final String order_code;
  final String expire_after;
  final String summedup_prices_before_discount;
  final String summed_adjusted_prices_after_discount;
  final String summed_adjusted_prices_after_discount_VAT;

  final String Total_saves;

  final List<MerchantOrderClass> orders;

  MerchantOrdersClass(
      {required this.user_id,
      required this.order_code,
      required this.expire_after,
      required this.summedup_prices_before_discount,
      required this.summed_adjusted_prices_after_discount,
      required this.summed_adjusted_prices_after_discount_VAT,
      required this.Total_saves,
      required this.orders});
}
