import 'package:flutter/material.dart';
import '../modele/movie.dart';
import 'film_detail_screen.dart';
import '../api_service/api_service.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../provider/movie_provider.dart';

class RecommendationsList extends StatefulWidget {
  final String movieId;

  const RecommendationsList({super.key, required this.movieId});

  @override
  State<RecommendationsList> createState() => _RecommendationsListState();
}

class _RecommendationsListState extends State<RecommendationsList>
    with TickerProviderStateMixin {
  final Map<String, AnimationController> animationControllers = {};
  final Map<String, Animation<double>> animations = {};

  @override
  void dispose() {
    // Libérer tous les AnimationController
    for (var controller in animationControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Movie>>(
      future: fetchRecommendationsMovieByID(widget.movieId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur : ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('Aucune recommandation trouvée.');
        }

        final recommendations = snapshot.data!;
        return ListView.builder(
          itemCount: recommendations.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final movie = recommendations[index];

            // Créer AnimationController et animation si non existants
            animationControllers[movie.id] ??= AnimationController(
              duration: const Duration(milliseconds: 300),
              vsync: this,
            );

            animations[movie.id] ??=
                Tween<double>(begin: 1.0, end: 1.1).animate(
              CurvedAnimation(
                parent: animationControllers[movie.id]!,
                curve: Curves.easeInOut,
              ),
            );

            final animationController = animationControllers[movie.id]!;
            final animation = animations[movie.id]!;

            return MouseRegion(
              onEnter: (_) => animationController.forward(),
              onExit: (_) => animationController.reverse(),
              child: ScaleTransition(
                scale: animation,
                child: GestureDetector(
                  onTap: () async {
                    // Ajouter le film aux récemment regardés
                    Provider.of<MovieProvider>(context, listen: false)
                        .addToRecent(movie);

                    // Naviguer vers l'écran des détails du film
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FilmDetailsScreen(movie: movie),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: movie.posterPath.isNotEmpty
                        ? Image.network(
                            'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                            fit: BoxFit.cover,
                            width: 50,
                            height: 75,
                          )
                        : Lottie.asset(
                            'assets/images/no_movie.json',
                            width: 50,
                            height: 50,
                          ),
                    title: Text(
                      movie.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Évaluation : ${movie.rating}/10\nData sortie : ${movie.releaseDate.isNotEmpty ? movie.releaseDate : 'Pas de date disponible'}'),
                     
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
