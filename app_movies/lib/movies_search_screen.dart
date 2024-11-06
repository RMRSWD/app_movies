import 'package:flutter/material.dart';
import 'film.dart'; // Modèle Film
import 'api_service.dart'; // Service API pour fetchFilms et fetchRecommendations
import 'package:lottie/lottie.dart';

class MoviesSearchScreen extends StatefulWidget {
  const MoviesSearchScreen({super.key});

  @override
  State<MoviesSearchScreen> createState() => _MoviesSearchScreenState();
}

class _MoviesSearchScreenState extends State<MoviesSearchScreen> {
  late Future<List<Film>> futureFilms;
  String searchQuery = 'Inception';
  List<Film> favorites = [];

  @override
  void initState() {
    super.initState();
    futureFilms = fetchFilms(searchQuery); // Recherche initiale
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rechercher des Films et Séries'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Rechercher un film ou une série',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (query) {
                setState(() {
                  searchQuery = query;
                  futureFilms = fetchFilms(searchQuery);
                });
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Film>>(
                future: futureFilms,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erreur: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Aucun résultat trouvé'));
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Film film = snapshot.data![index];
                      return ListTile(
                        leading: film.posterPath.isNotEmpty
                            ? Image.network('https://image.tmdb.org/t/p/w200${film.posterPath}')
                            : Lottie.asset('assets/animations/no_image.json', width: 50, height: 50),
                        title: Text(film.title),
                        subtitle: Text('Date de sortie : ${film.releaseDate}\nÉvaluation : ${film.rating}/10'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FilmDetailsScreen(film: film),
                            ),
                          );
                        },
                        trailing: IconButton(
                          icon: Icon(favorites.contains(film) ? Icons.favorite : Icons.favorite_border),
                          onPressed: () {
                            setState(() {
                              if (favorites.contains(film)) {
                                favorites.remove(film);
                              } else {
                                favorites.add(film);
                              }
                            });
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Page de détails du film/série
class FilmDetailsScreen extends StatefulWidget {
  final Film film;

  const FilmDetailsScreen({Key? key, required this.film}) : super(key: key);

  @override
  State<FilmDetailsScreen> createState() => _FilmDetailsScreenState();
}

class _FilmDetailsScreenState extends State<FilmDetailsScreen> {
  late Future<List<Film>> recommendations;

  @override
  void initState() {
    super.initState();
    recommendations = fetchRecommendations(widget.film.id); // Fetch des recommandations similaires
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.film.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.film.posterPath.isNotEmpty)
              Image.network('https://image.tmdb.org/t/p/w500${widget.film.posterPath}'),
            const SizedBox(height: 10),
            Text('Synopsis : ${widget.film.overview}'),
            const SizedBox(height: 10),
            Text('Genres : ${widget.film.genres.join(', ')}'),
            const SizedBox(height: 10),
            Text('Casting : ${widget.film.actors.join(', ')}'),
            const SizedBox(height: 10),
            Text('Évaluation : ${widget.film.rating}/10'),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Votre note (0-10)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onSubmitted: (value) {
                setState(() {
                  widget.film.userRating = double.tryParse(value);
                });
              },
            ),
            const SizedBox(height: 20),
            const Text('Recommandations similaires :'),
            FutureBuilder<List<Film>>(
              future: recommendations,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erreur: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('Aucune recommandation trouvée');
                }

                return Column(
                  children: snapshot.data!.map((recommendedFilm) {
                    return ListTile(
                      leading: recommendedFilm.posterPath.isNotEmpty
                          ? Image.network('https://image.tmdb.org/t/p/w200${recommendedFilm.posterPath}')
                          : Lottie.asset('assets/animations/no_image.json', width: 50, height: 50),
                      title: Text(recommendedFilm.title),
                      subtitle: Text('Évaluation : ${recommendedFilm.rating}/10'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FilmDetailsScreen(film: recommendedFilm),
                          ),
                        );
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
