import '../../../core/utils/enums.dart';

class ConversationsState {
  final RequestState logoutState, getUsersState, getCurrentUserState;
  final String msg;

  ConversationsState({
    this.logoutState = RequestState.initial,
    this.getUsersState = RequestState.initial,
    this.getCurrentUserState = RequestState.initial,
    this.msg = '',
  });

  ConversationsState copyWith({
    RequestState? logoutState,
    RequestState? getUsersState,
    RequestState? getCurrentUserState,
    String? msg,
  }) =>
      ConversationsState(
        logoutState: logoutState ?? this.logoutState,
        getUsersState: getUsersState ?? this.getUsersState,
        getCurrentUserState: getCurrentUserState ?? this.getCurrentUserState,
        msg: msg ?? this.msg,
      );
}
