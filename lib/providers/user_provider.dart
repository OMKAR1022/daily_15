import 'package:flutter/material.dart';

import '../models/user.dart';


class UserProvider with ChangeNotifier {
  User? _currentUser;
  List<User> _studyBuddies = [];
  int _currentStreak = 0;
  int _maxStreakDays = 5; // For the streak display UI
  String? _userId;

  User? get currentUser => _currentUser;
  List<User> get studyBuddies => _studyBuddies;
  int get currentStreak => _currentStreak;
  int get maxStreakDays => _maxStreakDays;
  String? get userId => _userId;

  // For the leaderboard
  List<User> get leaderboard {
    final sortedUsers = [..._studyBuddies];
    sortedUsers.sort((a, b) => b.streakDays.compareTo(a.streakDays));
    return sortedUsers;
  }

  // Get user rank in leaderboard
  int getUserRank(String userId) {
    final sortedUsers = leaderboard;
    for (int i = 0; i < sortedUsers.length; i++) {
      if (sortedUsers[i].id == userId) {
        return i + 1;
      }
    }
    return -1;
  }

  // Initialize with mock data or userId
  void initialize({String? userId}) {
    _userId = userId;
    print('UserProvider initialized with userId: $_userId');

    // In a real app, you would fetch user data based on userId
    // For now, we'll use mock data
    _currentUser = User(
      id: userId ?? 'current-user',
      name: 'You',
      avatar: 'assets/images/avatar_placeholder.png',
      streakDays: 5,
    );

    _currentStreak = 5;

    _studyBuddies = [
      User(
        id: 'user1',
        name: 'Rahul S.',
        avatar: 'assets/images/avatar_placeholder.png',
        streakDays: 7,
        isOnline: true,
      ),
      User(
        id: 'user2',
        name: 'Priya K.',
        avatar: 'assets/images/avatar_placeholder.png',
        streakDays: 4,
        isOnline: false,
      ),
      User(
        id: 'user3',
        name: 'Amit R.',
        avatar: 'assets/images/avatar_placeholder.png',
        streakDays: 9,
        isOnline: true,
      ),
      // Add more users for the leaderboard
      User(
        id: 'user4',
        name: 'Neha G.',
        avatar: 'assets/images/avatar_placeholder.png',
        streakDays: 6,
      ),
      User(
        id: 'user5',
        name: 'Vikram M.',
        avatar: 'assets/images/avatar_placeholder.png',
        streakDays: 5,
      ),
      User(
        id: 'user6',
        name: 'Ananya P.',
        avatar: 'assets/images/avatar_placeholder.png',
        streakDays: 3,
      ),
      User(
        id: 'user7',
        name: 'Rohan K.',
        avatar: 'assets/images/avatar_placeholder.png',
        streakDays: 8,
      ),
      User(
        id: 'user8',
        name: 'Shreya T.',
        avatar: 'assets/images/avatar_placeholder.png',
        streakDays: 2,
      ),
      User(
        id: 'user9',
        name: 'Arjun S.',
        avatar: 'assets/images/avatar_placeholder.png',
        streakDays: 7,
      ),
      User(
        id: 'user10',
        name: 'Kavita R.',
        avatar: 'assets/images/avatar_placeholder.png',
        streakDays: 4,
      ),
      User(
        id: 'user11',
        name: 'Deepak J.',
        avatar: 'assets/images/avatar_placeholder.png',
        streakDays: 3,
      ),
      User(
        id: 'user12',
        name: 'Meera L.',
        avatar: 'assets/images/avatar_placeholder.png',
        streakDays: 6,
      ),
    ];

    notifyListeners();
  }

  // Methods to be implemented later for API integration
  Future<void> fetchCurrentUser() async {
    // API call will go here
  }

  Future<void> fetchStudyBuddies() async {
    // API call will go here
  }

  Future<void> fetchUserStreak() async {
    // API call will go here
  }
}
