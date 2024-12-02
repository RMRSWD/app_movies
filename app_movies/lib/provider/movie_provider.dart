import 'package:flutter/material.dart';
import '../modele/data_movie.dart';
import '../modele/movie.dart';
import 'package:app_movies/api_service/api_service.dart';

class MovieProvider extends ChangeNotifier {
  final DataMovie db = DataMovie.instance;

  Future<List<Movie>> fetchFavorites() async {
    try {
      final db = DataMovie.instance;
      return await db.getFavorite();
    } catch (e) {
      debugPrint('Error loading favorites: $e');
      return [];
    }
  }

  Future<List<Movie>> fetchRecents() async {
    final db = DataMovie.instance;
    return await db.getRecentsFilms();
  }

  Future<List<Movie>> searchMovies(String query) async {
    if (query.isEmpty) {
      return [];
    }
    return await fetchMovies(query);
  }

  Future<void> toggleFavorite(Movie movie) async {
    try {
      movie.isFavorite = !movie.isFavorite; 
      await db.updateMovie(movie); 
      notifyListeners(); 
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
    }
  }

  Future<void> addToRecent(Movie movie) async {
    await db.updateMovie(movie); 
    await db.insertMovie(movie);
    notifyListeners(); 
  }

  Future<void> addToNewFavorite(Movie movie) async {
    await db.insertMovie(movie);
    notifyListeners();
  }

  Future<List<Movie>> fetchRecommendations() async {
    notifyListeners();
    return await fetchMovies("hot");
  }

  Future<void> deleteMovie(Movie movie) async {
    int idMovie = int.parse(movie.id);
    await db.deleteMovie(idMovie);
    notifyListeners();
  }

  // Méthode pour récupérer les détails d'un acteur
  Future<Map<String, dynamic>> fetchActorDetails(int actorId) async {
    try {
      final details = await fetchActorDetailsMovie(actorId);
      return details;
    } catch (e) {
      debugPrint(
          'Error when retrieving actor\'s details : $e');
      throw Exception(
          'Error when retrieving actor\'s details.');
    }
  }

  // Méthode pour récupérer les films d'un acteur
  Future<List<Movie>> fetchActorMovies(int actorId) async {
    try {
      final actorMovies = await fetchActorMoviesWithDetail(actorId);
      return actorMovies;
    } catch (e) {
      debugPrint('Error when retrieving actor\'s films : $e');
      return [];
    }
  }

  // Méthode pour récupérer les détails d'un film
  Future<Map<String, dynamic>> fetchMovieDetails(int idMovie) async {
    try {
      // print("Fetching movie details for ID: $idMovie");
      final details = await fetchMovieDetailss(idMovie);
      // print("Movie details fetched successfully: $details");
      return details;
    } catch (e) {
      // print("Erreur lors de la récupération des détails du film: $e");
      throw Exception("Error: Unable to retrieve film details.");
    }
  }

  Future<void> saveNote(String noteUser, Movie movie) async {
    try {
      final note = double.tryParse(noteUser);
      if (note != null && note >= 0 && note <= 10) {
        movie.userRating = note; // Mettre à jour l'objet local
        await db.updateMovie(movie);
      }
    } catch (e) {
      throw Exception("Error: Unable to save note $e");
    }
  }

  Future<void> saveNoteToMovie(double note, Movie movie) async {
    try {
      if (note >= 0 && note <= 10) {
        movie.userRating = note;
        await db.updateMovie(movie);
        notifyListeners();
      } else {
        throw Exception(
            "Invalid rating: must be a number between 0 and 10.");
      }
    } catch (e) {
      debugPrint("Error: Unable to save note $e");
      throw Exception("Error: Unable to save note $e");
    }
  }
}
