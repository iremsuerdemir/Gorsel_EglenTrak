import 'dart:convert';

import 'package:gorsel_programlama_proje/models/user.dart';
import 'package:gorsel_programlama_proje/services/base_url.dart';
import 'package:http/http.dart' as http;

class UserService {
  static User? _user;
  static get user => _user;

  static Future<User?> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse("${BaseUrl.baseUrl}/Users/Login"),
      headers: {
        'Content-Type':
            'application/json', // JSON formatında gönderildiğini belirt
      },
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      _user = User.fromJson(jsonDecode(response.body));
    } else {
      _user = null;
    }

    return _user;
  }

  static String? getUsername() {
    return _user?.username;
  }

  static void logout() {
    _user = null;
  }

  static Future<User?> register({
    required String email,
    required String username,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse("${BaseUrl.baseUrl}/Users"),
      headers: {
        'Content-Type':
            'application/json', // JSON formatında gönderildiğini belirt
      },
      body: jsonEncode({
        "email": email,
        "password": password,
        "userName": username,
      }),
    );

    if (response.statusCode == 201) {
      _user = User.fromJson(jsonDecode(response.body));
    } else {
      _user = null;
    }
    return _user;
  }
}
