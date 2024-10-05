import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../login/view/login_view.dart';
import '../bloc/conversations_bloc.dart';
import '../bloc/conversations_event.dart';
import '../bloc/conversations_state.dart';
import '../widget/group_item.dart';
import '../widget/user_item.dart';

class ConversationsView extends StatefulWidget {
  const ConversationsView({super.key});

  @override
  State<ConversationsView> createState() => _ConversationsViewState();
}

class _ConversationsViewState extends State<ConversationsView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConversationsBloc()..add(StartGetConversationsEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('All Conversations'),
          leadingWidth: 90.w,
          leading: BlocConsumer<ConversationsBloc, ConversationsState>(
            listenWhen: (previous, current) => previous.logoutState != current.logoutState,
            buildWhen: (previous, current) => previous.logoutState != current.logoutState,
            listener: (context, state) {
              if (state.logoutState.isDone) {
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginView()), (route) => false);
              }
            },
            builder: (context, state) {
              return TextButton(
                onPressed: () {
                  context.read<ConversationsBloc>().add(StartLogoutEvent());
                },
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              );
            },
          ),
        ),
        body: BlocBuilder<ConversationsBloc, ConversationsState>(
          buildWhen: (previous, current) => previous.getUsersState != current.getUsersState,
          builder: (context, state) {
            if (state.getUsersState.isDone) {
              final list = context.read<ConversationsBloc>().usersList;
              return ListView(
                padding: EdgeInsets.all(16.w),
                children: [
                  const GroupItemWidget(),
                  ...List.generate(
                    list.length,
                    (i) => UserItemWidget(user: list[i]),
                  ),
                ],
              );
            } else if (state.getUsersState.isError) {
              return Center(child: Text(state.msg));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
