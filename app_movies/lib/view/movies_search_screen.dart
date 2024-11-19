import 'package:app_movies/api_service/api_service.dart';
import 'package:app_movies/provider/movie_provider.dart';
import 'package:app_movies/view/film_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:app_movies/modele/movie.dart';
import 'package:app_movies/modele/data_movie.dart';
import 'package:app_movies/view/viewed_and_favorites_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
class MoviesSearchScreen extends StatefulWidget{
  const MoviesSearchScreen({super.key});
  @override
  State<MoviesSearchScreen> createState() =>_MovieSearchScreen();
}

class _MovieSearchScreen extends State<MoviesSearchScreen>{

  late Future<List<Movie>> futureMovie;
  String searchQuery = '';
  final DataMovie db = DataMovie.instance;
  final TextEditingController controller = TextEditingController();
  List<Movie> favorite = [];
  List<Movie> recentViewed = [];


  //initialiser la base de donnée
  Future<void> _initDataBase() async {
    final database = await db.database; 
  }

  @override
  void initState(){
    super.initState();
    // loadFavoris();
    _initDataBase();
    controller.text = searchQuery;
    futureMovie = fetchMovies(searchQuery);
  }

   void searchMovie() {
    setState(() {
      searchQuery = controller.text;
      futureMovie = fetchMovies(searchQuery);
    });
  }


  Future<void> loadFavorites() async {
    final favoriteMovie = await db.getFavorite();
    if(mounted){
    setState(() {
      favorite = favoriteMovie;
    });
    }
  }

  @override
  Widget build(BuildContext context){
    final movieProvider = Provider.of<MovieProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('PHIMMOI.NET'),
        leading: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () async{
             showDialog(
            context: context,
            builder: (context){
              return AlertDialog(
                title: const Text('Les actions vous pouvez faire'),
                actionsAlignment: MainAxisAlignment.start,
                actions: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const MoviesSearchScreen(),)
                          );
                        }
                        , child: const Text('Retour à l\'écran principal'),
                      ),
                      TextButton(
                        onPressed: () async{
                         loadFavorites();
                         Navigator.push(
                                        context, 
                                        MaterialPageRoute(builder: (context) => ViewedAndFavoritesScreen(favorites: movieProvider.favoris, recentlyViewed: movieProvider.recentView))
                                        );
                        },
                        child: const Text('Afficher les favoris'),
                      ),
                    ],
                  ),


                ],
              );
            }
        );
          }, 
          ),
      ),
      body: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: 'Search for a film or series',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (_) => searchMovie(),
              ),
            ),
            IconButton(
              onPressed: searchMovie,
              icon: const Icon(Icons.search),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Expanded(
          child: FutureBuilder<List<Movie>>(
            future: futureMovie,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Erreur: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('Tap on the bar at the top to find movies'),
                );
              }

              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final movie = snapshot.data![index];
                  return ListTile(
                    leading: movie.posterPath.isNotEmpty ? Image.network('https://image.tmdb.org/t/p/w200${movie.posterPath}'): Lottie.asset('assets/images/no_movie.json', width: 50, height: 50),
                    title: Text(movie.title),
                    subtitle: Text('Date de sortie : ${movie.releaseDate}\nÉvaluation : ${movie.rating}/10'),
                    trailing: IconButton(
                      icon: Icon(
                            movieProvider.favoris.any((fav) => fav.id == movie.id)
                                ? Icons.favorite
                                : Icons.favorite_border,
                          ),
                      onPressed: () => movieProvider.toggleFavoris(movie),
                        ),
                    onTap: (){
                      Navigator.push(context, 
                                     MaterialPageRoute(builder: (context) => FilmDetailsScreen(film : movie))
                                      );
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
