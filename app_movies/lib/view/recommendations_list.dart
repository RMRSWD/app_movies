
import 'package:flutter/material.dart';
import '../modele/movie.dart';
import 'film_detail_screen.dart';
import '../api_service/api_service.dart';
import 'package:lottie/lottie.dart';

class RecommendationsList extends StatefulWidget {
  final String movieId;

  const RecommendationsList({super.key, required this.movieId});

  @override
  State<RecommendationsList> createState() => _RecommendationsListState();
}

class _RecommendationsListState extends State<RecommendationsList> {
  final Map<String, bool> clickedMovies = {};

  @override
  Widget build(BuildContext context) {
    bool isHovered = false;
    return FutureBuilder<List<Movie>>(
      future: fetchRecommendations(widget.movieId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No recommendations found');
        }
        return Column(
          children: snapshot.data!.map((recommendedFilm) {
            bool isClicked = clickedMovies[recommendedFilm.id] ?? false;

            return GestureDetector(
              onTap: () {
                setState(() {
                  clickedMovies[recommendedFilm.id] = true; 
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FilmDetailsScreen(movie: recommendedFilm),
                  ),
                );
              },
              child: Opacity(
                opacity: isClicked ? 0.5 : 1.0, 
                child: ListTile(
                  leading: recommendedFilm.posterPath.isNotEmpty
                      ? Image.network('https://image.tmdb.org/t/p/w200${recommendedFilm.posterPath}')
                      : Lottie.asset('assets/images/no_movie.json', width: 50, height: 50),
                  title: Text(recommendedFilm.title),
                  subtitle: Text('Evaluation : ${recommendedFilm.rating}/10'),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
