import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/core/services/secure_storage.dart';
import 'package:task/core/utils/helper_methods.dart';
import 'package:task/feature/login/bloc/login_events.dart';
import 'package:task/feature/login/bloc/login_states.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState()) {
    on<StartLoginEvent>(_login);
  }

  final _secureStorage = SecureStorage();
  final _auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  FutureOr<void> _login(LoginEvent event, Emitter<LoginState> emit) async {
    try {
      emit(LoginLoadingState());
      showLoadingDialog();
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      await _getUserData(userCredential.user);
      emit(LoginSuccessState());
    } catch (e) {
      emit(LoginErrorState(message: e.toString()));
    } finally {
      hideLoadingDialog();
    }
  }

  _getUserData(User? user) async {
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        var userData = userDoc.data() as Map<String, dynamic>;
        String name = userData['name'] ?? '';
        String email = userData['email'] ?? '';
        String imageUrl = userData['imageUrl'] ?? '';
        String createdAt = userData['createdAt']?.toString() ?? '';
        _secureStorage.saveUserData(uid: user.uid, name: name, email: email, imageUrl: imageUrl, createdAt: createdAt);
      } else {
        throw 'User document does not exist!';
      }
    }
  }
}
