import 'package:flutter/material.dart';
import '../models/anime_model.dart';
import '../repositories/anime_repository.dart';

class AnimeViewModel extends ChangeNotifier {
  final AnimeRepository repository;

  List<Anime> _animes = [];
  bool _isLoading = false;
  String _error = '';

  bool _isSearching = false;

  List<Anime> get animes => _animes;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get isSearching => _isSearching;

  AnimeViewModel({required this.repository});

  Future<void> fetchAnimes({bool forceRefresh = false}) async {
    if (_animes.isNotEmpty && !forceRefresh && !_isSearching) return;

    _isLoading = true;
    _error = '';
    _isSearching = false;
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

  //  Função de Pesquisar
  Future<void> search(String query) async {
    if (query.isEmpty) {
      fetchAnimes(forceRefresh: true);
      return;
    }

    _isLoading = true;
    _isSearching = true;
    _error = '';
    notifyListeners();

    try {
      _animes = await repository.searchAnimes(query);
    } catch (e) {
      _error = 'Erro na busca: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
