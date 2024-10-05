import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/services/users_online_services.dart';
import '../../../models/last_seen_model.dart';
import '../bloc/chat_bloc.dart';

class UsersStatusWidget extends StatefulWidget {
  const UsersStatusWidget({super.key});

  @override
  State<UsersStatusWidget> createState() => _UsersStatusWidgetState();
}

class _UsersStatusWidgetState extends State<UsersStatusWidget> {
  Timer? typingTimer;
  List<String> usersTyping = [];
  final usersOnline = UsersOnlineServices.instance;
  final groupRef = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    final bloc = context.read<ChatBloc>();
    bloc.messageController.addListener(() {
      typingTimer?.cancel();

      if (bloc.messageController.text.isNotEmpty) {
        groupRef.child('chat/${bloc.chatId}').child('typing_users/${bloc.user.uid}').set({
          'name': bloc.user.name,
        });
      }
      typingTimer = Timer(const Duration(seconds: 1), () {
        groupRef.child('chat/${bloc.chatId}').child('typing_users/${bloc.user.uid}').set(null);
      });
    });

    groupRef.child('chat/${bloc.chatId}').child('typing_users')
      ..onChildAdded.listen((event) {
        if (event.snapshot.key == bloc.user.uid) return;
        final messageData = event.snapshot.value as Map<dynamic, dynamic>;
        final newMessage = messageData['name'];
        if (!usersTyping.contains(newMessage)) {
          usersTyping.add(newMessage);
          setState(() {});
        }
      })
      ..onChildRemoved.listen((event) {
        final messageData = event.snapshot.value as Map<dynamic, dynamic>;
        final newMessage = messageData['name'];
        usersTyping.remove(newMessage);
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    if (usersTyping.isNotEmpty) {
      return Text(
        "${usersTyping.join(',')} ${usersTyping.length > 1 ? 'are' : 'is'} typing...",
        style: TextStyle(
          fontSize: 13,
          color: Colors.white.withOpacity(0.5),
          fontWeight: FontWeight.w400,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }
    return StreamBuilder<Map<String, List<LastSeenModel>>?>(
      stream: usersOnline.streamController.stream,
      initialData: {'all': usersOnline.allUsers, 'online': usersOnline.onlineUsers},
      builder: (context, snapshot) {
        if (context.read<ChatBloc>().chatId == 'group') {
          return Text(
            '${snapshot.data?['all']?.length} members, ${snapshot.data?['online']?.length} online',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withOpacity(0.5),
              fontWeight: FontWeight.w400,
            ),
          );
        } else {
          final onlineIndex = usersOnline.allUsers.indexWhere((element) => element.userId == context.read<ChatBloc>().externalUser?.uid);
          if (onlineIndex == -1) return const SizedBox.shrink();
          return Text(
            usersOnline.allUsers[onlineIndex].lastSeen.isAfter(DateTime.now().toUtc().subtract(const Duration(minutes: 2)))
                ? 'Online'
                : 'Last seen ${DateFormat('hh:mm a').format(usersOnline.allUsers[onlineIndex].lastSeen)}',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withOpacity(0.5),
              fontWeight: FontWeight.w400,
            ),
          );
        }
      },
    );
  }
}
