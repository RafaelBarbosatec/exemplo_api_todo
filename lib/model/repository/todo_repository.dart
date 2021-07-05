import 'dart:convert';

import 'package:todo_lovepeople/core/local_preferences.dart';
import 'package:http/http.dart' as http;
import '../todo.dart';

class TodoRepository {
  final String baseUrl;
  final LocalPreferences _localPreferences;

  TodoRepository(this.baseUrl, this._localPreferences);

  Future<List<Todo>> getTodoList() async {
    final login = await _localPreferences.getLogin();
    Map<String, String> header = {
      'Authorization': 'Bearer ${login?.jwt}',
    };
    return http
        .get(Uri.parse('$baseUrl/todos'), headers: header)
        .then((value) async {
      if (value.statusCode == 200) {
        List json = jsonDecode(value.body);
        return json.map((e) => Todo.fromJson(e)).toList();
      } else {
        return [];
      }
    });
  }

  Future<Todo?> register(Todo todo) async {
    final login = await _localPreferences.getLogin();
    Map<String, String> header = {
      'Authorization': 'Bearer ${login?.jwt}',
    };
    return http
        .post(
      Uri.parse('$baseUrl/todos'),
      headers: header,
      body: todo.toJson(),
    )
        .then((value) async {
      if (value.statusCode == 200) {
        final json = jsonDecode(value.body);
        return Todo.fromJson(json);
      } else {
        return null;
      }
    });
  }

  Future<Todo?> delete(int? todoId) async {
    final login = await _localPreferences.getLogin();
    Map<String, String> header = {
      'Authorization': 'Bearer ${login?.jwt}',
    };
    return http
        .delete(
      Uri.parse('$baseUrl/todos/$todoId'),
      headers: header,
    )
        .then((value) async {
      if (value.statusCode == 200) {
        final json = jsonDecode(value.body);
        return Todo.fromJson(json);
      } else {
        return null;
      }
    });
  }
}
