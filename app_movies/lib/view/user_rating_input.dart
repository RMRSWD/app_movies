/* import 'package:flutter/material.dart';
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
 */

/* import 'package:app_movies/provider/movie_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modele/movie.dart';
import '../modele/data_movie.dart';

class UserRatingInput extends StatefulWidget {
  final Movie movie;

  const UserRatingInput({super.key, required this.movie});

  @override
  State<UserRatingInput> createState() => _UserRatingInputState();
}

class _UserRatingInputState extends State<UserRatingInput> {
  final DataMovie db = DataMovie.instance; // Instance de la base de données
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _noteController.text = widget.movie.userRating?.toString() ?? ''; // Charger la note existante
  }

  /* Future<void> _saveNote() async {
    final note = double.tryParse(_noteController.text); // Convertir la note saisie
    if (note != null && note >= 0 && note <= 10) {
      setState(() {
        widget.movie.userRating = note; // Mettre à jour l'objet local
      });

      await db.updateMovie(widget.movie); // Enregistrer dans la base de données

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note enregistrée avec succès !')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez entrer une note valide (0-10).')),
      );
    }
  } */

  @override
  Widget build(BuildContext context) {
  final movieProvider = Provider.of<MovieProvider>(context, listen: true);    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ajouter ou modifier votre note personnelle :',
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
          onPressed: movieProvider.saveNote(_noteController.text, movie),
          child: const Text('Enregistrer la note'),
        ),
      ],
    );
  }
}
 */


import 'package:app_movies/provider/movie_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modele/movie.dart';
import '../modele/data_movie.dart';

class UserRatingInput extends StatefulWidget {
  final Movie movie;

  const UserRatingInput({super.key, required this.movie});

  @override
  State<UserRatingInput> createState() => _UserRatingInputState();
}

class _UserRatingInputState extends State<UserRatingInput> {
  final DataMovie db = DataMovie.instance; // Instance de la base de données
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _noteController.text = widget.movie.userRating?.toString() ?? ''; // Charger la note existante
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context, listen: true);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ajouter ou modifier votre note personnelle :',
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
                // Message de succès
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Note enregistrée avec succès !')),
                );
              } else {
                // Message d'erreur pour une note invalide
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Veuillez entrer une note valide (0-10).')),
                );
              }
            } else {
              // Message d'erreur pour un champ vide
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Veuillez entrer une note valide (0-10).')),
              );
            }
          },
          child: const Text('Enregistrer la note'),
        ),
      ],
    );
  }
}
