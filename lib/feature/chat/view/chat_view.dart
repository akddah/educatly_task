import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' hide TextDirection;

import '../../../core/utils/extentions.dart';
import '../../../models/user_model.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_state.dart';
import '../widget/chat_appbar.dart';
import '../widget/chat_input.dart';

class ChatView extends StatefulWidget {
  final UserModel? user;
  const ChatView({super.key, this.user});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc(widget.user)..init(),
      child: Scaffold(
        backgroundColor: '#121212'.color,
        appBar: const ChatAppbar(),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  final bloc = context.read<ChatBloc>();
                  return ListView.separated(
                    padding: EdgeInsets.only(right: 16, left: 16, top: MediaQuery.of(context).padding.top + 50, bottom: 16),
                    separatorBuilder: (context, index) {
                      final height = bloc.messages[index].userId == bloc.messages[index + 1].userId ? 4.0 : 12.0;
                      return SizedBox(height: height);
                    },
                    reverse: true,
                    itemCount: bloc.messages.length,
                    itemBuilder: (context, index) {
                      final isMe = bloc.messages[index].userId == bloc.user.uid;
                      return Directionality(
                        textDirection: isMe ? TextDirection.rtl : TextDirection.ltr,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (!isMe) ...[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: (() {
                                  if (index == 0 || bloc.messages[index].userId != bloc.messages[index - 1].userId) {
                                    return Image.network(
                                      bloc.messages[index].userImage,
                                      height: 28,
                                      width: 28,
                                    );
                                  } else {
                                    return const SizedBox(height: 28, width: 28);
                                  }
                                })(),
                              ),
                              const SizedBox(width: 4)
                            ],
                            Container(
                              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isMe ? '#048067'.color : '#333333'.color,
                                borderRadius: const BorderRadiusDirectional.only(
                                  topStart: Radius.circular(12),
                                  topEnd: Radius.circular(12),
                                  bottomEnd: Radius.circular(12),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (!isMe && (index == bloc.messages.length - 1 || bloc.messages[index].userId != bloc.messages[index + 1].userId))
                                        Text(
                                          bloc.messages[index].userName,
                                          style: TextStyle(
                                            color: bloc.messages[index].userId.getUniqueColorFromId,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                          ),
                                        ),
                                      Text(
                                        bloc.messages[index].text,
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    DateFormat('hh:mm a').format(bloc.messages[index].createdAt),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const ChatInputWidget(),
          ],
        ),
      ),
    );
  }
}
