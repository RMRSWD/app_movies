import 'package:app_movies/view/home_button.dart';
import 'package:flutter/material.dart';
import '../provider/movie_provider.dart';
import '../modele/movie.dart';
import 'film_detail_screen.dart';
import 'package:provider/provider.dart';

class ActorDetailScreen extends StatefulWidget {
  final int actorId;
  final String actorName;

  const ActorDetailScreen({
    super.key,
    required this.actorId,
    required this.actorName,
  });

  @override
  State<ActorDetailScreen> createState() => _ActorDetailScreenState();
}

class _ActorDetailScreenState extends State<ActorDetailScreen>
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
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.actorName),
        actions: [HomeButton(currentContext: context)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FutureBuilder pour afficher les détails de l'acteur
            FutureBuilder<Map<String, dynamic>>(
              future: movieProvider.fetchActorDetails(widget.actorId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Erreur : ${snapshot.error}');
                } else if (snapshot.hasData) {
                  final actorDetails = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (actorDetails['profile_path'] != null)
                        Center(
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w500${actorDetails['profile_path']}',
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                      const SizedBox(height: 16),
                      Text(
                        widget.actorName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        actorDetails['biography'] ??
                            'Biographie non disponible.',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  );
                } else {
                  return const Text('Aucun détail disponible.');
                }
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Films :',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // FutureBuilder pour afficher les films de l'acteur
            FutureBuilder<List<Movie>>(
              future: movieProvider.fetchActorMovies(widget.actorId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Erreur : ${snapshot.error}');
                } else if (snapshot.hasData) {
                  final actorMovies = snapshot.data!;
                  if (actorMovies.isEmpty) {
                    return const Text(
                      'Aucun film à afficher.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: actorMovies.length,
                    itemBuilder: (context, index) {
                      final movie = actorMovies[index];

                      // Créer un AnimationController et une animation si non existants
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

                      final animationController =
                          animationControllers[movie.id]!;
                      final animation = animations[movie.id]!;

                      return MouseRegion(
                        onEnter: (_) => animationController.forward(),
                        onExit: (_) => animationController.reverse(),
                        child: ScaleTransition(
                          scale: animation,
                          child: ListTile(
                            leading: movie.posterPath.isNotEmpty
                                ? Image.network(
                                    'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                                    fit: BoxFit.cover,
                                    width: 50,
                                    height: 75,
                                  )
                                : const Icon(Icons.movie, size: 50),
                            title: Text(
                              movie.title,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text('Sortie : ${movie.releaseDate}'),
                            onTap: () {
                              // Ajouter le film aux récemment regardés
                              Provider.of<MovieProvider>(context, listen: false)
                                  .addToRecent(movie);

                              // Naviguer vers l'écran des détails du film
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      FilmDetailsScreen(movie: movie),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Text('Aucun film à afficher.');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
