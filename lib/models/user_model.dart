import 'dart:convert';

class Users{
  late String email;
  late String password;

  Users({required this.email, required this.password});

  Users.fromJson(Map<String, dynamic> json) {
    email = json["email"];
    password = json["password"];
  }

  Map<String, dynamic> toJson() => {
    "email": email,
    "password": password,
  };

  static String encode(List<Users> users) => json.encode(
      users.map<Map<String, dynamic>>((note) => note.toJson()).toList());

  static List<Users> decode(String users) =>
      json.decode(users).map<Users>((item) => Users.fromJson(item)).toList();
}