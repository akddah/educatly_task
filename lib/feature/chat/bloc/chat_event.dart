import '../../../models/message_model.dart';

class ChatEvent {}


class StartSendMessageEvent extends ChatEvent {}

class StartAddMessageEvent extends ChatEvent {
  final MessageModel messageModel;
  StartAddMessageEvent({required this.messageModel});
}

class StartUpdateUsersTypingEvent extends ChatEvent {}
