import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/breed_model.dart';

class DogService {
  static const String _apiKey = 'live_TFZShmVSIFkJb7w8hoglqa9yakFNWgD6ssBlqf9pLD2EV2e48mdamTy6jTpRNucD';
  static const String _baseUrl = 'https://api.thedogapi.com/v1/breeds';

  Future<List<Breed>> fetchBreeds() async {
    final response = await http.get(
      Uri.parse(_baseUrl),
      headers: {'x-api-key': _apiKey},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Breed.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar las razas: ${response.statusCode}');
    }
  }
}
