import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:test_orange2/models/missions.dart';

class MissionDatabaseHelper {
  static final MissionDatabaseHelper _instance = MissionDatabaseHelper._internal();
  factory MissionDatabaseHelper() => _instance;

  static Database? _database;

  MissionDatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'missions.db');
      const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    return await openDatabase(path, onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE missions(mission_id $idType, mission_name TEXT, description TEXT, wikipedia TEXT, website TEXT , twitter TEXT)",
      );
    }, version: 1);
  }

 Future<void> insertMission(Mission mission) async {
  try {
    final db = await database;
    await db.insert('missions', mission.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  } catch (e) {
    print("Erreur lors de l'insertion dans la base de données : $e");
   //message uuser-friendly pour le offline
    const SnackBar(content: const Text('Erreur de connexion. Veuillez vérifier votre réseau et réessayer.'));
    throw Exception("Erreur de base de données. Veuillez vérifier votre connexion.");
  }
}

  Future<List<Mission>> getMissions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('missions');
    return List.generate(maps.length, (i) {
      return Mission.fromJson(maps[i]);
    });
  }

  Future<Mission?> getMissionById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'missions',
      where: 'mission_id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Mission.fromJson(maps.first);
    }
    return null;
  }
  
}
