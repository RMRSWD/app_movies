import 'package:flutter/material.dart';
import 'film.dart';
import 'package:lottie/lottie.dart';

class FilmTile extends StatelessWidget {
  final Film film;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const FilmTile({
    required this.film,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteToggle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: film.posterPath.isNotEmpty
          ? Image.network('https://image.tmdb.org/t/p/w200${film.posterPath}')
          : Lottie.asset('assets/images/no_movie.json', width: 50, height: 50),
      title: Text(film.title),
      subtitle: Text('Date de sortie : ${film.releaseDate}\nÉvaluation : ${film.rating}/10'),
      onTap: onTap,
      trailing: IconButton(
        icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
        onPressed: onFavoriteToggle,
      ),
    );
  }
}
