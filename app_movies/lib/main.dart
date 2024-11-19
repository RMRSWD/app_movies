import 'package:app_movies/view/movies_search_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import './provider/movie_provider.dart';
void main(){
  runApp(
      ChangeNotifierProvider(
        create: (_) => MovieProvider(),
        child: const MyApp(),
        ),
  );
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Movie Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MoviesSearchScreen(),
    );
  }
}
