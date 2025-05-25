import 'package:daily_fifteen/utils/size_config.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/streak_provider.dart';

class StreakBanner extends StatelessWidget {
  final int currentStreak;
  final int maxDays;
  final bool isLoading;
  final String? error;

  const StreakBanner({
    Key? key,
    required this.currentStreak,
    required this.maxDays,
    this.isLoading = false,
    this.error,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoadingBanner();
    }

    if (error != null) {
      return _buildErrorBanner(error!);
    }

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Color(0xFF1A3A8F),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '$currentStreak Day Streak!',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.local_fire_department,
                color: Colors.orange,
                size: 24.r,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'Keep going! You\'re building a habit.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 16.h),
          Stack(
            children: [
              // Background track
              Container(
                height: 8.h,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              // Progress indicator
              FractionallySizedBox(
                widthFactor: currentStreak / maxDays,
                child: Container(
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '$currentStreak/$maxDays',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingBanner() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Color(0xFF1A3A8F),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Loading streak...',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                ),
              ),
              SizedBox(width: 8.w),
              SizedBox(
                width: 24.r,
                height: 24.r,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.r,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'Fetching your streak information...',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            height: 8.h,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          SizedBox(height: 8.h),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '0/5',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBanner(String errorMessage) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Color(0xFF1A3A8F),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Streak',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.error_outline,
                color: Colors.orange,
                size: 24.r,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'Could not load streak information.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            height: 8.h,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          SizedBox(height: 8.h),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '0/5',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Create a separate widget to use with Consumer
class StreakBannerWithProvider extends StatelessWidget {
  final int maxDays;

  const StreakBannerWithProvider({
    Key? key,
    required this.maxDays,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<StreakProvider>(
      builder: (context, streakProvider, _) {
        return StreakBanner(
          currentStreak: streakProvider.currentStreak,
          maxDays: maxDays,
          isLoading: streakProvider.isLoading,
          error: streakProvider.error,
        );
      },
    );
  }
}
