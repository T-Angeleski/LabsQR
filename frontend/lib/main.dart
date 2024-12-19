import 'package:flutter/material.dart';
import 'package:frontend/service/index_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Frontend',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final IndexService apiService = IndexService(baseUrl: 'http://10.0.2.2:8080');

  String message = "Fetching data...";

  @override
  void initState() {
    super.initState();
    fetchMessage();
  }

  Future<void> fetchMessage() async {
    try {
      final fetchedMessage = await apiService.fetchHelloWorld();
      setState(() {
        message = fetchedMessage;
      });
    } catch (e) {
      setState(() {
        message = "Error fetching data: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Flutter Frontend")),
      body: Center(child: Text(message)),
    );
  }
}
