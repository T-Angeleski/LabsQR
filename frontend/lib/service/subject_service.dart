import 'package:frontend/models/subject.dart';
import 'package:frontend/util/service_helpers.dart';

class SubjectService {
  Future<List<Subject>> getSubjects() async {
    final response = await makeGetRequest('subjects');
    return handleResponse<List<Subject>>(
        response, (data) => parseListResponse(data, Subject.fromJson));
  }

  Future<Subject> createSubject(String name) async {
    if (name.trim().isEmpty) {
      throw Exception('Subject name cannot be empty');
    }

    final requestBody = {'name': name.trim()};
    final response = await makePostRequest('subjects', requestBody);
    return handleResponse<Subject>(response, (data) => Subject.fromJson(data));
  }

  Future<Subject> updateSubject(String id, String name) async {
    if (name.trim().isEmpty) {
      throw Exception('Subject name cannot be empty');
    }

    final response =
        await makePutRequest('subjects/$id', {'name': name.trim()});
    return handleResponse<Subject>(response, (data) => Subject.fromJson(data));
  }

  Future<void> deleteSubject(String id) async {
    final response = await makeDeleteRequest('subjects/$id');

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete subject: ${response.body}');
    }
  }
}
