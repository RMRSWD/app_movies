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
  late AnimationController _animationController;
  late Future<List<Movie>> _futureMovies;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _futureMovies =
        Provider.of<MovieProvider>(context, listen: false).fetchRecommendations();
  }

  void _searchMovies(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        _futureMovies = Provider.of<MovieProvider>(context, listen: false).fetchRecommendations();
      } else {
        _futureMovies = Provider.of<MovieProvider>(context, listen: false).searchMovies(query);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('PHIMMOI.NET'),
        leading: GestureDetector(
          onTap: () {
            _animationController.forward().then((_) => _animationController.reverse());
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ViewedAndFavoritesScreen(),
              ),
            );
          },
          child: ScaleTransition(
            scale: Tween(begin: 1.0, end: 1.2).animate(CurvedAnimation(
              parent: _animationController,
              curve: Curves.easeInOut,
            )),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.favorite, size: 28),
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
                    onSubmitted: _searchMovies, // Xử lý tìm kiếm
                  ),
                ),
                IconButton(
                  onPressed: () => _searchMovies(controller.text), // Tìm kiếm khi nhấn nút
                  icon: const Icon(Icons.search),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Danh sách phim
            Expanded(
              child: FutureBuilder<List<Movie>>(
                future: _futureMovies,
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
                        isFavorite: movie.isFavorite,
                        onTap: () {
                          movieProvider.addToRecent(movie); // Thêm vào Recently Viewed
                          Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FilmDetailsScreen(movie: movie),
                        ),
                      );
                        },
                        onFavoriteToggle: () {
                          movieProvider.addToNewFavorite(movie);
                          movieProvider.toggleFavorite(movie); // Thêm/Xóa khỏi Favorites
                        },
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
