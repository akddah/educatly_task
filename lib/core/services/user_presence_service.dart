import 'dart:async';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

import 'secure_storage.dart';

class UserPresenceService {
  Timer? timer;
  late final _groupRef = FirebaseDatabase.instance.ref().child('online_users');
  init() async {
    final secureStorage = SecureStorage();
    final user = await secureStorage.getUserData();
    if (user.isAuthenticated) {
      timer?.cancel();
      timer = Timer.periodic(const Duration(minutes: 1), (timer) async {
        setOnline(user.uid);
      });
    }
  }

  Future<bool> setOnline(String id) async {
    try {
      await _groupRef.child(id).set({"last_seen": DateTime.now().millisecondsSinceEpoch});
      log('user set online ${DateFormat('hh:mm a').format(DateTime.now())}');
      return true;
    } catch (e) {
      return false;
    }
  }

  void dispose() {
    timer?.cancel();
  }
}
