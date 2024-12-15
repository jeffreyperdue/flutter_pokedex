import 'dart:convert';
import 'package:http/http.dart' as http;
import 'pokemon_model.dart';

class PokemonService {
  static const String baseUrl = 'https://pokeapi.co/api/v2';

  /// Fetch detailed information about a Pokémon by ID.
  Future<PokemonDetail> fetchPokemonDetail(int id) async {
    // Fetch the Pokémon's main data and species data
    final pokemonResponse = await http.get(Uri.parse('$baseUrl/pokemon/$id'));
    final speciesResponse = await http.get(Uri.parse('$baseUrl/pokemon-species/$id'));

    // Check for successful responses
    if (pokemonResponse.statusCode == 200 && speciesResponse.statusCode == 200) {
      final pokemonData = json.decode(pokemonResponse.body);
      final speciesData = json.decode(speciesResponse.body);

      // Extract types
      final types = (pokemonData['types'] as List)
          .map((type) => type['type']['name'] as String)
          .toList();

      // Extract stats
      final stats = (pokemonData['stats'] as List)
          .map((stat) => Stat(
          name: stat['stat']['name'],
          value: stat['base_stat']))
          .toList();

      // Extract evolutions
      final evolutionChainUrl = speciesData['evolution_chain']['url'];
      final evolutionChainResponse = await http.get(Uri.parse(evolutionChainUrl));
      final evolutionData = json.decode(evolutionChainResponse.body);
      final evolutions = _parseEvolutionChain(evolutionData);

      return PokemonDetail(
        id: pokemonData['id'],
        name: pokemonData['name'],
        imageUrl: pokemonData['sprites']['front_default'],
        types: types,
        description: speciesData['flavor_text_entries']
            .firstWhere((entry) => entry['language']['name'] == 'en')['flavor_text'],
        height: pokemonData['height'] / 10,
        weight: pokemonData['weight'] / 10,
        malePercentage: speciesData['gender_rate'] != -1
            ? (speciesData['gender_rate'] / 8) * 100
            : 0.0,
        generation: speciesData['generation']['name'],
        stats: stats,
        evolutions: evolutions,
      );
    } else {
      throw Exception('Failed to load Pokémon details');
    }
  }

  /// Fetch a list of all Pokémon with their basic data
  Future<List<PokemonModel>> getAllPokemon() async {
    const String url = '$baseUrl/pokemon?limit=151'; // Example: First 151 Pokémon

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List;

      return results.map((pokemon) {
        final urlSegments = (pokemon['url'] as String).split('/');
        final id = int.parse(urlSegments[urlSegments.length - 2]);

        return PokemonModel(
          id: id,
          name: pokemon['name'],
          imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png',
        );
      }).toList();
    } else {
      throw Exception('Failed to load Pokémon list');
    }
  }

  /// Parse the evolution chain data recursively
  List<Evolution> _parseEvolutionChain(dynamic data) {
    final List<Evolution> evolutions = [];
    var current = data['chain'];

    while (current != null) {
      final species = current['species'];
      final evolvesTo = current['evolves_to'];
      evolutions.add(Evolution(
        name: species['name'],
        imageUrl:
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${_getPokemonIdFromUrl(species['url'])}.png',
        method: evolvesTo.isNotEmpty
            ? evolvesTo[0]['evolution_details'][0]['trigger']['name']
            : 'Base',
      ));
      current = evolvesTo.isNotEmpty ? evolvesTo[0] : null;
    }

    return evolutions;
  }

  /// Helper function to extract Pokémon ID from the URL
  int _getPokemonIdFromUrl(String url) {
    final segments = url.split('/');
    return int.parse(segments[segments.length - 2]);
  }
}
