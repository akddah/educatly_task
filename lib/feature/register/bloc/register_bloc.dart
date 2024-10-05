import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/secure_storage.dart';
import '../../../core/utils/helper_methods.dart';
import 'register_events.dart';
import 'register_states.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterState()) {
    on<StartRegisterEvent>(_register);
  }

  final _secureStorage = SecureStorage();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _store = FirebaseFirestore.instance;

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  File? imageFile;

  FutureOr<void> _register(StartRegisterEvent event, Emitter<RegisterState> emit) async {
    if (imageFile == null) {
      emit(RegisterErrorState(message: 'Please select an image'));
      return;
    }
    try {
      emit(RegisterLoadingState());
      showLoadingDialog();
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      await _storeUser(userCredential.user!.uid);
      emit(RegisterSuccessState());
    } on FirebaseAuthException catch (e) {
      emit(RegisterErrorState(message: e.message ?? 'Something went wrong'));
    } on FirebaseException catch (e) {
      emit(RegisterErrorState(message: e.message ?? 'Something went wrong'));
    } catch (e) {
      emit(RegisterErrorState(message: e.toString()));
    } finally {
      hideLoadingDialog();
    }
  }

  _storeUser(String uid) async {
    String filePath = 'user_images/$uid.${imageFile!.path.split('.').last}';
    await _storage.ref(filePath).putFile(imageFile!);
    String imageUrl = await _storage.ref(filePath).getDownloadURL();
    final createdAt = DateTime.now().toUtc().millisecondsSinceEpoch;
    _store.collection('users').doc(uid).set({
      'uid': uid,
      'name': nameController.text.trim(),
      'email': emailController.text.trim(),
      'imageUrl': imageUrl,
      'createdAt': createdAt.toString(),
    });
    await _secureStorage.saveUserData(
      uid: uid,
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      imageUrl: imageUrl,
      createdAt: createdAt.toString(),
    );
  }
}
