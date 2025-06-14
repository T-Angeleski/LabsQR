class User {
  final String id;
  final String fullName;
  final String email;
  final String index;
  final List<String> roles;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.index,
    required this.roles,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      index: json['index'] ?? '',
      roles: [json['role']],
    );
  }
}
