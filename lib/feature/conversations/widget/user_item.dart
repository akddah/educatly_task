import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:task/core/services/users_online_services.dart';
import 'package:task/feature/chat/view/chat_view.dart';
import 'package:task/models/last_seen_model.dart';

import '../../../core/utils/extentions.dart';
import '../../../models/user_model.dart';

class UserItemWidget extends StatefulWidget {
  final UserModel user;
  const UserItemWidget({super.key, required this.user});

  @override
  State<UserItemWidget> createState() => _UserItemWidgetState();
}

class _UserItemWidgetState extends State<UserItemWidget> {
  final usersOnline = UsersOnlineServices.instance;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatView(user: widget.user))),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: '#121212'.color,
          border: Border.all(color: Colors.white.withOpacity(.5)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50.r),
              child: Image.network(
                widget.user.imageUrl,
                height: 50.h,
                width: 50.h,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.user.name,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  StreamBuilder<Map<String, List<LastSeenModel>>?>(
                    stream: usersOnline.streamController.stream,
                    initialData: {'all': usersOnline.allUsers, 'online': usersOnline.onlineUsers},
                    builder: (context, snapshot) {
                      final onlineIndex = usersOnline.allUsers.indexWhere((element) => element.userId == widget.user.uid);
                      if (onlineIndex == -1) return const SizedBox.shrink();
                      return Text(
                        usersOnline.allUsers[onlineIndex].lastSeen.isAfter(DateTime.now().subtract(const Duration(minutes: 6)))
                            ? 'Online'
                            : 'Last seen ${DateFormat('hh:mm a').format(usersOnline.allUsers[onlineIndex].lastSeen)}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.5),
                          fontWeight: FontWeight.w400,
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
