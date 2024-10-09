import 'dart:convert';
import 'package:http/http.dart' as http;

class APIService{

  static const String uri = 'http://localhost:8081/';

  Future<String> executeTests() async{
    final response = await http.get(Uri.parse('${uri}select-profile'));
    return response.body;
  }
}