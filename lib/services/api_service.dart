import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://api.jikan.moe/v4';

  Future<Map<String, dynamic>> getTopAnimes() async {
    try {
      final response = await _dio.get('$_baseUrl/top/anime');
      return response.data;
    } catch (e) {
      throw Exception('Erro na conexão: $e');
    }
  }
}
