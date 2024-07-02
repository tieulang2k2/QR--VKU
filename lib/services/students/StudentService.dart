
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vku_app/models/student.dart';
import 'package:vku_app/utils/api_consts.dart';
import 'package:http/http.dart' as http;

Future<Student> loginStudent(String username, String password) async {
    final url = Uri.parse('$BASE_URL/students/login');
    final body = jsonEncode({'username': username, 'password': password});

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Student.fromJson(json);
    } else {
      throw Exception('Failed to login');

    }
  }
  Future<Student> getStudentByStudentCode(String studentCode) async {
    final url = Uri.parse('$BASE_URL/student/$studentCode');

    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      debugPrint('response :  $json'); 
      return Student.fromJson(json);
    } else {
      debugPrint('response lỗi :  ${response.body}');
      throw Exception('Failed to login');
      
    }
  }