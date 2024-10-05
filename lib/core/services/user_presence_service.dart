import 'dart:async';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

import 'secure_storage.dart';

class UserPresenceService {
  Timer? timer;
  late final _groupRef = FirebaseDatabase.instance.ref().child('online_users');
  final secureStorage = SecureStorage();
  init() async {
    if (secureStorage.user?.isAuthenticated ?? false) {
      setOnline(secureStorage.user!.uid);
      timer?.cancel();
      timer = Timer.periodic(const Duration(minutes: 1), (timer) async {
        setOnline(secureStorage.user!.uid);
      });
    }
  }

  Future<bool> setOnline(String id) async {
    try {
      final now = DateTime.now().toUtc();
      await _groupRef.child(id).set({"last_seen": now.millisecondsSinceEpoch});
      log('user set online ${DateFormat('hh:mm a').format(now)}');
      return true;
    } catch (e) {
      return false;
    }
  }

  void dispose() {
    timer?.cancel();
  }
}
