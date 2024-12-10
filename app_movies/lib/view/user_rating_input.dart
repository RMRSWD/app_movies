import 'package:app_movies/data_base_movie/data_movie_recently.dart';
import 'package:app_movies/provider/movie_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modele/movie.dart';
import '../data_base_movie/data_movie.dart';

class UserRatingInput extends StatefulWidget {
  final Movie movie;

  const UserRatingInput({super.key, required this.movie});

  @override
  State<UserRatingInput> createState() => _UserRatingInputState();
}

class _UserRatingInputState extends State<UserRatingInput> {
  final DataMovie db = DataMovie.instance; // Instance de la base de données
  final DataMovieRecent dbr = DataMovieRecent.instance;
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _noteController.text =
        widget.movie.userRating?.toString() ?? ''; // Charger la note existante
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context, listen: true);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ajoutez ou modifiez votre note personnelle :',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _noteController,
          decoration: const InputDecoration(
            labelText: 'Votre note (0-10)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            final noteText = _noteController.text;
            // Vérification de la validité de la note
            if (noteText.isNotEmpty) {
              final note = double.tryParse(noteText);
              if (note != null && note >= 0 && note <= 10) {
                movieProvider.saveNoteToMovie(note, widget.movie);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Note enregistrée avec succès !')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text(
                          'Veuillez entrer une note valide (entre 0 et 10).')),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text(
                        'Veuillez entrer une note valide (entre 0 et 10).')),
              );
            }
          },
          child: const Text('Enregistrer la note'),
        ),
      ],
    );
  }
}
