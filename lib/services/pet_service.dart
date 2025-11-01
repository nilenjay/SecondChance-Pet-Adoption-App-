import 'dart:convert';
import 'package:http/http.dart' as http;

class PetService {
  final String _clientId = 'Y2E2hHkdJ67aJh2DHjsitotuEPnIrIgIIz2v6peRy6fD7sTUhZ';       // Petfinder API Key
  final String _clientSecret = 'UXlvFtgCcwr4m2Y8UEKz9rPLFMCrfCw1bj2Jdy1o'; // Petfinder Secret
  String? _accessToken;
  DateTime? _tokenExpiry;

  /// 🔐 Get new access token if expired or null
  Future<void> _getAccessToken() async {
    if (_accessToken != null && _tokenExpiry != null && DateTime.now().isBefore(_tokenExpiry!)) {
      return; // token still valid
    }

    final url = Uri.parse('https://api.petfinder.com/v2/oauth2/token');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'grant_type': 'client_credentials',
        'client_id': _clientId,
        'client_secret': _clientSecret,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _accessToken = data['access_token'];
      final expiresIn = data['expires_in']; // seconds
      _tokenExpiry = DateTime.now().add(Duration(seconds: expiresIn));
    } else {
      throw Exception('Failed to get access token: ${response.statusCode}');
    }
  }

  /// 🐾 Fetch animals list with filters
  Future<List<dynamic>> fetchAnimals({
    String type = 'dog',
    String location = '10001',
    String? breed,
    String? age,
    String? gender,
    int limit = 20,
  }) async {
    await _getAccessToken();

    final query = {
      'type': type,
      'location': location,
      'limit': '$limit',
      if (breed != null) 'breed': breed,
      if (age != null) 'age': age,
      if (gender != null) 'gender': gender,
    };

    final uri = Uri.https('api.petfinder.com', '/v2/animals', query);
    final response = await http.get(uri, headers: {
      'Authorization': 'Bearer $_accessToken',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['animals'] ?? [];
    } else {
      throw Exception('Failed to fetch animals: ${response.statusCode}');
    }
  }

  /// 🐶 Fetch all breeds for a given type (for category filters)
  Future<List<String>> fetchBreeds(String type) async {
    await _getAccessToken();

    final uri = Uri.https('api.petfinder.com', '/v2/types/$type/breeds');
    final response = await http.get(uri, headers: {
      'Authorization': 'Bearer $_accessToken',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final breeds = data['breeds'] as List;
      return breeds.map((b) => b['name'].toString()).toList();
    } else {
      throw Exception('Failed to fetch breeds: ${response.statusCode}');
    }
  }
}
