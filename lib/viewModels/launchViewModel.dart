//class LaunchViewModel 
 //ChangeNotifier 
 //{
 /* List<Launch> _launches = [];
  bool _isLoading = false;
  String _errorMessage = '';
  final LaunchDatabaseHelper _databaseHelper = LaunchDatabaseHelper();
  Launch? _selectedLaunch;
  Launch? get selectedLaunch => _selectedLaunch;
  List<Launch> get launches => _launches;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  final ApiServices _apiServices = ApiServices();

  Future<void> fetchLaunches() async {
    _isLoading = true;
    notifyListeners();

    try {
      final launchesFromDb = await _databaseHelper.getLaunches(); 
      if (launchesFromDb.isNotEmpty) {
        _launches = launchesFromDb; 
        _errorMessage = '';
      } else {
        _launches = await _apiServices.fetchLaunches();
        
        for (var launch in _launches) {
          await insertLaunchToDatabase(launch);  
        }
        _errorMessage = '';
      }
    } catch (e) {
      _errorMessage = 'Failed to load launches: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
Future<void> fetchLaunchDetails(int id) async {
  _isLoading = true;
  notifyListeners();

  try {
    final launchFromDb = await _databaseHelper.getLaunchById(id);
    if (launchFromDb != null) {
      _selectedLaunch = launchFromDb;
      print( 
          'Lancement récupéré depuis la base de données : ${_selectedLaunch!.missionName} ${_selectedLaunch!.details}'
      );
      _errorMessage = '';
    } else {
      final launchFromApi = await _apiServices.fetchLaunchById(id);

      await insertLaunchToDatabase(launchFromApi);
      _selectedLaunch = launchFromApi;
      _errorMessage = '';
        }
  } catch (e) {
    _errorMessage = 'Erreur lors de la récupération des détails du lancement : $e';
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}




  Future<void> insertLaunchToDatabase(Launch launch) async {
    try {
      final db = await _databaseHelper.database;

      await db.insert('spacexLaunches', launch.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);  
    } catch (e) {
      throw Exception("Erreur lors de l'insertion dans la base de données : $e");
    }
  }
}
*/
/*final LaunchDatabaseHelper _databaseHelper = LaunchDatabaseHelper();

 Future<List<Launch>> fetchMissions() async {
    try {
      final uri = Uri.parse('$baseUrl$apiVersion$launchesEndpoint');
      final response = await http.get(uri);
    if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> launches = json.decode(response.body);
        return launches.map((json) => Launch.fromJson(json)).toList();
      } else {
        print('Erreur HTTP: ${response.statusCode}');
        throw Exception('Failed to load launches');
      }
    } catch (error) {
      print('Erreur de récupération des données: $error');
      rethrow;
    }
  }
  Future<Launch?> fetchMissionById(int id) async {
    try {
      final uri = Uri.parse('$baseUrl$apiVersion$launchesEndpoint/$id');
      final response = await http.get(uri);

    if (response.statusCode == HttpStatus.ok) {
        return Launch.fromJson(json.decode(response.body));
      } else {
        return await _databaseHelper.getLaunchById(id);
      }
    } catch (e) {
      return await _databaseHelper.getLaunchById(id);
    }
  }
}*/
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_orange2/constants/appConfig.dart';
import 'package:test_orange2/models/Launch.dart';
import 'package:test_orange2/services/launchService.dart';
import 'package:test_orange2/utils/launchDatabaseHelper.dart';

class LaunchViewModel extends ChangeNotifier {
  final ApiService _apiService;
  final LaunchDatabaseHelper _databaseHelper = LaunchDatabaseHelper();

  bool _isLoading = false;
  String _errorMessage = '';
  List<Launch> _launches = [];
  Launch? _selectedLaunch;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  List<Launch> get launches => _launches;
  Launch? get selectedLaunch => _selectedLaunch;

  LaunchViewModel({required ApiService apiService}) : _apiService = apiService;

  Future<List<Launch>> fetchLaunches() async {
    _setLoading(true);

    try {
      final launchesFromDb = await _databaseHelper.getLaunches();
      if (launchesFromDb.isNotEmpty) {
        _launches = launchesFromDb; 
      } else {
        _launches = await _apiService.fetchAll<Launch>(
          launchesEndpoint,
          (json) => Launch.fromJson(json),
        );

        await _insertLaunchesToDatabase(_launches);
      }
      _errorMessage = ''; 
    } catch (e) {
      _errorMessage = 'Failed to load launches: $e';
      rethrow; 
    } finally {
      _setLoading(false); 
    }

    return _launches;
  }

  Future<Launch> fetchLaunchDetails(int id) async {
    _setLoading(true);

    try {
      final launchFromDb = await _databaseHelper.getLaunchById(id);
      if (launchFromDb != null) {
        _selectedLaunch = launchFromDb; 
        return _selectedLaunch!;
      } else {
        _selectedLaunch = await _apiService.fetchById<Launch>(
          launchesEndpoint,
          id,
          (json) => Launch.fromJson(json),
        );

        if (_selectedLaunch != null) {
          await _insertLaunchToDatabase(_selectedLaunch!);
        }

        return _selectedLaunch!;
      }
    } catch (e) {
      _errorMessage = 'Failed to fetch launch details: $e';
      print("Error fetching details: $e");
      rethrow; 
    } finally {
      _setLoading(false); 
    }
  }

  Future<void> _insertLaunchesToDatabase(List<Launch> launches) async {
    try {
      final db = await _databaseHelper.database;
      final batch = db.batch();

      for (var launch in launches) {
        batch.insert(
          'spacexLaunches',
          launch.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      await batch.commit(); 
    } catch (e) {
      throw Exception("Error inserting launches into the database: $e");
    }
  }

  Future<void> _insertLaunchToDatabase(Launch launch) async {
    try {
      final db = await _databaseHelper.database;
      await db.insert(
        'spacexLaunches',
        launch.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw Exception("Error inserting launch into the database: $e");
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
