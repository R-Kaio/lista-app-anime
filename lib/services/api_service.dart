import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://api.jikan.moe/v4";

  // Busca os Top Animes
  Future<Map<String, dynamic>> getTopAnimes() async {
    final response = await http.get(Uri.parse('$baseUrl/top/anime'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Falha ao carregar top animes');
    }
  }

  // Busca por nome
  Future<Map<String, dynamic>> searchAnimes(String query) async {
    final url = '$baseUrl/anime?q=$query&sfw=true';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Falha ao pesquisar animes');
    }
  }
}
