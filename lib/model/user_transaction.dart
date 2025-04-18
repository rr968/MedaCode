class UserTransactionClass {
  final String operation_id;
  final String user_id;
  final String operation_type;
  final String amount;
  final String offer_ids;
  final String date;
  final String description;

  UserTransactionClass(
      {required this.operation_id,
      required this.user_id,
      required this.operation_type,
      required this.amount,
      required this.offer_ids,
      required this.date,
      required this.description});
}
