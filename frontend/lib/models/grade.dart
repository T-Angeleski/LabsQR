class Grade {
  final String id;
  final String studentSessionId;
  final int points;
  final int maxPoints;
  final String? note;

  Grade({
    required this.id,
    required this.studentSessionId,
    required this.points,
    required this.maxPoints,
    this.note,
  });

  String get value {
    if (maxPoints > 0) {
      final percentage = (points / maxPoints * 100).round();
      return '$points/$maxPoints ($percentage%)';
    }
    return points.toString();
  }

  String get displayValue {
    return '$points/$maxPoints';
  }

  double get percentage {
    if (maxPoints > 0) {
      return points / maxPoints * 100;
    }
    return 0.0;
  }

  String get letterGrade {
    final percent = percentage;
    if (percent >= 90) return 'A';
    if (percent >= 80) return 'B';
    if (percent >= 70) return 'C';
    if (percent >= 60) return 'D';
    return 'F';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentSessionId': studentSessionId,
      'points': points,
      'maxPoints': maxPoints,
      'note': note,
    };
  }

  factory Grade.fromJson(Map<String, dynamic> json) {
    return Grade(
      id: json['id']?.toString() ?? '',
      studentSessionId: json['studentSessionId']?.toString() ?? '',
      points: json['points'] is int
          ? json['points']
          : (json['points'] as num?)?.toInt() ?? 0,
      maxPoints: json['maxPoints'] is int
          ? json['maxPoints']
          : (json['maxPoints'] as num?)?.toInt() ?? 100,
      note: json['note']?.toString(),
    );
  }


}
