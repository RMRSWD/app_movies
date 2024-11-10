import 'package:flutter/material.dart';
import 'film.dart';
import 'user_rating_input.dart';
import 'recommendations_list.dart';

class FilmDetailsScreen extends StatelessWidget {
  final Film film;

  const FilmDetailsScreen({super.key, required this.film});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(film.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (film.posterPath.isNotEmpty)
              Image.network('https://image.tmdb.org/t/p/w500${film.posterPath}'),
            const SizedBox(height: 10),
            Text('Synopsis : ${film.overview}'),
            const SizedBox(height: 10),
            Text('Genres : ${film.genres.join(', ')}'),
            const SizedBox(height: 10),
            Text('Casting : ${film.actors.join(', ')}'),
            const SizedBox(height: 10),
            Text('Évaluation : ${film.rating}/10'),
            const SizedBox(height: 10),
            UserRatingInput(film: film),
            const SizedBox(height: 20),
            const Text('Recommandations similaires :'),
            RecommendationsList(filmId: film.id),
          ],
        ),
      ),
    );
  }
}
