
class Movie {
  final String id;
  final String title;
  final String releaseDate;
  final String overview;
  final double rating;
  final String posterPath;
  final List<String> genres;
  List<String> actors;
  bool isFavorite;
  double? userRating; 
  final String mediaType; 
  List<int> watchedEpisodes;

  Movie({
    required this.id,
    required this.title,
    required this.releaseDate,
    required this.overview,
    required this.rating,
    required this.posterPath,
    required this.genres,
    this.actors = const [],
    this.isFavorite = false,
    this.userRating,
    required this.mediaType,
    this.watchedEpisodes = const [],
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
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
      actors: (json['credits']?['cast'] as List<dynamic>?)
              ?.map((actor) => actor['name'] as String)
              .take(5)
              .toList() ??
          [], 
      mediaType: json['media_type'] ?? 'movie',
    );
  }

    Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'releaseDate': releaseDate,
      'overview': overview,
      'rating': rating,
      'posterPath': posterPath,
      'genres': genres.join(','), // Les genres comme une chaîne séparée par des virgules
      'actor': actors.join(','), // Les acteurs comme une chaîne séparée par des virgules
      'isFavorite': isFavorite ? 1 : 0, // Pour SQLite, boolean -> 1 ou 0
      'userRating': userRating,
      'mediaType': mediaType,
      'watchedEpisodes': watchedEpisodes.join(','), // Épisodes regardés comme chaîne
    };
  }

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'],
      title: map['title'],
      releaseDate: map['releaseDate'],
      overview: map['overview'],
      rating: map['rating'],
      posterPath: map['posterPath'],
      genres: (map['genres'] as String).split(','), // Reconvertir en liste
      actors: (map['actors'] as String).split(','), // Reconvertir en liste
      isFavorite: map['estFavoris'] == 1,
      userRating: map['userRating'],
      mediaType: map['mediaType'],
      watchedEpisodes: map['watchedEpisodes'] != null 
          ? (map['watchedEpisodes'] as String).split(',').map(int.parse).toList() 
          : [],
    );
  }  
}
