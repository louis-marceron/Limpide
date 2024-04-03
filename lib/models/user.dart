class User {
  final String userId;
  final String email;

  User({required this.userId, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
    };
  }
}
