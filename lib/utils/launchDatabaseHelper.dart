import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_orange2/models/Launch.dart';

class LaunchDatabaseHelper {
  static final LaunchDatabaseHelper _instance = LaunchDatabaseHelper._internal();
  factory LaunchDatabaseHelper() => _instance;

  static Database? _database;

  LaunchDatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'launch.db');
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    return await openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE SpacexLaunches (flight_number $idType, mission_name $textType, details $textType, launch_year TEXT )",
        );
      },
      version: 1,
    );
  }


  Future<void> insertLaunch(Launch launch) async {
    try {
      final db = await database;

      await db.insert(
        'SpacexLaunches',
        launch.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      _handleError('Erreur lors de l\'insertion du lancement', e);
      rethrow;  
    }
  }

  Future<List<Launch>> getLaunches() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query('SpacexLaunches');

      return List.generate(maps.length, (i) {
        return Launch.fromJson(maps[i]);
      });
    } catch (e) {
      _handleError('Erreur lors de la récupération des lancements', e);
      return [];
    }
  }

  Future<Launch?> getLaunchById(int id) async {
    try {
      final db = await database;

      final List<Map<String, dynamic>> maps = await db.query(
        'SpacexLaunches',
        where: 'flight_number = ?',
        whereArgs: [id],
      );

      if (maps.isNotEmpty) {
        return Launch.fromJson(maps.first);
      }
      return null;
    } catch (e) {
      _handleError('Erreur lors de la récupération du lancement avec ID $id', e);
      return null;
    }
  }

  Future<void> insertMultipleLaunches(List<Launch> launches) async {
    try {
      final db = await database;
      final batch = db.batch();

      for (var launch in launches) {
        batch.insert(
          'SpacexLaunches',
          launch.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit();
    } catch (e) {
      _handleError('Erreur lors de l\'insertion multiple de lancements', e);
      rethrow;
    }
  }

  Future<void> createIndex() async {
    try {
      final db = await database;

      await db.execute(
          'CREATE INDEX IF NOT EXISTS idx_flight_number ON SpacexLaunches(flight_number)');
    } catch (e) {
      _handleError('Erreur lors de la création de l\'index', e);
    }
  }

  void _handleError(String message, dynamic error) {
    print('$message: $error');
  }
}
