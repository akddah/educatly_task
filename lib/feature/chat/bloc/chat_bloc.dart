import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/secure_storage.dart';
import '../../../core/utils/enums.dart';
import '../../../models/message_model.dart';
import '../../../models/user_model.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final UserModel? externalUser;
  ChatBloc(this.externalUser) : super(ChatState()) {
    on<StartSendMessageEvent>(_sendMessage);
    on<StartAddMessageEvent>(_addMessage);
  }

  late final groupRef = FirebaseDatabase.instance.ref().child('chat/$chatId');

  final messageController = TextEditingController();
  final UserModel user = SecureStorage().user!;
  List<MessageModel> messages = [];

  Future<void> _sendMessage(StartSendMessageEvent event, Emitter<ChatState> emit) async {
    try {
      emit(state.copyWith(sendMessageState: RequestState.loading));
      if (messageController.text.isNotEmpty) {
        final messageData = {
          "text": messageController.text,
          "type": "text",
          "user_id": user.uid,
          "user_name": user.name,
          "user_image": user.imageUrl,
          'createdAt': DateTime.now().toUtc().millisecondsSinceEpoch,
        };
        groupRef.child('messages').push().set(messageData);
        messageController.clear();
        emit(state.copyWith(sendMessageState: RequestState.done));
      }
    } catch (e) {
      emit(state.copyWith(sendMessageState: RequestState.error, msg: e.toString()));
    }
  }

  FutureOr<void> _addMessage(StartAddMessageEvent event, Emitter<ChatState> emit) async {
    messages.insert(0, event.messageModel);
    emit(state.copyWith(addMessageState: RequestState.done));
  }

  init() {
    groupRef.child('messages').onChildAdded.listen((event) {
      final messageData = event.snapshot.value as Map<dynamic, dynamic>;
      messageData['id'] = event.snapshot.key;
      final message = MessageModel.fromMap(messageData);
      add(StartAddMessageEvent(messageModel: message));
    });
  }

  String get chatId {
    if (externalUser == null) {
      return 'group';
    } else if (user.createdAt.microsecondsSinceEpoch > externalUser!.createdAt.microsecondsSinceEpoch) {
      return externalUser!.uid + user.uid;
    } else {
      return user.uid + externalUser!.uid;
    }
  }
}
