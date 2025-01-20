import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test_orange2/constants/appConfig.dart';
import 'package:test_orange2/models/missions.dart';
import 'package:test_orange2/utils/MissionDatabaseHelper.dart';

class MissionViewModel {
  final MissionDatabaseHelper _databaseHelper = MissionDatabaseHelper();
  final Uri urlSpaceX = Uri.parse('$baseUrl$apiVersion$missionsEndpoint');

  Future<List<Mission>> fetchMissions(BuildContext context) async {
  try {
    final responseSpaceX = await http.get(urlSpaceX);

    if (responseSpaceX.statusCode == HttpStatus.ok) {
      final List<dynamic> messions = json.decode(responseSpaceX.body);
      await _saveMissionsToLocalDatabase(messions);
      final Iterable<Mission> mappedMissions = messions.map((json) => Mission.fromJson(json)); 
      return mappedMissions.toList(); 
    } else {
      print('Erreur HTTP: ${responseSpaceX.statusCode}');
      throw Exception('Échec du chargement des missions');
    }
  } catch (error) {
    print('Erreur de récupération des données: $error');
    // Afficher L erreur pour le user 
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erreur'),
          content: const Text(
              'Erreur de connexion. Veuillez vérifier votre réseau et réessayer.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
    return await _databaseHelper.getMissions();
  }
}


  Future<Mission?> fetchMissionById(String id) async {
    try {
      final responseSpaceX = await http.get(Uri.parse('$urlSpaceX/$id'));

      if (responseSpaceX.statusCode == HttpStatus.ok) {
        return Mission.fromJson(json.decode(responseSpaceX.body));
      } else {
        return await _databaseHelper.getMissionById(id);
      }
    } catch (e) {
      print('Erreur lors de la récupération de la mission avec ID $id: $e');
      return await _databaseHelper.getMissionById(id);
    }
  }

  Future<void> _saveMissionsToLocalDatabase(List<dynamic> missions) async {
    try {
      for (var missionJson in missions) {
        final mission = Mission.fromJson(missionJson);
        await _databaseHelper.insertMission(mission);
      }
    } catch (e) {
      print('Erreur lors de la sauvegarde des missions dans la base locale: $e');
    }
  }
}
