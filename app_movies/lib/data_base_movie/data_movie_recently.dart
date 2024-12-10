import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../modele/movie.dart';

class DataMovieRecent {
  static final DataMovieRecent instance = DataMovieRecent.init();
  static Database? _database;

  DataMovieRecent.init();

  Future<Database> get database async {
    return _database ??= await initData('movierecent.db');
  }

  Future<Database> initData(String fileName) async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, fileName);
      return await openDatabase(path, version: 1, onCreate: createDataBase);
    } catch (e) {
      throw Exception("Database initialization failed: $e");
    }
  }

  Future<void> createDataBase(Database db, int version) async {
    await db.execute(
      '''
      CREATE TABLE movierecent (
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
      )
      ''',
    );
  }

  Future<void> insertMovieRecent(Movie movie) async {
    final db = await instance.database;
    await db.insert('movierecent', movie.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Movie>> getFilmRecent() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'movierecent',
         orderBy: 'releaseDate DESC',
      );
      return maps.map((map) => Movie.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to fetch recent movies: $e');
    }
  }

  Future<void> updateMovieRecent(Movie movie) async {
    final db = await instance.database;
    await db.update(
      'movierecent',
      movie.toMap(),
      where: 'id = ?',
      whereArgs: [movie.id],
    );
  }

  Future<void> deleteMovieRecent(int id) async {
    final db = await instance.database;
    await db.delete('movierecent', where: 'id = ?', whereArgs: [id]);
  }

}
