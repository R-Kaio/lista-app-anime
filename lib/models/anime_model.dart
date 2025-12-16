class Anime {
  final int id;
  final String title;
  final String imageUrl;
  final double? score;
  final String? synopsis;

  Anime({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.score,
    this.synopsis,
  });

  // Factory: Cria uma instância de Anime a partir de um mapa JSON
  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      id: json['mal_id'],
      title: json['title'],
      imageUrl: json['images']['jpg']['image_url'],
      score: json['score'] != null ? (json['score'] as num).toDouble() : 0.0,
      synopsis: json['synopsis'],
    );
  }
}
