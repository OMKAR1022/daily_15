import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/streak_service.dart';

// Streak provider - manages user streak data
class StreakProvider extends ChangeNotifier {
  int _currentStreak = 0;
  int _maxStreak = 0;
  late DateTime _lastCompletedDate;
  bool _isLoading = false;
  String? _error;
  String? _userId;

  // Constructor - load streak data
  StreakProvider() {
    _loadStreakData();
  }

  // Getters
  int get currentStreak => _currentStreak;
  int get maxStreak => _maxStreak;
  DateTime get lastCompletedDate => _lastCompletedDate;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get userId => _userId;

  // Initialize with userId
  void initialize({String? userId}) {
    _userId = userId;
    print('StreakProvider initialized with userId: $_userId');
    notifyListeners();
  }

  // Fetch streak data from API
  Future<void> fetchStreakFromApi(String baseUrl, String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final streakData = await StreakService.fetchUserStreak(
        baseUrl,
        token,
        userId: _userId,
      );

      _currentStreak = streakData['current_streak'] ?? 0;
      _maxStreak = streakData['max_streak'] ?? 0;

      if (streakData['last_completed_date'] != null) {
        _lastCompletedDate = DateTime.parse(streakData['last_completed_date']);
      } else {
        _lastCompletedDate = DateTime(2000); // A date in the past
      }

      // Save to local storage for offline access
      _saveStreakData();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();

      // If API fails, fall back to local data
      await _loadStreakData();
    }
  }

  // Increment streak when daily MCQs are completed
  void incrementStreak() {
    final today = DateTime.now();
    final yesterday = DateTime(today.year, today.month, today.day - 1);

    // Check if last completion was yesterday or today
    if (_lastCompletedDate.year == today.year &&
        _lastCompletedDate.month == today.month &&
        _lastCompletedDate.day == today.day) {
      // Already completed today, no streak increment
      return;
    } else if (_lastCompletedDate.year == yesterday.year &&
        _lastCompletedDate.month == yesterday.month &&
        _lastCompletedDate.day == yesterday.day) {
      // Completed yesterday, increment streak
      _currentStreak++;
    } else {
      // Streak broken, reset to 1
      _currentStreak = 1;
    }

    // Update max streak if needed
    if (_currentStreak > _maxStreak) {
      _maxStreak = _currentStreak;
    }

    // Update last completed date
    _lastCompletedDate = today;

    // Save streak data
    _saveStreakData();
    notifyListeners();
  }

  // Reset streak (for testing or admin purposes)
  void resetStreak() {
    _currentStreak = 0;
    _lastCompletedDate = DateTime(2000); // A date in the past
    _saveStreakData();
    notifyListeners();
  }

  // Load streak data from SharedPreferences
  Future<void> _loadStreakData() async {
    final prefs = await SharedPreferences.getInstance();
    _currentStreak = prefs.getInt('currentStreak') ?? 0;
    _maxStreak = prefs.getInt('maxStreak') ?? 0;

    final lastCompletedString = prefs.getString('lastCompletedDate');
    if (lastCompletedString != null) {
      _lastCompletedDate = DateTime.parse(lastCompletedString);
    } else {
      _lastCompletedDate = DateTime(2000); // A date in the past
    }

    // Check if streak should be reset (missed a day)
    final today = DateTime.now();
    final yesterday = DateTime(today.year, today.month, today.day - 1);

    if (_lastCompletedDate.year != today.year ||
        _lastCompletedDate.month != today.month ||
        _lastCompletedDate.day != today.day) {
      if (_lastCompletedDate.year != yesterday.year ||
          _lastCompletedDate.month != yesterday.month ||
          _lastCompletedDate.day != yesterday.day) {
        // More than one day missed, reset streak
        if (_currentStreak > 0) {
          _currentStreak = 0;
          _saveStreakData();
        }
      }
    }

    notifyListeners();
  }

  // Save streak data to SharedPreferences
  Future<void> _saveStreakData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentStreak', _currentStreak);
    await prefs.setInt('maxStreak', _maxStreak);
    await prefs.setString('lastCompletedDate', _lastCompletedDate.toIso8601String());
  }
}
