import 'package:flutter/material.dart';


import '../models/activity.dart';
import '../models/user.dart';

class ActivityProvider with ChangeNotifier {
  List<Activity> _activities = [];

  List<Activity> get activities => _activities;

  // Initialize with mock data
  void initialize(List<User> users) {
    final rahul = users.firstWhere((user) => user.name.contains('Rahul'));
    final priya = users.firstWhere((user) => user.name.contains('Priya'));

    _activities = [
      Activity(
        id: 'activity1',
        user: rahul,
        type: ActivityType.challengeCompleted,
        message: 'Completed today\'s challenge with 92% accuracy!',
        additionalInfo: '15/15 completed',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      Activity(
        id: 'activity2',
        user: priya,
        type: ActivityType.streakReached,
        message: 'Just reached a 4-day streak! Who\'s with me?',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        likes: 0,
        comments: 0,
      ),
    ];

    notifyListeners();
  }

  void likeActivity(String activityId) {
    final index = _activities.indexWhere((activity) => activity.id == activityId);
    if (index != -1) {
      final activity = _activities[index];
      final updatedActivity = Activity(
        id: activity.id,
        user: activity.user,
        type: activity.type,
        message: activity.message,
        additionalInfo: activity.additionalInfo,
        timestamp: activity.timestamp,
        likes: (activity.likes ?? 0) + 1,
        comments: activity.comments,
      );

      _activities[index] = updatedActivity;
      notifyListeners();
    }
  }

  // Methods to be implemented later for API integration
  Future<void> fetchActivities() async {
    // API call will go here
  }

  Future<void> postComment(String activityId, String comment) async {
    // API call will go here
  }
}
