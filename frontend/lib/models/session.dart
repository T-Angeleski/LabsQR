class Session {
  final String id;
  final String createdAt;
  final int durationInMinutes;
  final Map<String, dynamic>? teacher;
  final Map<String, dynamic>? subject;

  Session({
    required this.id,
    required this.createdAt,
    required this.durationInMinutes,
    this.teacher,
    this.subject,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'],
      createdAt: json['createdAt'],
      durationInMinutes: json['durationInMinutes'],
      teacher: json['teacher'],
      subject: json['subject'],
    );
  }
}