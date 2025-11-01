import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pet_model.dart';

class PetService {
  static const String _baseUrl = 'https://api.petfinder.com/v2';
  static const String _apiKey = 'Y2E2hHkdJ67aJh2DHjsitotuEPnIrIgIIz2v6peRy6fD7sTUhZ';
  static const String _apiSecret = 'UXlvFtgCcwr4m2Y8UEKz9rPLFMCrfCw1bj2Jdy1o';

  String? _accessToken;

  /// 🔑 Fetch OAuth access token from Petfinder
  Future<void> _getAccessToken() async {
    if (_accessToken != null) return;

    final url = Uri.parse('$_baseUrl/oauth2/token');
    final response = await http.post(url, body: {
      'grant_type': 'client_credentials',
      'client_id': _apiKey,
      'client_secret': _apiSecret,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _accessToken = data['access_token'];
    } else {
      throw Exception('Failed to get access token');
    }
  }

  /// 🐾 Fetch animals from Petfinder
  Future<List<Pet>> fetchAnimals({
    required String type,
    required String location,
    String? breed,
    String? age,
    String? gender,
  }) async {
    await _getAccessToken();

    final uri = Uri.parse('$_baseUrl/animals').replace(queryParameters: {
      'type': type,
      'location': location,
      if (breed != null) 'breed': breed,
      if (age != null) 'age': age,
      if (gender != null) 'gender': gender,
      'limit': '15',
    });

    final response = await http.get(uri, headers: {
      'Authorization': 'Bearer $_accessToken',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List animals = data['animals'];
      return animals.map((e) => Pet.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load pets: ${response.reasonPhrase}');
    }
  }

  /// 🐶 Fetch breed list for a specific type
  Future<List<String>> fetchBreeds(String type) async {
    await _getAccessToken();

    final uri = Uri.parse('$_baseUrl/types/$type/breeds');
    final response = await http.get(uri, headers: {
      'Authorization': 'Bearer $_accessToken',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final breeds = data['breeds'] as List;
      return breeds.map((b) => b['name'] as String).toList();
    } else {
      throw Exception('Failed to load breeds');
    }
  }
}
