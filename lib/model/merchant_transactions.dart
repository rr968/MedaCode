class MerchantTransactionsClass {
  final String offer_id;
  final String STejari;
  final String user_id;
  final String date_recieved;
  final String date_available;
  final String deduction_percent;
  final String operation_type;
  final String amount;
  final String amount_VAT;
  final String deduction_amount;
  final String Final_amount;
  final String Final_amount_VAT;
  final String description;

  MerchantTransactionsClass(
      {required this.offer_id,
      required this.STejari,
      required this.user_id,
      required this.date_recieved,
      required this.date_available,
      required this.deduction_percent,
      required this.operation_type,
      required this.amount,
      required this.amount_VAT,
      required this.deduction_amount,
      required this.Final_amount,
      required this.Final_amount_VAT,
      required this.description});
}
