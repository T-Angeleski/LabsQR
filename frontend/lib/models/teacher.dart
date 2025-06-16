class Teacher {
  final String id;
  final String fullName;

  Teacher({required this.id, required this.fullName});

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'],
      fullName: json['fullName'],
    );
  }
}
