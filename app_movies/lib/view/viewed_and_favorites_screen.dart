import 'package:app_movies/view/home_button.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../provider/movie_provider.dart';
import '../modele/movie.dart';
import 'film_detail_screen.dart';
import 'hot_movies_screen.dart';

class ViewedAndFavoritesScreen extends StatelessWidget {
  const ViewedAndFavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context, listen: true);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Favoris & Récemment Regardés'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.favorite), text: 'Favoris'),
              Tab(icon: Icon(Icons.history), text: 'Récemment Regardés'),
            ],
          ),
          actions: [
            HomeButton(currentContext: context),
            IconButton(
              icon: const Icon(Icons.local_fire_department),
              tooltip: 'Films liés à vos intérêts',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HotMoviesScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        body: TabBarView(
          children: [
            // Onglet Favoris
            FutureBuilder<List<Movie>>(
              future: movieProvider.fetchFavorites(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erreur : ${snapshot.error}'));
                } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('Aucun film favori ajouté pour le moment.'));
                }
                final favorites = snapshot.data!;
                return _buildMovieListFavoris(
                  favorites,
                  context,
                  movieProvider,
                  showClearButton: true,
                );
              },
            ),

            // Onglet Récemment Regardés
            FutureBuilder<List<Movie>>(
              future: movieProvider.fetchRecents(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erreur : ${snapshot.error}'));
                } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('Aucun film récemment regardé.'));
                }
                final recents = snapshot.data!;
                return _buildMovieListRecent(
                  recents,
                  context,
                  movieProvider,
                  showClearButton: true,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieListFavoris(
    List<Movie> movies,
    BuildContext context,
    MovieProvider movieProvider, {
    required bool showClearButton,
  }) {
    return Column(
      children: [
        if (showClearButton)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                final confirm = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Effacer Tous Les Films Favoris'),
                      content: const Text(
                          'Êtes-vous sûr de vouloir supprimer tous les films que vous aimez ?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Annuler'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Effacer Tout'),
                        ),
                      ],
                    );
                  },
                );

                if (confirm == true) {
                  await movieProvider
                      .clearAllMovieFavoris(); // Appeler la fonction pour supprimer tous les films
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Effacer Tout'),
            ),
          ),
        Expanded(
          child: ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return ListTile(
                leading: movie.posterPath.isNotEmpty
                    ? Image.network(
                        'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                        fit: BoxFit.cover,
                        width: 50,
                      )
                    : Lottie.asset('assets/images/no_movie.json',
                        width: 50, height: 50),
                title: Text(movie.title),
                subtitle: Text('Date de sortie : ${movie.releaseDate}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FilmDetailsScreen(movie: movie),
                    ),
                  );
                },
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    final confirm = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Supprimer un film'),
                          content: const Text(
                              'Êtes-vous sûr de vouloir supprimer ce film ?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Annuler'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Supprimer'),
                            ),
                          ],
                        );
                      },
                    );

                    if (confirm == true) {
                      await movieProvider.deleteMovie(movie);
                    }
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMovieListRecent(
    List<Movie> movies,
    BuildContext context,
    MovieProvider movieProvider, {
    required bool showClearButton,
  }) {
    return Column(
      children: [
        if (showClearButton)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                final confirm = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Effacer Tous Les Films Récents'),
                      content: const Text(
                          'Êtes-vous sûr de vouloir supprimer tous les films récemment regardés ?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Annuler'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Effacer Tout'),
                        ),
                      ],
                    );
                  },
                );

                if (confirm == true) {
                  await movieProvider
                      .clearAllRecents(); // Appeler la fonction pour supprimer tous les films
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Effacer Tout'),
            ),
          ),
        Expanded(
          child: ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return ListTile(
                leading: movie.posterPath.isNotEmpty
                    ? Image.network(
                        'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                        fit: BoxFit.cover,
                        width: 50,
                      )
                    : Lottie.asset('assets/images/no_movie.json',
                        width: 50, height: 50),
                title: Text(movie.title),
                subtitle: Text('Date de sortie : ${movie.releaseDate}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FilmDetailsScreen(movie: movie),
                    ),
                  );
                },
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    final confirm = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Supprimer un film'),
                          content: const Text(
                              'Êtes-vous sûr de vouloir supprimer ce film ?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Annuler'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Supprimer'),
                            ),
                          ],
                        );
                      },
                    );

                    if (confirm == true) {
                      await movieProvider.deleteMovieRecent(movie);
                    }
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
