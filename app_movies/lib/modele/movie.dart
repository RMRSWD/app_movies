
class Movie {
  final String id;
  final String title;
  final String releaseDate;
  final String overview;
  final double rating;
  final String posterPath;
  List<String> genres;
  List<String> actors;
  bool isFavorite;
  double? userRating; 
  final String mediaType; 
  List<int> watchedEpisodes;
  bool isClicked;

  Movie({
    required this.id,
    required this.title,
    required this.releaseDate,
    required this.overview,
    required this.rating,
    required this.posterPath,
    this.genres = const [],
    this.actors = const [],
    this.isFavorite = false,
    this.userRating,
    required this.mediaType,
    this.watchedEpisodes = const [],
    this.isClicked = false
  });
//
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'].toString(),
      title: json['title'] ?? json['name'] ?? 'Unknown',
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
      'genres': genres.join(','),
      'actors': actors.join(','),
      'isFavorite': isFavorite ? 1 : 0,
      'userRating': userRating,
      'mediaType': mediaType,
      'watchedEpisodes': watchedEpisodes.isNotEmpty ? watchedEpisodes.join(',') : '', 
    };
  }

 factory Movie.fromMap(Map<String, dynamic> map) {
  return Movie(
    id: map['id'].toString(),
    title: map['title'] ?? '',
    releaseDate: map['releaseDate'] ?? '',
    overview: map['overview'] ?? '',
    rating: map['rating'] is int
        ? (map['rating'] as int).toDouble()
        : (map['rating'] is String
            ? double.tryParse(map['rating']) ?? 0.0
            : map['rating'] as double),
    posterPath: map['posterPath'] ?? '',
    genres: (map['genres'] as String).split('|'),
    actors: (map['actors'] as String).split('|'),
    isFavorite: map['isFavorite'] == 1,
    userRating: map['userRating'] is String
        ? double.tryParse(map['userRating'])
        : map['userRating'],
    mediaType: map['mediaType'] ?? '',
    watchedEpisodes: map['watchedEpisodes'] != null
        ? (map['watchedEpisodes'] as String)
            .split(',')
            .map((e) => int.tryParse(e) ?? 0)
            .toList()
        : [],
  );
}

}
