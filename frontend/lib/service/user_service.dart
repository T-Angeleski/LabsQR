import 'package:flutter/material.dart';
import 'package:frontend/models/teacher.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/util/service_helpers.dart';

class UserService {
  Future<List<User>> getUsers() async {
    try {
      final response = await makeGetRequest('users/');
      return handleResponse<List<User>>(
          response, (data) => parseListResponse(data, User.fromJson));
    } catch (e) {
      debugPrint('Error fetching users: $e');
      rethrow;
    }
  }

  Future<List<Teacher>> getTeachers() async {
    final response = await makeGetRequest('users/teachers');
    print(response.body);
    return handleResponse<List<Teacher>>(
        response, (data) => parseListResponse(data, Teacher.fromJson));
  }

  Future<User> getCurrentUser() async {
    final response = await makeGetRequest('users/me');
    return handleResponse<User>(response, (data) => User.fromJson(data));
  }
}
