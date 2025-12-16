import '../models/anime_model.dart';
import '../services/api_service.dart';

class AnimeRespository {
  final ApiService apiService;

  //Injeção de dependência via construtor
  AnimeRespository({required this.apiService});

  Future<List<Anime>> fetchTopAnimes() async {
    try {
      final response = await apiService.getTopAnimes();
      final List<dynamic> dataList = response['data'];
      return dataList.map((json) => Anime.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erro ao processar dados: $e');
    }
  }
}
