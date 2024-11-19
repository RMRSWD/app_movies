import 'package:flutter/material.dart';
import '../modele/movie.dart';
import '../modele/data_movie.dart';

class MovieProvider extends ChangeNotifier{
  final DataMovie db = DataMovie.instance;
   List<Movie> _favoris = [];
   List<Movie> _recentView = [];

  List<Movie> get favoris => _favoris;
  List<Movie> get recentView => _recentView;

  MovieProvider(){
    _loadFavorites();
    _loadRecentsMovies();
  }

  Future<void> _loadFavorites() async {
    _favoris = await db.getFavorite();
    notifyListeners();
  }

  Future<void> _loadRecentsMovies() async {
    _recentView = await db.getRecentsFilms();
    notifyListeners();
  }

  Future<void> toggleFavoris(Movie movie) async {
    final isFavoris = movie.isFavorite;
    movie.isFavorite = !isFavoris;

    if (movie.isFavorite) {
      await db.insertMovie(movie);
      _favoris.add(movie);
    } else {
      await db.updateMovie(movie);
      _favoris.removeWhere((f) => f.id == movie.id);
    }
    notifyListeners();
  }

  Future<void> addToRecents(Movie movie) async {
    if (!recentView.any((f) => f.id == movie.id)) {
      recentView.insert(0, movie);
      if (recentView.length > 10) recentView.removeLast();
      await db.insertMovie(movie);
      notifyListeners();
    }
  }



  void addFavori(Movie film) {
    if (!_favoris.any((f) => f.id == film.id)) {
      _favoris.add(film);
      notifyListeners(); 
    }
  }

  void retiredFavoris(Movie film){
    _favoris.removeWhere((f) => f.id == film.id);
    notifyListeners();
  }
  
  void addRecentViewed(Movie film){
    if(!_recentView.any((f) => f.id == film.id)){
      _recentView.insert(0, film);
    }
    if(_recentView.length > 10){
      _recentView.removeLast();
    }
    notifyListeners();
  }

}