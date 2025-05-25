import 'package:daily_fifteen/screens/home/tabs/friends_tab.dart';
import 'package:daily_fifteen/screens/home/tabs/home_tab.dart';
import 'package:daily_fifteen/screens/home/tabs/subjects_tab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/activity_provider.dart';
import '../../providers/challenge_provider.dart';
import '../../providers/streak_provider.dart';
import '../../providers/user_provider.dart';
import '../../utils/constants.dart';
import '../../utils/size_config.dart' show SizeConfig, SizeExtension;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _currentIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Extract userId from route arguments
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args.containsKey('userId')) {
      _userId = args['userId'];
      print('Received userId: $_userId');

      // Initialize providers with the userId
      _initializeProviders();
    } else {
      print('No userId received, using default');
      _initializeProviders();
    }
  }

  void _initializeProviders() {
    // Initialize providers with user ID
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final activityProvider = Provider.of<ActivityProvider>(context, listen: false);
      final challengeProvider = Provider.of<ChallengeProvider>(context, listen: false);
      final streakProvider = Provider.of<StreakProvider>(context, listen: false);

      // Initialize providers with userId if available
      userProvider.initialize(userId: _userId);
      challengeProvider.initialize(userId: _userId);
      streakProvider.initialize(userId: _userId);

      // Initialize activity provider after user provider to use the user data
      activityProvider.initialize(userProvider.studyBuddies);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.lightbulb_outline,
                color: Colors.white,
                size: 20.r,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              'DailyMCQ',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
              ),
            ),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(
                  Icons.notifications_none_outlined,
                  color: AppColors.textPrimary,
                ),
                onPressed: () {
                  // Handle notifications
                },
              ),
              Positioned(
                right: 8.r,
                top: 8.r,
                child: Container(
                  padding: EdgeInsets.all(4.r),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '2',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Consumer<UserProvider>(
            builder: (context, userProvider, _) {
              return Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: GestureDetector(
                  onTap: () {
                    // Navigate to profile
                  },
                  child: CircleAvatar(
                    radius: 16.r,
                    backgroundColor: AppColors.primary,
                    backgroundImage: userProvider.currentUser != null
                        ? AssetImage(userProvider.currentUser!.avatar)
                        : null,
                  ),
                ),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          tabs: [
            Tab(text: 'Home'),
            Tab(text: 'Subjects'),
            Tab(text: 'Friends'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          HomeTab(userId: _userId),
          SubjectsTab(),
          FriendsTab(),
        ],
      ),
    );
  }
}
