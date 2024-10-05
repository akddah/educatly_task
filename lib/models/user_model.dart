class UserModel {
  final String name;
  final String email;
  final String uid;
  final String imageUrl;
  final DateTime createdAt;

  bool get isAuthenticated => uid.isNotEmpty;

  UserModel({
    required this.name,
    required this.email,
    required this.uid,
    required this.imageUrl,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      uid: map['uid'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(int.parse('${map['createdAt'] ?? 0}')),
    );
  }
}
