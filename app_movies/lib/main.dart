import 'dart:io';
import 'package:app_movies/view/movies_search_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'provider/movie_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized;
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    databaseFactory = databaseFactoryFfi; // Initialisation pour desktop
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => MovieProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MoviesSearchScreen(),
    );
  }
}
