class MessageModel {
  final String id;
  final String userName;
  final String userImage;
  final String userId;
  final String text;
  final String type;
  final DateTime createdAt;

  MessageModel({
    required this.id,
    required this.userName,
    required this.userImage,
    required this.userId,
    required this.text,
    required this.type,
    required this.createdAt,
  });

  factory MessageModel.fromMap(Map<dynamic, dynamic> json) {
    return MessageModel(
      id: '',
      text: json['text'] ?? '',
      type: json['type'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] ?? 0),
      userId: json['user_id'] ?? '',
      userName: json['user_name'] ?? '',
      userImage: json['user_image'] ?? '',
    );
  }
}
