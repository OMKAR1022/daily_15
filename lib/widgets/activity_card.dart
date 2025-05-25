import 'package:daily_fifteen/utils/size_config.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';


import '../models/activity.dart';
import '../providers/activity_provider.dart';
import '../utils/constants.dart';
import 'avatar_with_status.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;

  const ActivityCard({
    Key? key,
    required this.activity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with avatar and time
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AvatarWithStatus(
                avatarUrl: activity.user.avatar,
                size: 40.r,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.user.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                    Text(
                      activity.message,
                      style: TextStyle(
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                activity.timeAgo,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),

          // Additional info if available
          if (activity.additionalInfo != null)
            Container(
              margin: EdgeInsets.only(top: 12.h, left: 52.w),
              padding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 6.h,
              ),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 16.r,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Daily Challenge',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Spacer(),
                  Text(
                    activity.additionalInfo!,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),

          // Like and comment buttons if available
          if (activity.likes != null || activity.comments != null)
            Padding(
              padding: EdgeInsets.only(top: 12.h, left: 52.w),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Provider.of<ActivityProvider>(context, listen: false)
                          .likeActivity(activity.id);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.thumb_up_outlined,
                          size: 18.r,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'Like',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.w),
                  InkWell(
                    onTap: () {
                      // Handle comment
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 18.r,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'Comment',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
