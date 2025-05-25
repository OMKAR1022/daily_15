import 'package:daily_fifteen/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../../../providers/activity_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/challenge_provider.dart';
import '../../../providers/streak_provider.dart';
import '../../../providers/user_provider.dart';
import '../../../utils/constants.dart';
import '../../../widgets/activity_card.dart';
import '../../../widgets/challenge_card.dart';
import '../../../widgets/leaderboard_widget.dart';
import '../../../widgets/streak_banner.dart';
import '../../../widgets/study_buddy_card.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key, String? userId}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Schedule the API calls for after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  Future<void> _fetchData() async {
    if (!mounted) return;

    await _fetchStreakData();
    await _fetchChallenges();
  }

  Future<void> _fetchStreakData() async {
    if (!mounted) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final streakProvider = Provider.of<StreakProvider>(context, listen: false);

    if (authProvider.isAuthenticated && authProvider.token != null) {
      try {
        await streakProvider.fetchStreakFromApi(
          AppConstants.apiBaseUrl,
          authProvider.token!,
        );
      } catch (e) {
        print('Error fetching streak data: $e');
      }
    }
  }

  Future<void> _fetchChallenges() async {
    if (!mounted) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final challengeProvider = Provider.of<ChallengeProvider>(context, listen: false);

    if (authProvider.isAuthenticated && authProvider.token != null) {
      try {
        await challengeProvider.fetchTodayChallenges(
          AppConstants.apiBaseUrl,
          authProvider.token!,
        );
      } catch (e) {
        print('Error fetching challenges: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _fetchData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),

              // Streak Banner using the StreakBannerWithProvider
              StreakBannerWithProvider(maxDays: AppConstants.maxStreakDays),

              SizedBox(height: 24.h),

              // Today's Challenge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Today\'s Challenge',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Consumer<ChallengeProvider>(
                    builder: (context, challengeProvider, _) {
                      return Text(
                        challengeProvider.currentChallenge?.timeLeft ?? '12 hours left',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textSecondary,
                        ),
                      );
                    },
                  ),
                ],
              ),

              // Rest of the code remains the same...
              SizedBox(height: 12.h),

              // Challenge Card
              Consumer<ChallengeProvider>(
                builder: (context, challengeProvider, _) {
                  if (challengeProvider.isLoading) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.r),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (challengeProvider.error != null) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.r),
                        child: Column(
                          children: [
                            Text(
                              'Failed to load challenges',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16.sp,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              challengeProvider.error ?? '',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.red[300],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8.h),
                            ElevatedButton(
                              onPressed: _fetchChallenges,
                              child: Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // If no challenges are available, show a placeholder
                  if (challengeProvider.currentChallenge == null) {
                    return _buildPlaceholderChallenge();
                  }

                  return ChallengeCard(
                    challenge: challengeProvider.currentChallenge!,
                    onContinue: () {
                      // Navigate to challenge screen
                      // We'll implement this later
                    },
                  );
                },
              ),

              SizedBox(height: 24.h),

              // Study Buddies
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Study Buddies',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to all study buddies
                    },
                    child: Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              // Study Buddies List
              Consumer<UserProvider>(
                builder: (context, userProvider, _) {
                  return SizedBox(
                    height: 140.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: userProvider.studyBuddies.length,
                      separatorBuilder: (context, index) => SizedBox(width: 12.w),
                      itemBuilder: (context, index) {
                        return StudyBuddyCard(
                          user: userProvider.studyBuddies[index],
                        );
                      },
                    ),
                  );
                },
              ),

              SizedBox(height: 24.h),

              // Recent Activity
              Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 12.h),

              // Activity List
              Consumer<ActivityProvider>(
                builder: (context, activityProvider, _) {
                  return Column(
                    children: activityProvider.activities.map((activity) {
                      return ActivityCard(activity: activity);
                    }).toList(),
                  );
                },
              ),

              SizedBox(height: 24.h),

              // Leaderboard section
              Consumer<UserProvider>(
                builder: (context, userProvider, _) {
                  if (userProvider.currentUser == null) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Leaderboard',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Navigate to full leaderboard
                            },
                            child: Text(
                              'See All',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      LeaderboardWidget(
                        topUsers: userProvider.studyBuddies,
                        currentUser: userProvider.currentUser!,
                        currentUserRank: 8, // Hardcoded for now, would come from API
                      ),
                    ],
                  );
                },
              ),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderChallenge() {
    // Placeholder challenge implementation remains the same
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.assignment, color: AppColors.primary),
                SizedBox(width: 8.w),
                Text(
                  '15 Daily MCQs',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    'Mixed subjects for JEE',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: LinearProgressIndicator(
                      value: 3 / 15,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                      minHeight: 8.h,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  '3/15',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to challenge screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text('Continue Challenge'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
