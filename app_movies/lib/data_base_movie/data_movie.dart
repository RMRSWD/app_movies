import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../modele/movie.dart';

class DataMovie {
  static final DataMovie instance = DataMovie.init();
  static Database? _database;

  DataMovie.init();
 // Getter pour la base de données
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initData('movie.db');
    return _database!;
  }

  Future<Database> initData(String fileName) async{
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    return await openDatabase(path, version: 1, onCreate: createDataBase );
  }
  Future<void> createDataBase(Database db, int version) async{
    await db.execute(
      ''' 
      CREATE TABLE movie (
        id INTEGER PRIMARY KEY,
        title TEXT,
        releaseDate TEXT,
        overview TEXT,
        rating REAL,
        posterPath TEXT,
        genres TEXT,
        actors TEXT,
        isFavorite INTEGER,
        userRating REAL,
        mediaType TEXT,
        watchedEpisodes TEXT
      )'''
    );
  }

  Future<void> insertMovie(Movie movie) async{
    final db = await instance.database;
    await db.insert('movie', movie.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Movie>> getFavorite() async{
    final db = await instance.database;
    final result = await db.query('movie', where: 'isFavorite = ?', whereArgs: [1]);
    return result.map((map) => Movie.fromMap(map)).toList();
  }
    Future<void> updateMovie(Movie movie) async {
    final db = await instance.database;
    await db.update(
      'movie',
      movie.toMap(),
      where: 'id = ?',
      whereArgs: [movie.id],
    );
  }
  
  Future<void> deleteMovie(int id) async{
    final db = await instance.database;
    await db.delete('movie', where: 'id = ?', whereArgs: [id]);
  }

}