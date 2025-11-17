import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class FootballApiService {
  
  final String _apiKey = "3";
  final String _baseUrl = "https://www.thesportsdb.com/api/v1/json/";

  Future<List<dynamic>> buscaTimePeloNome(String? nome) async {
    if (nome == null || nome.isEmpty) {
      return []; 
    }
    
    try {
      final uri = Uri.parse("$_baseUrl$_apiKey/searchteams.php?t=$nome");
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return json.decode(response.body)['teams'] ?? [];
      } else {
        throw Exception('Erro ${response.statusCode}: ${response.body}');
      }
    } on SocketException {
      throw Exception('Erro de conexão com a internet');
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> buscaJogadorPeloNome(String? nome) async {
    if (nome == null || nome.isEmpty) {
      return [];
    }

    try {
      final uri = Uri.parse("$_baseUrl$_apiKey/searchplayers.php?p=$nome");
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return json.decode(response.body)['player'] ?? [];
      } else {
        throw Exception('Erro ${response.statusCode}: ${response.body}');
      }
    } on SocketException {
      throw Exception('Erro de conexão com a internet');
    } catch (e) {
      rethrow;
    }
  }
}