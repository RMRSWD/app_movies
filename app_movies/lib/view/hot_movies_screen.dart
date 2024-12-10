import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/movie_provider.dart';
import '../modele/movie.dart';
import 'film_detail_screen.dart';

class HotMoviesScreen extends StatelessWidget {
  const HotMoviesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Films liés à vos intérêts'),
      ),
      body: FutureBuilder<List<Movie>>(
        future: movieProvider.fetchHotMoviesRelatedToFavorites(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erreur : ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Aucune recommandation disponible.'),
            );
          }

          final movies = snapshot.data!;
          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return ListTile(
                leading: movie.posterPath.isNotEmpty
                    ? Image.network(
                        'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.movie, size: 50),
                title: Text(movie.title),
                subtitle: Text('Évaluation : ${movie.rating}/10'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FilmDetailsScreen(movie: movie),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
