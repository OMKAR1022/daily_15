class Challenge {
  final String challengeId;
  final String date;
  final String subject;
  final String difficulty;
  final int totalQuestions;
  final List<Question> questions;
  final int completedQuestions;
  final DateTime? expiresAt;

  Challenge({
    required this.challengeId,
    required this.date,
    required this.subject,
    required this.difficulty,
    required this.totalQuestions,
    required this.questions,
    this.completedQuestions = 0,
    this.expiresAt,
  });

  String get timeLeft {
    if (expiresAt == null) return '12 hours left';

    final now = DateTime.now();
    final difference = expiresAt!.difference(now);

    if (difference.isNegative) return 'Expired';

    if (difference.inHours > 0) {
      return '${difference.inHours} hours left';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes left';
    } else {
      return '${difference.inSeconds} seconds left';
    }
  }

  // Add back the progress getter
  String get progress {
    return '$completedQuestions/$totalQuestions';
  }

  factory Challenge.fromJson(Map<String, dynamic> json) {
    final List<dynamic> questionsJson = json['questions'] ?? [];
    final List<Question> questions = questionsJson
        .map((q) => Question.fromJson(q))
        .toList();

    DateTime? expiresAt;
    try {
      if (json['date'] != null) {
        // Assuming the date is in format YYYY-MM-DD
        final date = DateTime.parse(json['date']);
        // Set expiry to end of day
        expiresAt = DateTime(date.year, date.month, date.day, 23, 59, 59);
      }
    } catch (e) {
      print('Error parsing date: $e');
    }

    return Challenge(
      challengeId: json['challenge_id'] ?? '',
      date: json['date'] ?? '',
      subject: json['subject'] ?? '',
      difficulty: json['difficulty'] ?? '',
      totalQuestions: json['total_questions'] ?? 0,
      questions: questions,
      completedQuestions: 0, // This will be tracked client-side
      expiresAt: expiresAt,
    );
  }
}

class Question {
  final String questionId;
  final String questionText;
  final Map<String, String> options;
  final String correctAnswer;
  final String subject;
  final String difficulty;

  Question({
    required this.questionId,
    required this.questionText,
    required this.options,
    required this.correctAnswer,
    required this.subject,
    required this.difficulty,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    // Convert options from dynamic to Map<String, String>
    final Map<String, dynamic> optionsJson = json['options'] ?? {};
    final Map<String, String> options = {};

    optionsJson.forEach((key, value) {
      options[key] = value.toString();
    });

    return Question(
      questionId: json['question_id'] ?? '',
      questionText: json['question_text'] ?? '',
      options: options,
      correctAnswer: json['correct_answer'] ?? '',
      subject: json['subject'] ?? '',
      difficulty: json['difficulty'] ?? '',
    );
  }
}
