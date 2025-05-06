class User {
  int id;
  String username;
  String email;

  User({required this.id, required this.email, required this.username});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      email: json["email"],
      username: json["userName"], // "userName" yerine "username" olmalı
    );
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "email": email, "userName": username};
  }
}
