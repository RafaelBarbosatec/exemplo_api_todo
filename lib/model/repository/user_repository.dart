import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:todo_lovepeople/core/local_preferences.dart';
import 'package:todo_lovepeople/model/login_response.dart';

class UserRepository {
  final String baseUrl;
  final LocalPreferences _localPreferences;

  UserRepository(this.baseUrl, this._localPreferences);

  Future<LoginResponse?> login(String email, String senha) {
    Map body = {
      'identifier': email,
      'password': senha,
    };
    return http
        .post(Uri.parse('$baseUrl/auth/local'), body: body)
        .then((value) async {
      if (value.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(value.body);
        final login = LoginResponse.fromJson(json);
        _localPreferences.saveLogin(login);
        return login;
      } else {
        return null;
      }
    });
  }

  Future<LoginResponse?> register(String name, String email, String password) {
    Map body = {
      'username': name,
      'email': email,
      'password': password,
    };
    return http
        .post(Uri.parse('$baseUrl/auth/local/register'), body: body)
        .then((value) async {
      if (value.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(value.body);
        final login = LoginResponse.fromJson(json);
        _localPreferences.saveLogin(login);
        return login;
      } else {
        return null;
      }
    });
  }

  Future<LoginResponse?> getLogin() {
    return _localPreferences.getLogin();
  }

  Future<void> logout() {
    return _localPreferences.deleteLogin();
  }
}
