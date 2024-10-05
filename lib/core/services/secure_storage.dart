import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../models/user_model.dart';

class SecureStorage {
  // Singleton pattern for consistent access to SecureStorage throughout the app
  static final SecureStorage _instance = SecureStorage._internal();
  factory SecureStorage() => _instance;
  SecureStorage._internal();

  // Create an instance of FlutterSecureStorage
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Keys for user data
  static const String _keyUID = 'uid';
  static const String _keyName = 'name';
  static const String _keyEmail = 'email';
  static const String _keyImageUrl = 'imageUrl';
  static const String _createdAt = 'createdAt';

  // Save User Data to Secure Storage
  Future<void> saveUserData({
    required String uid,
    required String name,
    required String email,
    required String imageUrl,
    required String createdAt,
  }) async {
    await _secureStorage.write(key: _keyUID, value: uid);
    await _secureStorage.write(key: _keyName, value: name);
    await _secureStorage.write(key: _keyEmail, value: email);
    await _secureStorage.write(key: _keyImageUrl, value: imageUrl);
    await _secureStorage.write(key: _createdAt, value: createdAt);
  }

  // Get User Data from Secure Storage
  Future<UserModel> getUserData() async {
    String? uid = await _secureStorage.read(key: _keyUID);
    String? name = await _secureStorage.read(key: _keyName);
    String? email = await _secureStorage.read(key: _keyEmail);
    String? imageUrl = await _secureStorage.read(key: _keyImageUrl);
    String? createdAt = await _secureStorage.read(key: _createdAt);
    user = UserModel(
      name: name ?? '',
      email: email ?? '',
      uid: uid ?? '',
      imageUrl: imageUrl ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(int.parse(createdAt ?? '0')).toLocal(),
    );
    return user!;
  }

  // Delete User Data from Secure Storage (e.g., on logout)
  Future<void> deleteUserData() async {
    user = null;
    await _secureStorage.delete(key: _keyUID);
    await _secureStorage.delete(key: _keyName);
    await _secureStorage.delete(key: _keyEmail);
    await _secureStorage.delete(key: _keyImageUrl);
  }

  // Clear all data in Secure Storage
  Future<void> clearAll() async {
    user = null;
    await _secureStorage.deleteAll();
  }

  UserModel? user;
}
