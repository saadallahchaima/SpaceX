import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:test_orange2/constants/appConfig.dart';
//j ai travaillé avec une methode differente : avec un service géneriqe 
// j ai evité data (avec uen certaine documentation)
//j ai séparé l api, pour la reutilisable
class ApiService {
  String _buildUrl(String endpoint, {int? id}) {
    final uri = id != null
        ? Uri.parse('$baseUrl$apiVersion$endpoint/$id')
        : Uri.parse('$baseUrl$apiVersion$endpoint'); 
    return uri.toString();
  }

  Future<List<T>> fetchAll<T>(String endpoint, T Function(Map<String, dynamic>) fromJson) async {
    try {
      final urlSpaceX = _buildUrl(endpoint);  
      final responseSpaceX = await http.get(Uri.parse(urlSpaceX));

      if (responseSpaceX.statusCode == HttpStatus.ok) {
        final List<dynamic> SpaceX = json.decode(responseSpaceX.body);
        return SpaceX.map((json) => fromJson(json)).toList();
      } else {
        throw Exception('Failed to load data from $endpoint');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<T?> fetchById<T>(String endpoint, int id, T Function(Map<String, dynamic>) fromJson) async {
    try {
      final urlSpaceX = _buildUrl(endpoint, id: id); 
      final responseSpaceX = await http.get(Uri.parse(urlSpaceX));

      if (responseSpaceX.statusCode == HttpStatus.ok) {
        return fromJson(json.decode(responseSpaceX.body));
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }
}
