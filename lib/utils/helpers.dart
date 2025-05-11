import 'package:intl/intl.dart';

// Helper functions for common operations
// Features:
// - Date formatting and comparison
// - Time formatting
// - Date key generation for deterministic selection
// - Group code generation
// - Difficulty level label mapping

// Format date to readable string
String formatDate(DateTime date) {
  return DateFormat('MMM d, yyyy').format(date);
}

// Format time (seconds) to mm:ss
String formatTime(int seconds) {
  final minutes = seconds ~/ 60;
  final remainingSeconds = seconds % 60;
  return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
}

// Get date key for deterministic selection (YYYYMMDD format)
int getDateKey(DateTime date) {
  return int.parse(DateFormat('yyyyMMdd').format(date));
}

// Check if two dates are the same day
bool isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}

// Check if a date is yesterday
bool isYesterday(DateTime date) {
  final now = DateTime.now();
  final yesterday = DateTime(now.year, now.month, now.day - 1);
  return isSameDay(date, yesterday);
}

// Generate a random 6-digit group code
String generateGroupCode() {
  return (100000 + DateTime.now().millisecondsSinceEpoch % 900000).toString();
}

// Get difficulty label from numeric value
String getDifficultyLabel(int difficulty) {
  switch (difficulty) {
    case 1:
      return 'Very Easy';
    case 2:
      return 'Easy';
    case 3:
      return 'Medium';
    case 4:
      return 'Hard';
    case 5:
      return 'Very Hard';
    default:
      return 'Medium';
  }
}
