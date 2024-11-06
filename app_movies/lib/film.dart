
class Film {
  final String id;
  final String title;
  final String releaseDate;
  final String overview;
  final double rating;
  final String posterPath;
  final List<String> genres;
  late final List<String> actors;
  bool isFavorite;
  double? userRating; // Note personnelle de l'utilisateur (non-final)
  final String mediaType; // "movie" ou "tv"
  List<int> watchedEpisodes; // Liste d'identifiants d'épisodes vus

  Film({
    required this.id,
    required this.title,
    required this.releaseDate,
    required this.overview,
    required this.rating,
    required this.posterPath,
    required this.genres,
    required this.actors,
    this.isFavorite = false,
    this.userRating,
    required this.mediaType,
    this.watchedEpisodes = const [],
  });

  factory Film.fromJson(Map<String, dynamic> json) {
    return Film(
      id: json['id'].toString(),
      title: json['title'] ?? json['name'] ?? 'Unknown', // Prend en compte les films et séries
      releaseDate: json['release_date'] ?? json['first_air_date'] ?? 'Unknown',
      overview: json['overview'] ?? 'No overview available',
      rating: (json['vote_average'] ?? 0.0).toDouble(),
      posterPath: json['poster_path'] ?? '',
      genres: (json['genres'] as List<dynamic>?)
              ?.map((genre) => genre['name'] as String)
              .toList() ??
          [],
      actors: (json['credits']['cast'] as List<dynamic>?)
              ?.take(5)
              .map((actor) => actor['name'] as String)
              .toList() ??
          [], // Limite à 5 acteurs principaux
      mediaType: json['media_type'] ?? 'movie',
    );
  }
}
