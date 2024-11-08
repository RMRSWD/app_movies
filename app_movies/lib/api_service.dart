/* import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_movies/film.dart';

Future<List<Film>> fetchFilms(String query) async {
  const apiKey = 'd569dcea3c122598f44540a7f2';
  const url = 'https://api.themoviedb.org/3/search/movie?query=$query&api_key=$apiKey';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonData = json.decode(response.body);
    final List<dynamic> results = jsonData['results'];

    // Transformez chaque résultat en un objet `Film` et renvoyez une liste de `Film`
    return results.map((item) => Film.fromJson(item)).toList();
  } else {
    throw Exception('Échec du chargement des données de film pour $query');
  }
}
 */

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_movies/film.dart';

const String apiKey = 'd569dcea3c12b769842598f44540a7f2';

// Fonction pour rechercher les films
Future<List<Film>> fetchFilms(String query) async {
  final url = 'https://api.themoviedb.org/3/search/movie?query=$query&api_key=$apiKey';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonData = json.decode(response.body);
    final List<dynamic> results = jsonData['results'];

    // Récupère chaque film et obtient les crédits
    List<Film> films = [];
    for (var item in results) {
      Film film = Film.fromJson(item);

      // Récupération des crédits pour chaque film
      film.actors = await fetchCredits(film.id);

      films.add(film);
    }
    return films;
  } else {
    throw Exception('Échec du chargement des données de film pour $query');
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

Future<List<Film>> fetchRecommendations(String movieId) async {
  final url = 'https://api.themoviedb.org/3/movie/$movieId/recommendations?api_key=$apiKey&language=en-US';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonData = json.decode(response.body);
    final List<dynamic> results = jsonData['results'];

    // Transforme chaque élément de `results` en un objet `Film` et retourne la liste
    return results.map((item) => Film.fromJson(item)).toList();
  } else {
    throw Exception('Échec du chargement des recommandations pour le film $movieId');
  }
}
