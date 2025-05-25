import 'package:daily_fifteen/utils/size_config.dart';
import 'package:daily_fifteen/widgets/streak_indicator.dart';
import 'package:flutter/material.dart';


import '../models/user.dart';
import 'avatar_with_status.dart';

class StudyBuddyCard extends StatelessWidget {
  final User user;

  const StudyBuddyCard({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AvatarWithStatus(
            avatarUrl: user.avatar,
            size: 60.r,
            isOnline: user.isOnline,
          ),
          SizedBox(height: 8.h),
          Text(
            user.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          StreakIndicator(days: user.streakDays),
        ],
      ),
    );
  }
}
