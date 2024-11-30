
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_movies/modele/movie.dart';

const String apiKey = 'd569dcea3c12b769842598f44540a7f2';

// Fonction pour rechercher les films
Future<List<Movie>> fetchMovies(String query) async {
  final url = 'https://api.themoviedb.org/3/search/movie?query=$query&api_key=$apiKey';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonData = json.decode(response.body);
    final List<dynamic> results = jsonData['results'];

    // Récupère chaque film et obtient les crédits
    List<Movie> films = [];
    for (var item in results) {
      Movie film = Movie.fromJson(item);
      // Récupération des crédits et genres pour chaque films
      film.actors = await fetchCredits(film.id);
      film.genres = await fetchGenre(film.id);
      films.add(film);
    }
    return films;
  } else {
    throw Exception('Échec du chargement des données de film pour $query');
  }
}

 Future<Map<String, dynamic>> fetchMovieDetailss(int movieId) async {
    final url = 'https://api.themoviedb.org/3/movie/$movieId?api_key=$apiKey&append_to_response=credits';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch movie details');
    }
  }
 
// Fonction pour obtenir les crédits d'un film spécifique
Future<List<String>> fetchCredits(String movieId) async {
  final url = 'https://api.themoviedb.org/3/movie/$movieId/credits?api_key=$apiKey';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonData = json.decode(response.body);
    final List<dynamic> castList = jsonData['cast'] ?? [];

    // Retourne une liste avec les noms des acteurs principaux (jusqu'à 5 acteurs)
    return castList.take(5).map((actor) => actor['name'] as String).toList();
  } else {
    throw Exception('Échec du chargement des crédits pour le film $movieId');
  }
}
//Fonction retourne une liste film recommendé
Future<List<Movie>> fetchRecommendations(String movieId) async {
  final url = 'https://api.themoviedb.org/3/movie/$movieId/recommendations?api_key=$apiKey&language=en-US';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonData = json.decode(response.body);
    final List<dynamic> results = jsonData['results'];

    // Transforme chaque élément de `results` en un objet `Film` et retourne la liste
    return results.map((item) => Movie.fromJson(item)).toList();
  } else {
    throw Exception('Échec du chargement des recommandations pour le film $movieId');
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
    throw Exception('Échec du chargement des genres pour le film ID $filmId');
  }
}

  // Méthode pour récupérer les détails d'un acteur
  Future<Map<String, dynamic>> fetchActorDetailsMovie(int personId) async {
  final url = 'https://api.themoviedb.org/3/person/$personId?api_key=$apiKey';

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return json.decode(response.body); // Retourne un Map contenant les détails de l'acteur
  } else {
    throw Exception('Échec du chargement des détails de l\'acteur ID $personId');
  }
}

/* Future<List<Movie>> fetchActorDetailsMovie(int personId) async {
  final url = 'https://api.themoviedb.org/3/person/$personId?api_key=$apiKey';

  final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200){
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final List<dynamic> results = jsonData['results'];
      return results.map((item) => Movie.fromJson(item)).toList();
    }
   else {
    throw Exception('Échec du chargement des détails de l\'acteur ID $personId');
  }
} */

// Méthode pour récupérer les films d'un acteur
Future<List<Movie>> fetchActorMoviesWithDetail(int personId) async {
  // final url = 'https://api.themoviedb.org/discover/movie?with_cast=$personId&api_key=$apiKey';
  final url = 'https://api.themoviedb.org/3/discover/movie?with_cast=$personId&api_key=$apiKey';


  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonData = json.decode(response.body);
    final List<dynamic> results = jsonData['results'];

    return results.map((item) => Movie.fromJson(item)).toList();
  } else {
    throw Exception('Échec du chargement des films pour l\'acteur ID $personId');
  }
}