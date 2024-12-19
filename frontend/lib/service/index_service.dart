import 'package:http/http.dart' as http;

class IndexService {
  final String baseUrl;

  IndexService({required this.baseUrl});

  Future<String> fetchHelloWorld() async {
    final response = await http.get(Uri.parse('$baseUrl/'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to fetch data');
    }
  }
}
