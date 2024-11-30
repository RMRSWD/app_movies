import 'package:flutter/material.dart';
import '../modele/movie.dart';

class MovieTile extends StatelessWidget {
  final Movie movie;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const MovieTile({
    super.key,
    required this.movie,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: movie.posterPath.isNotEmpty
          ? Image.network('https://image.tmdb.org/t/p/w200${movie.posterPath}')
          : const Icon(Icons.movie),
      title: Text(movie.title),
      subtitle: Text('Release: ${movie.releaseDate}\nRating: ${movie.rating}/10'),
      onTap: onTap,
      trailing: IconButton(
        icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.red,),
        onPressed: onFavoriteToggle,
      ),
    );
  }
}