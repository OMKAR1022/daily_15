import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import '../../utils/size_config.dart';
import '../auth/login_screen.dart';
import '../auth/register_screen.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _numPages = 3;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _markOnboardingComplete(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.markAppLaunched();
  }

  void _navigateToLogin(BuildContext context) {
    _markOnboardingComplete(context);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  void _navigateToRegister(BuildContext context) {
    _markOnboardingComplete(context);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const RegisterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            if (_currentPage < _numPages - 1)
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: TextButton(
                    onPressed: () {
                      // Skip to the last page
                      _pageController.animateToPage(
                        _numPages - 1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
              ),

            // Page content - Using Expanded to prevent overflow
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  _buildFirstPage(),
                  _buildSecondPage(),
                  _buildThirdPage(context),
                ],
              ),
            ),

            // Pagination dots
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _numPages,
                      (index) => _buildDot(index),
                ),
              ),
            ),

            // Navigation buttons
            Padding(
              padding: EdgeInsets.only(
                left: 16.w,
                right: 16.w,
                bottom: 16.h,
              ),
              child: _currentPage == _numPages - 1
              // For the last page, center the Previous button
                  ? Container(
                width: double.infinity,
                height: 50.h,
                child: OutlinedButton(
                  onPressed: () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.white.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                  child: Text(
                    'Previous',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ),
              )
              // For other pages, show the regular navigation buttons
                  : Row(
                mainAxisAlignment: _currentPage == 0
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage > 0)
                    SizedBox(
                      width: 150.w,
                      height: 50.h,
                      child: ElevatedButton(
                        onPressed: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3A5BC7),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        child: Text(
                          'Previous',
                          style: TextStyle(fontSize: 16.sp),
                        ),
                      ),
                    ),
                  if (_currentPage < _numPages - 1)
                    SizedBox(
                      width: _currentPage == 0 ? 300.w : 150.w,
                      height: 50.h,
                      child: ElevatedButton(
                        onPressed: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4169E1),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        child: Text(
                          'Next',
                          style: TextStyle(fontSize: 16.sp),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      height: 10.h,
      width: 10.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index
            ? Colors.white
            : Colors.white.withOpacity(0.5),
      ),
    );
  }

  Widget _buildFirstPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image placeholder - Reduced height to prevent overflow
            Container(
              width: double.infinity,
              height: 200.h, // Reduced from 250.h
              margin: EdgeInsets.only(bottom: 30.h), // Reduced from 40.h
              decoration: BoxDecoration(
                color: const Color(0xFF1A3A8F),
                borderRadius: BorderRadius.circular(20.r),
              ),
              // In a real app, you would use Image.asset(imagePath)
            ),

            // Title
            Text(
              'Daily MCQ Challenge',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28.sp, // Reduced from 32.sp
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 15.h), // Reduced from 20.h

            // Description
            Text(
              'Solve 15 new MCQs every day to build your knowledge and maintain your streak.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp, // Reduced from 18.sp
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image placeholder - Reduced height to prevent overflow
            Container(
              width: double.infinity,
              height: 200.h, // Reduced from 250.h
              margin: EdgeInsets.only(bottom: 30.h), // Reduced from 40.h
              decoration: BoxDecoration(
                color: const Color(0xFF1A3A8F),
                borderRadius: BorderRadius.circular(20.r),
              ),
              // In a real app, you would use Image.asset(imagePath)
            ),

            // Title
            Text(
              'Study With Friends',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28.sp, // Reduced from 32.sp
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 15.h), // Reduced from 20.h

            // Description
            Text(
              'Create groups, add friends, and compete on the leaderboard to stay motivated.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp, // Reduced from 18.sp
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThirdPage(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Light bulb icon in a circle
            Container(
              width: 100.r, // Reduced from 120.r
              height: 100.r, // Reduced from 120.r
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.lightbulb,
                color: const Color(0xFF4169E1),
                size: 50.r, // Reduced from 60.r
              ),
            ),

            SizedBox(height: 30.h), // Reduced from 40.h

            // Title
            Text(
              'Ready to Begin?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32.sp, // Reduced from 36.sp
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 15.h), // Reduced from 20.h

            // Description
            Text(
              'Start your journey to JEE/NEET success with daily practice and streak-based learning.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp, // Reduced from 18.sp
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 30.h), // Reduced from 40.h

            // Get Started button
            SizedBox(
              width: double.infinity,
              height: 50.h, // Reduced from 56.h
              child: ElevatedButton(
                onPressed: () => _navigateToRegister(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4169E1),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: Text(
                  'Get Started',
                  style: TextStyle(fontSize: 18.sp),
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // I already have an account button
            SizedBox(
              width: double.infinity,
              height: 50.h, // Reduced from 56.h
              child: OutlinedButton(
                onPressed: () => _navigateToLogin(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: Text(
                  'I already have an account',
                  style: TextStyle(fontSize: 16.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
