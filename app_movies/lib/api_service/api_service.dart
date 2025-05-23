import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_movies/modele/movie.dart';

const String apiKey = 'd569dcea3c12b769842598f44540a7f2';

// Fonction pour rechercher les films
Future<List<Movie>> fetchMovies(String query) async {
  final url =
      'https://api.themoviedb.org/3/search/movie?query=$query&api_key=$apiKey';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonData = json.decode(response.body);
    final List<dynamic> results = jsonData['results'];

    // Récupère chaque film et obtient les crédits
    List<Movie> films = [];
    for (var item in results) {
      Movie film = Movie.fromJson(item);
      // Récupération genres pour chaque films
      film.genres = await fetchGenre(film.id);

      films.add(film);
    }
    return films;
  } else {
    throw Exception('Failed to load film data for $query');
  }
}

Future<List<Movie>> fetchHotMovies() async {
  const url =
      'https://api.themoviedb.org/3/movie/top_rated?api_key=$apiKey';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonData = json.decode(response.body);
    final List<dynamic> results = jsonData['results'];

    // Récupère chaque film et obtient les crédits
    List<Movie> films = [];
    for (var item in results) {
      Movie film = Movie.fromJson(item);
      // Récupération genres pour chaque films
      film.genres = await fetchGenre(film.id);

      films.add(film);
    }
    return films;
  } else {
    throw Exception('Failed to load film data ');
  }
}

Future<Map<String, dynamic>> fetchMovieDetailss(int movieId) async {
  final url =
      'https://api.themoviedb.org/3/movie/$movieId?api_key=$apiKey&append_to_response=credits';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to fetch movie details');
  }
}

//Fonction retourne une liste film recommendé
Future<List<Movie>> fetchRecommendationsMovieByID(String movieId) async {
  final url =
      'https://api.themoviedb.org/3/movie/$movieId/recommendations?api_key=$apiKey&language=en-US';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonData = json.decode(response.body);
    final List<dynamic> results = jsonData['results'];
    // Transforme chaque élément de `results` en un objet `Film` et retourne la liste
    List<Movie> films = [];
    for (var item in results) {
      Movie film = Movie.fromJson(item);
      // Récupération genres pour chaque films
      film.genres = await fetchGenre(film.id);

      films.add(film);
    }
    return films;
  } else {
    throw Exception('Failed to load film recommendations $movieId');
  }
}

// Méthode pour récupérer les genres d'un film
Future<List<String>> fetchGenre(String filmId) async {
  final url = 'https://api.themoviedb.org/3/movie/$filmId?api_key=$apiKey';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonData = json.decode(response.body);
    final List<dynamic> genres = jsonData['genres'];

    // Récupère les noms des genres
    return genres.map((genre) => genre['name'] as String).toList();
  } else {
    throw Exception('Failed to load genres for movie ID $filmId');
  }
}

// Méthode pour récupérer les détails d'un acteur
Future<Map<String, dynamic>> fetchActorDetailsMovie(int personId) async {
  final url = 'https://api.themoviedb.org/3/person/$personId?api_key=$apiKey';

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load actor ID details $personId');
  }
}

// Méthode pour récupérer les films d'un acteur
Future<List<Movie>> fetchActorMoviesWithDetail(int personId) async {
  final url =
      'https://api.themoviedb.org/3/discover/movie?with_cast=$personId&api_key=$apiKey';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonData = json.decode(response.body);
    final List<dynamic> results = jsonData['results'];
    List<Movie> films = [];
    for (var item in results) {
      Movie film = Movie.fromJson(item);
      // Récupération et genres pour chaque films
      film.genres = await fetchGenre(film.id);

      films.add(film);
    }
    return films;
  } else {
    throw Exception('Failed to load movies for actor ID $personId');
  }
}