class LastSeenModel {
  final String userId;
  final DateTime lastSeen;

  LastSeenModel({
    required this.userId,
    required this.lastSeen,
  });

  factory LastSeenModel.fromJson(Map<String, dynamic> json) {
    return LastSeenModel(
      userId: json['id'],
      lastSeen: DateTime.fromMillisecondsSinceEpoch(json['last_seen']),
    );
  }
}
