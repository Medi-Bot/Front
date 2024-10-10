import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medibot/models/all_data_dto.dart';
import 'package:medibot/models/antecedent.dart';
import 'package:medibot/models/informations.dart';
import 'package:medibot/models/taille.dart';

import '../models/poids.dart';

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

  Future<List<String>> getUserList() async {
    final response = await http.get(Uri.parse('${uri}profiles'));
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes)).map<String>((e) => e.toString()).toList();
    } else {
      throw Exception('Impossible de récupérer les données');
    }
  }

  static getHeaderContentType(){
    return {
      "content-type" : "application/json"
    };
  }

  Future<bool> sendMessage(String message) async {
    final response = await http.post(Uri.parse('${uri}request'), body: message);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> addPoids(Poids poids) async {
    final response = await http.post(Uri.parse('${uri}poids'), body: jsonEncode(poids.toJson()), headers: getHeaderContentType());
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> addTaille(Taille taille) async {
    final response = await http.post(Uri.parse('${uri}taille'), body: jsonEncode(taille.toJson()), headers: getHeaderContentType());
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> addAntecedent(Antecedent antecedent) async {
    final response = await http.post(Uri.parse('${uri}antecedent'), body: jsonEncode(antecedent.toJson()), headers: getHeaderContentType());
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> changeDateNaissance(Informations informations) async {
    final response = await http.post(Uri.parse('${uri}informations'), body: jsonEncode(informations.toJson()), headers: getHeaderContentType());
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> selectProfile(String profile, String password) async {
    final response = await http.post(Uri.parse('${uri}select-profile'), body: jsonEncode({ "name" : profile, "password" : password }), headers: getHeaderContentType());
    if (response.statusCode == 200) {
      return bool.parse(response.body);
    } else {
      return false;
    }
  }
}
