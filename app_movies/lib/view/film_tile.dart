/* import 'package:flutter/material.dart';
import '../modele/movie.dart';

class MovieTile extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const MovieTile({
    super.key,
    required this.movie,
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
        icon: Icon(movie.isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.red,),
        onPressed: onFavoriteToggle,
      ),
    );
  }
} */

/* import 'package:flutter/material.dart';
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
  bool isClicked = false; 

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isClicked = true; // Khi nhấp, chuyển sang trạng thái làm mờ
        });
        widget.onTap(); // Gọi callback khi người dùng nhấn
      },
      child: Opacity(
        opacity: isClicked ? 0.5 : 1.0, // Làm mờ nếu đã click
        child: ListTile(
          leading: widget.movie.posterPath.isNotEmpty
              ? Image.network('https://image.tmdb.org/t/p/w200${widget.movie.posterPath}')
              : const Icon(Icons.movie),
          title: Text(widget.movie.title),
          subtitle: Text(
            'Release: ${widget.movie.releaseDate}\nRating: ${widget.movie.rating}/10',
          ),
        ),
      ),
    );
  }
} */



import 'package:flutter/material.dart';
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
        movie.isClicked = true; // Cập nhật trạng thái làm mờ
        onTap(); // Gọi callback khi nhấn
      },
      child: Opacity(
        opacity: movie.isClicked ? 0.5 : 1.0, // Làm mờ dựa trên trạng thái
        child: ListTile(
          leading: movie.posterPath.isNotEmpty
              ? Image.network('https://image.tmdb.org/t/p/w200${movie.posterPath}')
              : const Icon(Icons.movie),
          title: Text(movie.title),
          subtitle: Text(
            'Release: ${movie.releaseDate}\nRating: ${movie.rating}/10',
          ),
        ),
      ),
    );
  }
}
