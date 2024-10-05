class LoginState {}

class LoginSuccessState extends LoginState {}

class LoginErrorState extends LoginState {
  String message;
  LoginErrorState({required this.message});
}

class LoginLoadingState extends LoginState {}
