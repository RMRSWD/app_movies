/* import 'package:app_movies/provider/movie_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modele/movie.dart';
import 'film_detail_screen.dart';

class ActorDetailScreen extends StatefulWidget {
  final int actorId;
  final String actorName;

  const ActorDetailScreen({
    super.key,
    required this.actorId,
    required this.actorName,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ActorDetailScreenState createState() => _ActorDetailScreenState();
}

class _ActorDetailScreenState extends State<ActorDetailScreen> {
  Map<String, dynamic>? actorDetails;
  List<Movie> actorMovies = [];
  bool isLoading = true;


  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context, listen: true);
    actorDetails = movieProvider.fetchActorDetails(widget.actorId) as Map<String, dynamic>?;
    actorMovies = movieProvider.fetchActorMovies(widget.actorId, isLoading) as List<Movie>;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.actorName),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Photo de l'acteur
                  Center(
                    child: actorDetails?['profile_path'] != null
                        ? Image.network(
                            'https://image.tmdb.org/t/p/w500${actorDetails!['profile_path']}',
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.person, size: 150, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  // Nom de l'acteur
                  Text(
                    widget.actorName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Biographie
                  Text(
                    actorDetails?['biography'] ?? 'Aucune biographie disponible.',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  // Liste des films de l'acteur
                  const Text(
                    'Films participés :',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  actorMovies.isEmpty
                      ? const Text(
                          'Aucun film à afficher.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: actorMovies.length,
                          itemBuilder: (context, index) {
                            final movie = actorMovies[index];
                            return ListTile(
                              leading: movie.posterPath.isNotEmpty
                                  ? Image.network(
                                      'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                                      width: 50,
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(Icons.movie, size: 50),
                              title: Text(movie.title),
                              subtitle: Text('Sortie : ${movie.releaseDate}'),
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
                        ),
                ],
              ),
            ),
    );
  }
} */


import 'package:flutter/material.dart';
import '../provider/movie_provider.dart';
import '../modele/movie.dart';
import 'film_detail_screen.dart';
import 'package:provider/provider.dart';

class ActorDetailScreen extends StatelessWidget {
  final int actorId;
  final String actorName;

  const ActorDetailScreen({
    super.key,
    required this.actorId,
    required this.actorName,
  });

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(actorName),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FutureBuilder pour les détails de l'acteur
            FutureBuilder<Map<String, dynamic>>(
              future: movieProvider.fetchActorDetails(actorId),
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
                        actorName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        actorDetails['biography'] ?? 'Aucune biographie disponible.',
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

            // FutureBuilder pour les films de l'acteur
            const Text(
              'Films participés :',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            FutureBuilder<List<Movie>>(
              future: movieProvider.fetchActorMovies(actorId),
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
                      return ListTile(
                        leading: movie.posterPath.isNotEmpty
                            ? Image.network(
                                'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                                width: 50,
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.movie, size: 50),
                        title: Text(movie.title),
                        subtitle: Text('Sortie : ${movie.releaseDate}'),
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


/* 
import 'package:app_movies/provider/movie_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modele/movie.dart';
import 'film_detail_screen.dart';

class ActorDetailScreen extends StatelessWidget {
  final int actorId;
  final String actorName;

  const ActorDetailScreen({
    super.key,
    required this.actorId,
    required this.actorName,
  });

  @override
  Widget build(BuildContext context) {
    // Utilisation du Consumer pour écouter le changement d'état
    return Scaffold(
      appBar: AppBar(
        title: Text(actorName),
      ),
      body: Consumer<MovieProvider>(
        builder: (context, movieProvider, child) {
          // On attend que les données de l'acteur soient chargées
          /* if (movieProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } */

          final actorDetails = movieProvider.fetchActorDetails();
          final actorMovies = movieProvider.fetchActorMovies;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Photo de l'acteur
                Center(
                  child: actorDetails['profile_path'] != null
                      ? Image.network(
                          'https://image.tmdb.org/t/p/w500${actorDetails['profile_path']}',
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.person, size: 150, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                // Nom de l'acteur
                Text(
                  actorName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Biographie
                Text(
                  actorDetails['biography'] ?? 'Aucune biographie disponible.',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                // Liste des films de l'acteur
                const Text(
                  'Films participés :',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                actorMovies.isEmpty
                    ? const Text(
                        'Aucun film à afficher.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: actorMovies.length,
                        itemBuilder: (context, index) {
                          final movie = actorMovies[index];
                          return ListTile(
                            leading: movie.posterPath.isNotEmpty
                                ? Image.network(
                                    'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                                    width: 50,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(Icons.movie, size: 50),
                            title: Text(movie.title),
                            subtitle: Text('Sortie : ${movie.releaseDate}'),
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
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
 */