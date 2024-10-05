import '../../../core/utils/enums.dart';

class ChatState {
  final RequestState sendMessageState, addMessageState;
  final String msg;

  ChatState({
    this.addMessageState = RequestState.initial,
    this.sendMessageState = RequestState.initial,
    this.msg = '',
  });

  ChatState copyWith({
    RequestState? sendMessageState,
    RequestState? addMessageState,
    String? msg,
  }) =>
      ChatState(
        addMessageState: addMessageState ?? this.addMessageState,
        sendMessageState: sendMessageState ?? this.sendMessageState,
        msg: msg ?? this.msg,
      );
}
