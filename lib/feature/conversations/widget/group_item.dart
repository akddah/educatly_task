import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/services/users_online_services.dart';
import '../../../core/utils/extentions.dart';
import '../../../models/last_seen_model.dart';
import '../../chat/view/chat_view.dart';

class GroupItemWidget extends StatefulWidget {
  const GroupItemWidget({super.key});

  @override
  State<GroupItemWidget> createState() => _GroupItemWidgetState();
}

class _GroupItemWidgetState extends State<GroupItemWidget> {
  final usersOnline = UsersOnlineServices.instance;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ChatView())),
      child: Container(
        padding: EdgeInsets.all(12.r),
        margin: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.white.withOpacity(.5)),
          color: '#121212'.color,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50.r),
              child: Image.asset(
                'assets/group.png',
                height: 50.h,
                width: 50.h,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'The Girls',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  StreamBuilder<Map<String, List<LastSeenModel>>?>(
                    stream: usersOnline.streamController.stream,
                    initialData: {'all': usersOnline.allUsers, 'online': usersOnline.onlineUsers},
                    builder: (context, snapshot) {
                      return Text(
                        '${snapshot.data?['all']?.length} members, ${snapshot.data?['online']?.length} online',
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
