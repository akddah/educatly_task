import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/utils/extentions.dart';
import '../../conversations/view/conversations_view.dart';
import '../bloc/register_bloc.dart';
import '../bloc/register_events.dart';
import '../bloc/register_states.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sign Up'),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: ['#1D1C1E'.color, '#4F3A6E'.color, '#3C2C55'.color],
                begin: AlignmentDirectional.centerStart,
                end: AlignmentDirectional.centerEnd,
              ),
            ),
          ),
        ),
        body: BlocConsumer<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccessState) {
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const ConversationsView()), (route) => false);
            } else if (state is RegisterErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            final bloc = context.read<RegisterBloc>();
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 32.0),
                  GestureDetector(
                    onTap: () {
                      picker.pickImage(source: ImageSource.gallery).then((image) {
                        if (image == null) return;
                        bloc.imageFile = File(image.path);
                        setState(() {});
                      });
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: bloc.imageFile != null ? FileImage(bloc.imageFile!) : null,
                      child: bloc.imageFile == null ? const Icon(Icons.camera_alt, size: 50) : null,
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  TextFormField(
                    controller: context.read<RegisterBloc>().nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      hintText: 'Enter your full name',
                    ),
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: context.read<RegisterBloc>().emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email address',
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: context.read<RegisterBloc>().passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 32.0),
                  ElevatedButton(
                    onPressed: () {
                      if (state is! RegisterLoadingState) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        bloc.add(StartRegisterEvent());
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: "Already have an account?",
                          style: TextStyle(fontSize: 16),
                        ),
                        const TextSpan(text: ' '),
                        TextSpan(
                          text: "Login",
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).primaryColor,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
