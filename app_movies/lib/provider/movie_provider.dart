import 'package:flutter/material.dart';
import '../modele/data_movie.dart';
import '../modele/movie.dart';
import 'package:app_movies/api_service/api_service.dart';

class MovieProvider extends ChangeNotifier {
  final DataMovie db = DataMovie.instance;

  /* Future<List<Movie>> fetchFavorites() async {
    final db = DataMovie.instance;
    notifyListeners();
    return await db.getFavorite(); // Récupérer les favoris depuis la base
  } */

  Future<List<Movie>> fetchFavorites() async {
  try {
    final db = DataMovie.instance;
    return await db.getFavorite(); // Récupérer les favoris depuis la base
  } catch (e) {
    debugPrint('Erreur lors du chargement des favoris: $e');
    return []; // Retourne une liste vide en cas d'erreur
  }
}


    Future<List<Movie>> fetchRecents() async {
    final db = DataMovie.instance;
    //notifyListeners();
    return await db.getRecentsFilms();
     // Récupérer les récents depuis la base
  }


  Future<List<Movie>> searchMovies(String query) async {
    if (query.isEmpty) {
      return []; // Return an empty list for empty queries
    }
    return await fetchMovies(query); // Call the API to fetch results
  }


  Future<void> toggleFavorite(Movie movie) async {
  try {
    movie.isFavorite = !movie.isFavorite; // Đổi trạng thái yêu thích
    await db.updateMovie(movie); // Cập nhật trong SQLite
    notifyListeners(); // Cập nhật giao diện
  } catch (e) {
    debugPrint('Error toggling favorite: $e');
  }
}

  Future<void> addToRecent(Movie movie) async {
    await db.updateMovie(movie); // Update or insert the movie in the database
    notifyListeners(); // Notify UI of the change
  }

  Future<void> addToNewFavorite(Movie movie) async{
    await db.insertMovie(movie);
    notifyListeners();
  }

   Future<List<Movie>> fetchRecommendations() async {
    notifyListeners();
    return await fetchMovies("hot");
  }

  Future<void> deleteMovie(Movie movie) async{
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
    debugPrint('Erreur lors de la récupération des détails de l\'acteur : $e');
    throw Exception('Erreur lors de la récupération des détails de l\'acteur.');
  }
}
 // Méthode pour récupérer les films d'un acteur
  Future<List<Movie>> fetchActorMovies(int actorId) async {
    try {
      final actorMovies = await fetchActorMoviesWithDetail(actorId); 
      return actorMovies;
    } catch (e) {
      debugPrint('Erreur lors de la récupération des films de l\'acteur : $e');
      return [];
    }
  }

  // Méthode pour récupérer les détails d'un film
    Future<Map<String, dynamic>> fetchMovieDetails(int idMovie) async {
  try {
    print("Fetching movie details for ID: $idMovie");
    final details = await fetchMovieDetailss(idMovie);
    print("Movie details fetched successfully: $details");
    return details;
  } catch (e) {
    print("Erreur lors de la récupération des détails du film: $e");
    throw Exception("Erreur: Impossible de récupérer les détails du film.");
  }
}


Future<void> saveNote(String noteUser, Movie movie) async {
  try{
    final note = double.tryParse(noteUser);
    if (note != null && note >= 0 && note <= 10) {
        movie.userRating = note; // Mettre à jour l'objet local
      await db.updateMovie(movie);
  }
  }
  catch(e){
     throw Exception("Erreur: Impossible de sauvegarder la note $e");

  }

  }

  Future<void> saveNoteToMovie(double note, Movie movie) async {
  try {
    if (note >= 0 && note <= 10) {
      movie.userRating = note; 
      await db.updateMovie(movie); 
      notifyListeners();
    } else {
      throw Exception("Note invalide : elle doit être un nombre entre 0 et 10.");
    }
  } catch (e) {
    debugPrint("Erreur: Impossible de sauvegarder la note $e");
    throw Exception("Erreur: Impossible de sauvegarder la note $e");
  }
}

}
  

