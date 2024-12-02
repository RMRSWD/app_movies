import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../modele/movie.dart';

class MovieTile extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;

  const MovieTile({
    super.key,
    required this.movie,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        movie.isClicked = true;
        onTap();
      },
      child: Opacity(
        opacity: movie.isClicked ? 0.5 : 1.0, 
        child: ListTile(
          leading: movie.posterPath.isNotEmpty
              ? Image.network('https://image.tmdb.org/t/p/w200${movie.posterPath}')
              : Lottie.asset('assets/images/no_movie.json', width: 50, height: 50),
          title: Text(movie.title),
          subtitle: Text(
            'Release: ${movie.releaseDate}\nRating: ${movie.rating}/10',
          ),
        ),
      ),
    );
  }
}
