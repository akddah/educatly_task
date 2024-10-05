import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/chat_bloc.dart';
import '../bloc/chat_state.dart';
import 'users_status_widget.dart';

class ChatAppbar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      backgroundColor: Colors.black,
      title: Row(
        children: [
          BlocBuilder<ChatBloc, ChatState>(
            buildWhen: (previous, current) => previous.getUserState != current.getUserState,
            builder: (context, state) {
              if (state.getUserState.isDone) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: context.read<ChatBloc>().externalUser == null
                        ? Image.asset(
                            'assets/group.png',
                            height: 37,
                            width: 37,
                          )
                        : Image.network(
                            context.read<ChatBloc>().externalUser!.imageUrl,
                            height: 37,
                            width: 37,
                          ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<ChatBloc, ChatState>(
                  buildWhen: (previous, current) => previous.getUserState != current.getUserState,
                  builder: (context, state) {
                    return Text(
                      context.read<ChatBloc>().externalUser?.name ?? 'The Girls',
                      style: const TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  },
                ),
                UsersStatusWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
