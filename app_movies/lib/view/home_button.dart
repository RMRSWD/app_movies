import 'package:flutter/material.dart';

class HomeButton extends StatelessWidget {
  final BuildContext currentContext;

  const HomeButton({super.key, required this.currentContext});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.home),
      onPressed: () {
        Navigator.of(currentContext).popUntil((route) => route.isFirst);
      },
      tooltip: 'Retour à l\'accueil',
    );
  }
}
