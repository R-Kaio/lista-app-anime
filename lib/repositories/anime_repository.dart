import '../services/api_service.dart';
import '../models/anime_model.dart';

class AnimeRepository {
  final ApiService apiService;

  AnimeRepository({required this.apiService});

  // Top Animes
  Future<List<Anime>> fetchTopAnimes() async {
    final data = await apiService.getTopAnimes();
    final List<dynamic> animeList = data['data'];
    return animeList.map((json) => Anime.fromJson(json)).toList();
  }

  // Pesquisar
  Future<List<Anime>> searchAnimes(String query) async {
    final data = await apiService.searchAnimes(query);
    final List<dynamic> animeList = data['data'];
    return animeList.map((json) => Anime.fromJson(json)).toList();
  }
}
