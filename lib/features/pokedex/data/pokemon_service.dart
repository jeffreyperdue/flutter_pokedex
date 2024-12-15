import 'dart:convert';
import 'package:http/http.dart' as http;
import 'pokemon_model.dart';

class PokemonService {
  static Future<List<PokemonModel>> getAllPokemon() async {
    final url = Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=20'); // Fetch first 20 Pokémon
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body); // Decode JSON response
      final results = data['results'] as List;

      // Map API results to a list of PokemonModel
      return results.asMap().entries.map((entry) {
        final index = entry.key + 1; // Pokémon ID (1-based index)
        final pokemon = entry.value;
        return PokemonModel(
          name: pokemon['name'],
          type: 'Unknown', // Replace with actual type if needed
          imageUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$index.png',
        );
      }).toList();
    } else {
      throw Exception('Failed to load Pokémon data');
    }
  }
}
