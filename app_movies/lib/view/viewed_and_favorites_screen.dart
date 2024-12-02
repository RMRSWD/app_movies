import 'package:app_movies/provider/movie_provider.dart';
import 'package:app_movies/view/film_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../modele/movie.dart';

class ViewedAndFavoritesScreen extends StatelessWidget {
  const ViewedAndFavoritesScreen({super.key});
  

@override
Widget build(BuildContext context) {
  final movieProvider = Provider.of<MovieProvider>(context, listen: true);
  return DefaultTabController(
    length: 2,
    child: Scaffold(
      appBar: AppBar(
        title: const Text('Favorites & Recently Viewed'),
        bottom: const TabBar(
          tabs: [
            Tab(icon: Icon(Icons.favorite), text: 'Favorites'),
            Tab(icon: Icon(Icons.history), text: 'Recently Viewed'),
          ],
        ),
      ),
      body: TabBarView(
        children: [
          FutureBuilder<List<Movie>>(
            future: movieProvider.fetchFavorites(), 
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                return const Center(child: Text('No favorite movies added yet.'));
              }
              final favorites = snapshot.data!;
              return _buildMovieList(favorites, context, movieProvider);
            },
          ),
          FutureBuilder<List<Movie>>(
            future: movieProvider.fetchRecents(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                return const Center(child: Text('No movies viewed recently.'));
              }
              final recents = snapshot.data!;
              return _buildMovieList(recents, context, movieProvider);
            },
          ),
        ],
        
      ),
    ),
  );
}

Widget _buildMovieList(List<Movie> movies, BuildContext context, MovieProvider movieProvider){
  return ListView.builder(
    itemCount: movies.length,
    itemBuilder: (context, index) {
      final movie = movies[index];
      return ListTile(
        leading: movie.posterPath.isNotEmpty ? Image.network('https://image.tmdb.org/t/p/w200${movie.posterPath}') : Lottie.asset('assets/images/no_movie.json', width: 50, height: 50),
        title: Text(movie.title),
        subtitle: Text('Release date : ${movie.releaseDate}'),
        onTap: (){
          Navigator.push(context, 
          MaterialPageRoute(
            builder: (context) => FilmDetailsScreen(movie: movie)),
          );
        },
        trailing: IconButton(
          onPressed: () async{
            final confirm = await showDialog(context: context, 
            builder: (BuildContext context){
              return AlertDialog(
                title: const Text('Delete movie'),
                content: const Text('Are you sure that you want to delete this recent movie?'),
                actions: [
                  TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')
                  ),
                  TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Delete'))
                ],
              );
              
            }
            );
            if (confirm == true) {
              await movieProvider.deleteMovie(movie);
            }
          }, 
          icon: const Icon(Icons.delete)),
        
      );
    },
  );
}

}
