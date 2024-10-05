import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../conversations/view/conversations_view.dart';
import '../../login/view/login_view.dart';
import '../bloc/splash_bloc.dart';
import '../bloc/splash_events.dart';
import '../bloc/splash_states.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashBloc()..add(CheckUserLoginEvent()),
      child: Scaffold(
        body: BlocListener<SplashBloc, SplashState>(
          listener: (context, state) {
            if (state is UserLoginedState) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const ConversationsView()),
                (route) => false,
              );
            } else if (state is UserUnAuthenticatedState) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginView()),
                (route) => false,
              );
            }
          },
          child: Center(
            child: Icon(
              CupertinoIcons.chat_bubble_text_fill,
              size: 100,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
