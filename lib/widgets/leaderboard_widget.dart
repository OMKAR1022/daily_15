import 'package:daily_fifteen/utils/size_config.dart';
import 'package:flutter/material.dart';


import '../models/user.dart';
import '../utils/constants.dart';

class LeaderboardWidget extends StatelessWidget {
  final List<User> topUsers;
  final User currentUser;
  final int currentUserRank;

  const LeaderboardWidget({
    Key? key,
    required this.topUsers,
    required this.currentUser,
    required this.currentUserRank,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sort users by streak days in descending order
    final sortedUsers = [...topUsers];
    sortedUsers.sort((a, b) => b.streakDays.compareTo(a.streakDays));

    return Column(
      children: [
        // Top 3 podium - simplified to avoid overflow
        Container(
          height: 120.h,
          decoration: BoxDecoration(
            color: Color(0xFF1A3A8F),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // 2nd place
              if (sortedUsers.length > 1)
                _buildTopUser(sortedUsers[1], 2),

              // 1st place
              if (sortedUsers.isNotEmpty)
                _buildTopUser(sortedUsers[0], 1),

              // 3rd place
              if (sortedUsers.length > 2)
                _buildTopUser(sortedUsers[2], 3),
            ],
          ),
        ),

        SizedBox(height: 16.h),

        // List of other users (positions 4-10)
        ...List.generate(
          // Show up to 7 more users (positions 4-10)
          sortedUsers.length > 3 ?
          (sortedUsers.length > 10 ? 7 : sortedUsers.length - 3) : 0,
              (index) {
            final userIndex = index + 3; // Start from position 4
            if (userIndex < sortedUsers.length) {
              return _buildLeaderboardItem(
                sortedUsers[userIndex],
                userIndex + 1, // Position is index + 1
              );
            }
            return SizedBox.shrink();
          },
        ),

        SizedBox(height: 16.h),

        // Current user position (if not in top 10)
        if (currentUserRank > 10)
          _buildCurrentUserItem(),
      ],
    );
  }

  Widget _buildTopUser(User user, int position) {
    final medalColors = {
      1: Colors.amber, // Gold
      2: Colors.grey.shade300, // Silver
      3: Colors.brown.shade300, // Bronze
    };

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 30.r,
              backgroundColor: Colors.white,
              backgroundImage: AssetImage(user.avatar),
            ),
            Container(
              padding: EdgeInsets.all(4.r),
              decoration: BoxDecoration(
                color: medalColors[position] ?? Colors.grey,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Text(
                '$position',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                  color: position == 1 ? Colors.black : Colors.white,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          user.name.split(' ')[0], // First name only
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14.sp,
          ),
        ),
        Text(
          '${user.streakDays} days',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboardItem(User user, int position) {
    return Container(
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 24.r,
            height: 24.r,
            decoration: BoxDecoration(
              color: AppColors.background,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$position',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          CircleAvatar(
            radius: 16.r,
            backgroundImage: AssetImage(user.avatar),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              user.name,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '${user.streakDays} days',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentUserItem() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
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
      child: Row(
        children: [
          Container(
            width: 30.r,
            height: 30.r,
            decoration: BoxDecoration(
              color: AppColors.background,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$currentUserRank',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          CircleAvatar(
            radius: 20.r,
            backgroundImage: AssetImage(currentUser.avatar),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                currentUser.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
              Text(
                '${currentUser.streakDays} day streak',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          Spacer(),
          ElevatedButton(
            onPressed: () {
              // Handle improve action
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            ),
            child: Text('Improve'),
          ),
        ],
      ),
    );
  }
}
