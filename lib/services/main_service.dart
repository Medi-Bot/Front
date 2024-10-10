import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medibot/models/all_data_dto.dart';

class MainService {
  static final String uri = 'http://10.60.12.101:8081/';

  Future<AllDataDto> getAll() async {
    final response = await http.get(Uri.parse('${uri}get-all'));
    if (response.statusCode == 200) {
      return AllDataDto.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Impossible de récupérer les données');
    }
  }

  Future<bool> sendMessage(String message) async {
    final response = await http.post(Uri.parse('${uri}request'), body: message);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  /*Future<String> getConversation(String search) async {
    final response = await http.get(Uri.parse('${uri}users/$search'),
        headers: Globals.getHeader());
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      List<UserIdPseudo> conversations = data.map((item) => UserIdPseudo.fromJson(item)).toList();
      return conversations;
    } else {
      throw Exception('Impossible de récupérer les données');
    }
  }*/
}
