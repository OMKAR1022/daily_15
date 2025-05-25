class User {
  final String id;
  final String name;
  final String avatar;
  final int streakDays;
  final bool isOnline;

  User({
    required this.id,
    required this.name,
    required this.avatar,
    required this.streakDays,
    this.isOnline = false,
  });
}
