import 'package:flutter/material.dart';
import 'film.dart';
import 'film_tile.dart';
import 'api_service.dart';
import 'film_detail_screen.dart';
import 'viewed_and_favorites_screen.dart';

class MoviesSearchScreen extends StatefulWidget {
  const MoviesSearchScreen({super.key});

  @override
  State<MoviesSearchScreen> createState() => _MoviesSearchScreenState();
}

class _MoviesSearchScreenState extends State<MoviesSearchScreen> {
  late Future<List<Film>> futureFilms;
  String searchQuery = '';
  final TextEditingController _controller = TextEditingController();
  List<Film> favorites = [];
  List<Film> recentlyViewed = [];

  @override
  void initState() {
    super.initState();
    _controller.text = searchQuery;
    futureFilms = fetchFilms(searchQuery);
  }

  void _search() {
    setState(() {
      searchQuery = _controller.text;
      futureFilms = fetchFilms(searchQuery);
    });
  }

  void _toggleFavorite(Film film) {
    setState(() {
      if (favorites.contains(film)) {
        favorites.remove(film);
      } else {
        favorites.add(film);
      }
    });
  }

  void _addToRecentlyViewed(Film film){
    setState(() {
      if(!recentlyViewed. contains(film)){
        recentlyViewed.insert(0, film);
        if(recentlyViewed.length > 10){
          recentlyViewed.removeLast();
        }
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rechercher des Films et Séries'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewedAndFavoritesScreen(
                    favorites: favorites,
                    recentlyViewed: recentlyViewed,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Rechercher un film ou une série',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _search(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _search,
                  icon: const Icon(Icons.search),
                ),
              ],
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
                    return const Center(child: Text('Tapez sur la barre en haut pour trouver les films'));
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final film = snapshot.data![index];
                      return FilmTile(
                        film: film,
                        isFavorite: favorites.contains(film),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FilmDetailsScreen(film: film),
                            ),
                          );
                        },
                        onFavoriteToggle: () => _toggleFavorite(film),
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
