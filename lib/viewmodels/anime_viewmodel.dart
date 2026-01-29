import 'package:flutter/material.dart';
import '../models/anime_model.dart';
import '../repositories/anime_repository.dart';

class AnimeViewModel extends ChangeNotifier {
  final AnimeRepository repository;

  // Estados
  List<Anime> _animes = [];
  bool _isLoading = false;
  String _error = '';

  // Getters
  List<Anime> get animes => _animes;
  bool get isLoading => _isLoading;
  String get error => _error;

  // Construtor
  AnimeViewModel({required this.repository});

  // Método para buscar animes
  Future<void> fetchAnimes({bool forceRefresh = false}) async {
    if (_animes.isNotEmpty && !forceRefresh) {
      return;
    }

    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _animes = await repository.fetchTopAnimes();
    } catch (e) {
      _error = 'Falha ao carregar animes: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
