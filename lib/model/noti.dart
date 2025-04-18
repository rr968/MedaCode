class Noti {
  final String id;
  final String title;
  final String description;
  final String link;
  final String status;
  final String created_at;
  final String seen_at;
  final String notification_id;

  Noti(
      {required this.id,
      required this.title,
      required this.description,
      required this.link,
      required this.status,
      required this.created_at,
      required this.seen_at,
      required this.notification_id});
}
