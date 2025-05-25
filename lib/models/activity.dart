import 'package:daily_fifteen/models/user.dart';


enum ActivityType {
  challengeCompleted,
  streakReached,
  other
}

class Activity {
  final String id;
  final User user;
  final ActivityType type;
  final String message;
  final String? additionalInfo;
  final DateTime timestamp;
  final int? likes;
  final int? comments;

  Activity({
    required this.id,
    required this.user,
    required this.type,
    required this.message,
    this.additionalInfo,
    required this.timestamp,
    this.likes,
    this.comments,
  });

  String get timeAgo {
    final difference = DateTime.now().difference(timestamp);
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
