import 'package:app_movies/provider/movie_provider.dart';
import 'package:app_movies/view/actor_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modele/movie.dart';
import 'user_rating_input.dart';
import 'recommendations_list.dart';
import 'package:app_movies/view/home_button.dart';

class FilmDetailsScreen extends StatelessWidget {
  final Movie movie;

  const FilmDetailsScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context, listen: true);
    Future<Map<String, dynamic>> movieDetail =
        movieProvider.fetchMovieDetails(int.parse(movie.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
        actions: [
          HomeButton(currentContext: context),
          IconButton(
            icon: Icon(
              movie.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: () {
              movieProvider.addToNewFavorite(movie);
              movieProvider.toggleFavorite(movie);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (movie.posterPath.isNotEmpty)
              Center(
                child: Image.network(
                  'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                  height: 300,
                ),
              ),
            const SizedBox(height: 10),
            Text(
              'Synopsis :',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              movie.overview,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 10),
            Text(
              'Genres : ${movie.genres.isNotEmpty ? movie.genres.join(', ') : 'Pas de genre disponible'}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 10),
            Text(
              'Casting :',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 5),
            FutureBuilder<Map<String, dynamic>>(
              future: movieDetail,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Erreur : ${snapshot.error}');
                } else if (snapshot.hasData) {
                  final movieDetail = snapshot.data?['credits']['cast'] ?? [];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: movieDetail.isNotEmpty
                        ? movieDetail.take(5).map<Widget>((actor) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ActorDetailScreen(
                                      actorId: actor['id'],
                                      actorName: actor['name'],
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                '- ${actor['name']}',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            );
                          }).toList()
                        : [const Text('Aucun acteur répertorié.')],
                  );
                } else {
                  return const Text('Aucune donnée disponible.');
                }
              },
            ),
            const SizedBox(height: 10),
            Text(
              'Évaluation : ${movie.rating}/10',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            // Saisie de la note utilisateur
            UserRatingInput(movie: movie),
            const SizedBox(height: 20),

            // Recommandations
            Text(
              'Recommandations :',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            RecommendationsList(movieId: movie.id),
          ],
        ),
      ),
    );
  }
}
