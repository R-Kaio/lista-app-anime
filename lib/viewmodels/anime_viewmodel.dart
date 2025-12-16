import 'package:flutter/material.dart';
import '../models/anime_model.dart';
import '../repositories/anime_repository.dart';

class AnimeViewmodel extends ChangeNotifier {
  final AnimeRepository repository;

  // Estados da tela
  List<Anime> _animes = [];
  bool _isLoading = false;
  String _error = '';

  List<Anime> get animes => _animes;
  bool get isLoading => _isLoading;
  String get error => _error;

  AnimeViewmodel({required this.repository});

  Future<void> fetchAnimes() async {
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
