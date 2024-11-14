import 'package:flutter/material.dart';
import 'film.dart';

class ViewedAndFavoritesScreen extends StatelessWidget{
  final List<Film> favorites;
  final List<Film> recentlyViewed;

  const ViewedAndFavoritesScreen({
    super.key,
    required this.favorites,
    required this.recentlyViewed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favoris et Récement Vus"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Favoris',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: favorites.length,
                itemBuilder: (context, index){
                  final film = favorites[index];
                  return ListTile(
                    leading: film.posterPath.isNotEmpty ? Image.network('https://image.tmdb.org/t/p/w200${film.posterPath}') : const Icon(Icons.movie),
                    title: Text(film.title),
                    subtitle: Text('Evaluation: ${film.rating}/10'),
                  );
                }
                ), 
              ),
              const SizedBox(height: 20),
              const Text(
                'Récement Vus',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Expanded(child: ListView.builder(
                itemCount: recentlyViewed.length,
                itemBuilder: (context, index){
                  final film = recentlyViewed[index];
                  return ListTile(
                    leading: film.posterPath.isNotEmpty ? Image.network('https://image.tmdb.org/t/p/w200${film.posterPath}'): const Icon(Icons.movie),
                    title: Text(film.title),
                    subtitle: Text('Evaluation: ${film.rating}/10'),
                  );
                } ))

          ],
        ),
        ),
    );
  }

}