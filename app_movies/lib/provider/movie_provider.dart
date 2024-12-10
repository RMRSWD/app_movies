import 'package:app_movies/data_base_movie/data_movie_recently.dart';
import 'package:flutter/material.dart';
import '../data_base_movie/data_movie.dart';
import '../modele/movie.dart';
import 'package:app_movies/api_service/api_service.dart';

class MovieProvider extends ChangeNotifier {
  final DataMovie db = DataMovie.instance;
  final DataMovieRecent dbr = DataMovieRecent.instance;

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
    final dbr = DataMovieRecent.instance;
    return await dbr.getFilmRecent();
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
      await dbr.updateMovieRecent(movie);
      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
    }
  }

  Future<void> addToRecent(Movie movie) async {
    await dbr.insertMovieRecent(movie);
    notifyListeners();
  }

  Future<void> addToNewFavorite(Movie movie) async {
    await db.insertMovie(movie);
    notifyListeners();
  }

  Future<List<Movie>> fetchRecommendations() async {
    notifyListeners();
    return await fetchHotMovies();
  }

  Future<void> deleteMovie(Movie movie) async {
    int idMovie = int.parse(movie.id);
    await db.deleteMovie(idMovie);
    notifyListeners();
  }

  Future<void> deleteMovieRecent(Movie movie) async {
    int idMovie = int.parse(movie.id);
    await dbr.deleteMovieRecent(idMovie);
    notifyListeners();
  }

  // Méthode pour récupérer les détails d'un acteur
  Future<Map<String, dynamic>> fetchActorDetails(int actorId) async {
    try {
      final details = await fetchActorDetailsMovie(actorId);
      return details;
    } catch (e) {
      debugPrint('Error when retrieving actor\'s details : $e');
      throw Exception('Error when retrieving actor\'s details.');
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
        await dbr.updateMovieRecent(movie);
        notifyListeners();
      } else {
        throw Exception("Invalid rating: must be a number between 0 and 10.");
      }
    } catch (e) {
      debugPrint("Error: Unable to save note $e");
      throw Exception("Error: Unable to save note $e");
    }
  }

  Future<void> clearAllRecents() async {
    try {
      final dbr = DataMovieRecent.instance;
      final recents =
          await fetchRecents(); // Obtenez une liste de tous les films regardés
      for (final movie in recents) {
        await dbr
            .deleteMovieRecent(int.parse(movie.id)); // Supprime chaque film
      }
      notifyListeners(); // Mettre à jour l'interface
    } catch (e) {
      debugPrint('Error clearing recently viewed: $e');
    }
  }

  Future<void> clearAllMovieFavoris() async {
    try {
      final db = DataMovie.instance;
      final favoris =
          await fetchFavorites(); // Obtenez une liste de tous les films favoris
      for (final movie in favoris) {
        await db.deleteMovie(int.parse(movie.id)); // Supprime chaque film
      }
      notifyListeners(); // Mettre à jour l'interface
    } catch (e) {
      debugPrint('Error clearing favoris: $e');
    }
  }

  Future<List<Movie>> fetchHotMoviesRelatedToFavorites() async {
    try {
      final favoriteMovies =
          await db.getFavorite(); // Obtenez une liste de films préférés
      final List<Movie> hotMovies = [];

      // Parcourez chaque film préféré pour obtenir une liste de suggestions
      for (final movie in favoriteMovies) {
        final relatedMovies = await fetchRecommendationsMovieByID(movie.id);
        hotMovies.addAll(relatedMovies);
      }

      // Supprime les films en double
      final uniqueHotMovies =
          {for (var movie in hotMovies) movie.id: movie}.values.toList();

      return uniqueHotMovies;
    } catch (e) {
      debugPrint('Error retrieving hot-linked movie: $e');
      return [];
    }
  }
}
