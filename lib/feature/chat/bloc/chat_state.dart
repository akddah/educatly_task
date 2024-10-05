import '../../../core/utils/enums.dart';

class ChatState {
  final RequestState getUserState, sendMessageState, addMessageState;
  final String msg;

  ChatState({
    this.addMessageState = RequestState.initial,
    this.getUserState = RequestState.initial,
    this.sendMessageState = RequestState.initial,
    this.msg = '',
  });

  ChatState copyWith({
    RequestState? getUserState,
    RequestState? sendMessageState,
    RequestState? addMessageState,
    String? msg,
  }) =>
      ChatState(
        getUserState: getUserState ?? this.getUserState,
        addMessageState: addMessageState ?? this.addMessageState,
        sendMessageState: sendMessageState ?? this.sendMessageState,
        msg: msg ?? this.msg,
      );
}
