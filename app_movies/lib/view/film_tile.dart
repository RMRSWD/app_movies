import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../modele/movie.dart';

class MovieTile extends StatefulWidget {
  final Movie movie;
  final VoidCallback onTap;

  const MovieTile({
    super.key,
    required this.movie,
    required this.onTap,
  });

    @override
  State<MovieTile> createState() => _MovieTileState();
}
class _MovieTileState extends State<MovieTile> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.movie.isClicked = true;
        widget.onTap();
      },
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            isHovered = true; 
          });
        },
        onExit: (_) {
          setState(() {
            isHovered = false; 
          });
        },
      child: Opacity(
        opacity: widget.movie.isClicked ? 0.5 : 1.0, 
        child: AnimatedScale(
            scale: isHovered ? 1.02 : 1.0, 
            duration: const Duration(milliseconds: 200),
        child: ListTile(
          leading: widget.movie.posterPath.isNotEmpty
              ? Image.network('https://image.tmdb.org/t/p/w200${widget.movie.posterPath}')
              : Lottie.asset('assets/images/no_movie.json', width: 50, height: 50),
          title: Text(widget.movie.title),
          subtitle: Text(
            'Release: ${widget.movie.releaseDate}\nRating: ${widget.movie.rating}/10',
          ),
        ),
      ),
      ),
      ),
    );
  }
}