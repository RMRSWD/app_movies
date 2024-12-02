import 'package:app_movies/view/film_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/movie_provider.dart';
import '../view/film_tile.dart';
import '../view/viewed_and_favorites_screen.dart';
import '../modele/movie.dart';

class MoviesSearchScreen extends StatefulWidget {
  const MoviesSearchScreen({super.key});

  @override
  State<MoviesSearchScreen> createState() => _MoviesSearchScreenState();
}

class _MoviesSearchScreenState extends State<MoviesSearchScreen>
    with SingleTickerProviderStateMixin {
  String searchQuery = '';
  final TextEditingController controller = TextEditingController();
  late AnimationController animationController;
  late Future<List<Movie>> futureMovies;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    futureMovies =
    Provider.of<MovieProvider>(context, listen: false).fetchRecommendations();
  }

  void _searchMovies(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        futureMovies = Provider.of<MovieProvider>(context, listen: false).fetchRecommendations();
      } else {
        futureMovies = Provider.of<MovieProvider>(context, listen: false).searchMovies(query);
      }
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('APP FILM',
        style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        fontFamily: 'Roboto',
        letterSpacing: 2.0, 
      ), 
        ), 
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            animationController.forward().then((_) => animationController.reverse());
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ViewedAndFavoritesScreen(),
              ),
            );
          },
          child: ScaleTransition(
            scale: Tween(begin: 1.0, end: 1.2).animate(CurvedAnimation(
              parent: animationController,
              curve: Curves.easeInOut,
            )),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.favorite,color: Colors.red, size: 28),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Thanh tìm kiếm
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      labelText: 'Search for a movie or series',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: _searchMovies, 
                  ),
                ),
                IconButton(
                  onPressed: () => _searchMovies(controller.text),
                  icon: const Icon(Icons.search),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Movie>>(
                future: futureMovies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No movies found.'));
                  }
                  final movies = snapshot.data!;
                  return ListView.builder(
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      final movie = movies[index];
                      return MovieTile(
                        movie: movie,
                        onTap: () {
                          movieProvider.addToRecent(movie); 
                          Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FilmDetailsScreen(movie: movie),
                        ),
                      );
                        },
                        /* onFavoriteToggle: () {
                          movieProvider.addToNewFavorite(movie);
                          movieProvider.toggleFavorite(movie); // Thêm/Xóa khỏi Favorites
                        }, */
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


