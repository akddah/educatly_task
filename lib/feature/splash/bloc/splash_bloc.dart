import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/secure_storage.dart';
import 'splash_events.dart';
import 'splash_states.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashState()) {
    on<CheckUserLoginEvent>(_checkUser);
  }
  final secureStorage = SecureStorage();
  Future<void> _checkUser(CheckUserLoginEvent event, Emitter<SplashState> emit) async {
    await Future.delayed(const Duration(seconds: 2));
    final user = await secureStorage.getUserData();
    if (user.isAuthenticated) {
      emit(UserLoginedState());
    } else {
      emit(UserUnAuthenticatedState());
    }
  }
}
