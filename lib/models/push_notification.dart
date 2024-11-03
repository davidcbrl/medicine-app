class PushNotification {
  int id;
  String title;
  String? image;
  String? body;
  DateTime? date;
  String? payload;

  PushNotification({
    required this.id,
    required this.title,
    this.image,
    this.body,
    this.date,
    this.payload,
  });

  PushNotification.fromJson(Map<String, dynamic> json):
    id = json['id'],
    title = json['title'],
    image = json['image'],
    body = json['body'],
    date = json['date'],
    payload = json['payload'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'image': image,
    'body': body,
    'date': date,
    'payload': payload,
  };
}
