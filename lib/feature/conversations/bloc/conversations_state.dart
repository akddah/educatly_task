import '../../../core/utils/enums.dart';

class ConversationsState {
  final RequestState logoutState, getUsersState;
  final String msg;

  ConversationsState({
    this.logoutState = RequestState.initial,
    this.getUsersState = RequestState.initial,
    this.msg = '',
  });

  ConversationsState copyWith({
    RequestState? logoutState,
    RequestState? getUsersState,
    String? msg,
  }) =>
      ConversationsState(
        logoutState: logoutState ?? this.logoutState,
        getUsersState: getUsersState ?? this.getUsersState,
        msg: msg ?? this.msg,
      );
}
