class WalletCharge {
  final String user_id;
  final String bill_number;
  final String saddad_number;
  final String amount;
  final String issue_date;
  final String date_of_expiration;
  final String status;
  final String status_description;
  final String status_code;

  WalletCharge(
      {required this.user_id,
      required this.bill_number,
      required this.saddad_number,
      required this.amount,
      required this.issue_date,
      required this.date_of_expiration,
      required this.status,
      required this.status_description,
      required this.status_code});
}
