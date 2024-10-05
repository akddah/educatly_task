import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/core/utils/helper_methods.dart';

import '../../../core/services/secure_storage.dart';
import '../../../core/services/user_presence_service.dart';
import '../../../core/services/users_online_services.dart';
import '../../../core/utils/enums.dart';
import '../../../models/user_model.dart';
import 'conversations_event.dart';
import 'conversations_state.dart';

class ConversationsBloc extends Bloc<ConversationsEvent, ConversationsState> {
  ConversationsBloc() : super(ConversationsState()) {
    UsersOnlineServices.instance.init();
    _userPresenceService = UserPresenceService();
    _userPresenceService.init();
    on<StartLogoutEvent>(_logout);
    on<StartGetConversationsEvent>(_getConversations);
  }

  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore usersRef = FirebaseFirestore.instance;
  late UserPresenceService _userPresenceService;

  final _secureStorage = SecureStorage();
  late final UserModel user = _secureStorage.user!;
  List<UserModel> usersList = [];

  @override
  Future<void> close() {
    _userPresenceService.dispose();
    UsersOnlineServices.instance.dispose();
    return super.close();
  }

  Future<void> _logout(StartLogoutEvent event, Emitter<ConversationsState> emit) async {
    try {
      emit(state.copyWith(logoutState: RequestState.loading));
      showLoadingDialog();
      await _auth.signOut();
      await _secureStorage.deleteUserData();
      emit(state.copyWith(logoutState: RequestState.done, msg: 'Logout successful'));
    } catch (e) {
      hideLoadingDialog();
      emit(state.copyWith(logoutState: RequestState.error, msg: e.toString()));
    }
  }

  FutureOr<void> _getConversations(StartGetConversationsEvent event, Emitter<ConversationsState> emit) async {
    try {
      emit(state.copyWith(getUsersState: RequestState.loading));
      final snapshot = await usersRef.collection('users').get();

      final json = snapshot.docs.map((e) => e.data()).toList();

      usersList = List<UserModel>.from(json.map((e) => UserModel.fromMap(e)));
      usersList.removeWhere((element) => element.uid == user.uid);

      emit(state.copyWith(getUsersState: RequestState.done));
    } catch (e) {
      emit(state.copyWith(getUsersState: RequestState.error, msg: 'Error getting users: $e'));
    }
  }
}
