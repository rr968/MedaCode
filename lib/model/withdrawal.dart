class WithdrawalClass {
  final String idx;
  final String requester_type;
  final String id;
  final String amount;
  final String date;
  final String status;

  WithdrawalClass(
      {required this.idx,
      required this.requester_type,
      required this.id,
      required this.amount,
      required this.date,
      required this.status});
}
