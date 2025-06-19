class Grade {
  final String id;
  final int points;
  final int maxPoints;
  final String? note;

  Grade({
    required this.id,
    required this.points,
    required this.maxPoints,
    this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'points': points,
      'maxPoints': maxPoints,
      'note': note,
    };
  }

  factory Grade.fromJson(Map<String, dynamic> json) {
    return Grade(
      id: json['id'] ?? 'unknown',
      points: json['points'] ?? 0,
      maxPoints: json['maxPoints'] ?? 100,
      note: json['note'],
    );
  }

  get value => (points / maxPoints) * 100;
}
