import 'package:flutter/material.dart';
import '../modele/movie.dart';

class UserRatingInput extends StatefulWidget {
  final Movie film;

  const UserRatingInput({super.key, required this.film});

  @override
  State<UserRatingInput> createState() => _UserRatingInputState();
}

class _UserRatingInputState extends State<UserRatingInput> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        labelText: 'Votre note (0-10)',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      onSubmitted: (value) {
        setState(() {
          widget.film.userRating = double.tryParse(value);
        });
      },
    );
  }
}
