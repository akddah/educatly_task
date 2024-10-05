import 'dart:async';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

import '../../models/last_seen_model.dart';

class UsersOnlineServices {
  static UsersOnlineServices instance = UsersOnlineServices._();
  UsersOnlineServices._();

  List<LastSeenModel> onlineUsers = [];
  List<LastSeenModel> allUsers = [];
  final groupRef = FirebaseDatabase.instance.ref().child('online_users');

  StreamController<Map<String, List<LastSeenModel>>> streamController = StreamController.broadcast();
  StreamSubscription<DatabaseEvent>? _onChildChangedSubscription;

  init() {
    dispose();

    streamController = StreamController.broadcast();
    streamController.add({'online': onlineUsers, 'all': allUsers});
    groupRef.get().then((value) {
      final onlineUsersData = value.value as Map<dynamic, dynamic>;
      onlineUsersData.forEach((key, value) {
        final data = LastSeenModel.fromJson({'id': key, 'last_seen': value['last_seen']});
        final i = allUsers.indexWhere((i) => data.userId == i.userId);
        if (i == -1) {
          allUsers.add(data);
        } else {
          allUsers[i] = data;
        }
        final bool isOnline = data.lastSeen.microsecondsSinceEpoch > DateTime.now().toUtc().subtract(const Duration(minutes: 2)).microsecondsSinceEpoch;
        log('online $isOnline ${data.userId} lastSeen: ${DateFormat('hh:mm a').format(data.lastSeen)} now : ${DateFormat('hh:mm a').format(DateTime.now().toUtc().subtract(const Duration(minutes: 2)))}');
        if (isOnline) {
          onlineUsers.add(data);
        }
      });

      streamController.add({'online': onlineUsers, 'all': allUsers});
    });
    _onChildChangedSubscription = groupRef.onChildChanged.listen(
      (event) {
        final value = event.snapshot.value as Map<dynamic, dynamic>;
        final data = LastSeenModel.fromJson({'id': event.snapshot.key, 'last_seen': value['last_seen']});
        final i = allUsers.indexWhere((i) => data.userId == i.userId);
        if (i == -1) {
          allUsers.add(data);
        } else {
          allUsers[i] = data;
        }
        final bool isOnline = data.lastSeen.microsecondsSinceEpoch > DateTime.now().toUtc().subtract(const Duration(minutes: 2)).microsecondsSinceEpoch;

        log('online $isOnline ${data.userId} lastSeen: ${DateFormat('hh:mm a').format(data.lastSeen)} now : ${DateFormat('hh:mm a').format(DateTime.now().toUtc().subtract(const Duration(minutes: 2)))}');
        final now = DateTime.now().toUtc().subtract(const Duration(minutes: 2));
        onlineUsers = allUsers.where((element) => element.lastSeen.microsecondsSinceEpoch > now.microsecondsSinceEpoch).toList();
        streamController.add({'online': onlineUsers, 'all': allUsers});
      },
    );
  }

  void dispose() {
    _onChildChangedSubscription?.cancel();
    if (!streamController.isClosed) streamController.close();
  }

  isUserOnline(String id) {
    return onlineUsers.indexWhere((element) => element.userId == id) != -1;
  }

  DateTime getLastSeen(String id) {
    final i = allUsers.indexWhere((element) => element.userId == id);
    if (i == -1) return DateTime.now();
    return allUsers[i].lastSeen;
  }
}
