import 'dart:convert';

import 'package:http/http.dart';

class NetworkService {
  final baseUrl = 'http://192.168.0.7:4000';

  Future<List<dynamic>> fetchTodos() async {
    try {
      final response = await get(Uri.parse(baseUrl + '/todos'));
      return jsonDecode(response.body) as List;
    } catch (e) {
      return [];
    }
  }

  Future<bool> patchTodo(Map<String, String> patchObject, int id) async {
    try {
      await patch(Uri.parse(baseUrl + '/todos/$id'), body: patchObject);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Map?> addTodo(Map<String, String> todoObj) async {
    try {
      final response = await post(Uri.parse(baseUrl + '/todos'), body: todoObj);
      return jsonDecode(response.body);
    } catch (e) {
      return null;
    }
  }
}
