class Anime {
  final int id;
  final String title;
  final String imageUrl;
  final double? score;
  final String? synopsis;

  int watchedEpisodes;
  int? totalEpisodes;
  String status;

  Anime({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.score,
    this.synopsis,
    this.watchedEpisodes = 0,
    this.totalEpisodes,
    this.status = 'Planejo Ver',
  });

  // Factory: Cria uma instância de Anime a partir de um mapa JSON
  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      id: json['mal_id'],
      title: json['title'],
      imageUrl: json['images']['jpg']['image_url'],
      score: json['score'] != null ? (json['score'] as num).toDouble() : 0.0,
      synopsis: json['synopsis'],
      totalEpisodes: json['episodes'],
    );
  }

  // Objeto -> Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'image_url': imageUrl,
      'score': score,
      'synopsis': synopsis,
      'watched_episodes': watchedEpisodes,
      'total_episodes': totalEpisodes,
      'status': status,
    };
  }

  // Map -> Objeto
  factory Anime.fromMap(Map<String, dynamic> map) {
    return Anime(
      id: map['id'],
      title: map['title'],
      imageUrl: map['image_url'],
      score: map['score'],
      synopsis: map['synopsis'],
      watchedEpisodes: map['watched_episodes'],
      totalEpisodes: map['total_episodes'],
      status: map['status'],
    );
  }
}
