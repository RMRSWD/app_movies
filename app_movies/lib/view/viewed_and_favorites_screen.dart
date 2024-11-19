import 'package:flutter/material.dart';
import '../modele/movie.dart';

class ViewedAndFavoritesScreen extends StatelessWidget{
  final List<Movie> favorites;
  final List<Movie> recentlyViewed;

  const ViewedAndFavoritesScreen({
    super.key,
    required this.favorites,
    required this.recentlyViewed,
  });

  @override
  Widget build(BuildContext context){
    return DefaultTabController(
      length: 2, 
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Favorites and recent viewed'),
          bottom: const TabBar(tabs: [
            Tab(icon: Icon(Icons.favorite), text: 'Your Favorite'),
            Tab(icon:Icon(Icons.history), text: 'Recently viewed')
          ]),
        ),
        body: TabBarView(children: [
          buildMovieList(context, favorites, 'No favorites found'),
          buildMovieList(context, recentlyViewed, 'No movies recently')
        ]),

      ),
      );
  }

  Widget buildMovieList(BuildContext context, List<Movie> movies, String message){
    if(movies.isEmpty){
      return Center(child: Text(message));
    }
    return ListView.builder(itemCount: movies.length,
    itemBuilder: (context, index){
      final movie = movies[index];
      return ListTile(
        leading: movie.posterPath.isNotEmpty ? Image.network('https://image.tmdb.org/t/p/w200${movie.posterPath}') : const Icon(Icons.movie),
        title: Text(movie.title),
        subtitle: Text('Release date : ${movie.releaseDate}'),

      );

    }
    ,);
  }
}