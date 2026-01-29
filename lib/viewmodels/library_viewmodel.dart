import 'package:flutter/material.dart';
import '../models/anime_model.dart';
import '../services/database_service.dart';

class LibraryViewModel extends ChangeNotifier {
  List<Anime> _library = [];
  bool _isLoading = false;

  List<Anime> get library => _library;
  bool get isLoading => _isLoading;

  // Carrega os animes do banco ao iniciar
  Future<void> loadLibrary() async {
    _isLoading = true;
    notifyListeners();

    _library = await DatabaseService.instance.getAnimes();

    _isLoading = false;
    notifyListeners();
  }

  // Adiciona ou Remove (Toggle)
  Future<void> toggleSave(Anime anime) async {
    final isSaved = await DatabaseService.instance.isSaved(anime.id);

    if (isSaved) {
      await DatabaseService.instance.deleteAnime(anime.id);
    } else {
      await DatabaseService.instance.insertAnime(anime);
    }

    // Recarrega a lista para atualizar a UI
    await loadLibrary();
  }

  // Verifica se um específico está salvo (para pintar o botão)
  Future<bool> isAnimeSaved(int id) async {
    return await DatabaseService.instance.isSaved(id);
  }
}
