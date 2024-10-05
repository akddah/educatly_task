class RegisterState {}

class RegisterSuccessState extends RegisterState {}

class RegisterErrorState extends RegisterState {
  String message;
  RegisterErrorState({required this.message});
}

class RegisterLoadingState extends RegisterState {}
