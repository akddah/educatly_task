import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/utils/extentions.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';

class ChatInputWidget extends StatefulWidget {
  const ChatInputWidget({super.key});

  @override
  State<ChatInputWidget> createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends State<ChatInputWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatBloc, ChatState>(
      listenWhen: (previous, current) => previous.sendMessageState != current.sendMessageState,
      buildWhen: (previous, current) => previous.sendMessageState == current.sendMessageState,
      listener: (context, state) {
        if (state.sendMessageState.isError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.msg)),
          );
        }
      },
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: '#1B1A1F'.color,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: context.read<ChatBloc>().messageController,
                  onSubmitted: (value) {
                    context.read<ChatBloc>().add(StartSendMessageEvent());
                  },
                  textInputAction: TextInputAction.send,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 6.h),
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Message',
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: '#808080'.color,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 6.w),
              SvgPicture.asset(
                'assets/attachment.svg',
                height: 32.h,
                width: 32.h,
              ),
              SizedBox(width: 6.w),
              SvgPicture.asset(
                'assets/record.svg',
                height: 32.h,
                width: 32.h,
              ),
            ],
          ),
        );
      },
    );
  }
}
