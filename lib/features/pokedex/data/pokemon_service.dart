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
                value: stat['base_stat'],
              ))
          .toList();

      // Extract and clean description
      final rawDescription = speciesData['flavor_text_entries']
          .firstWhere((entry) => entry['language']['name'] == 'en')['flavor_text'];
      final cleanedDescription = _cleanDescription(rawDescription);

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
        description: cleanedDescription,
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
/// Fetch a list of all Pokémon from Generations 1, 2, and 3
Future<List<PokemonModel>> getAllPokemon() async {
  const int totalPokemon = 386; // Generations 1–3
  const String url = '$baseUrl/pokemon?limit=$totalPokemon';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final results = data['results'] as List;

    return Future.wait(results.map((pokemon) async {
      final urlSegments = (pokemon['url'] as String).split('/');
      final id = int.parse(urlSegments[urlSegments.length - 2]);

      // Fetch full details to include types and images
      final detailResponse =
          await http.get(Uri.parse('$baseUrl/pokemon/$id'));
      if (detailResponse.statusCode == 200) {
        final detailData = json.decode(detailResponse.body);

        return PokemonModel(
          id: id,
          name: _capitalize(pokemon['name']),
          imageUrl: detailData['sprites']['front_default'] ??
              'https://via.placeholder.com/96', // Fallback image
          types: List<String>.from(
            detailData['types']?.map((t) => t['type']['name']) ?? [],
          ),
        );
      } else {
        throw Exception('Failed to load details for Pokémon ID: $id');
      }
    }));
  } else {
    throw Exception('Failed to load Pokémon list');
  }
}

/// Helper to capitalize the Pokémon name
String _capitalize(String name) {
  return name[0].toUpperCase() + name.substring(1);
}


  /// Parse the evolution chain data recursively
List<Evolution> _parseEvolutionChain(dynamic data) {
  final List<Evolution> evolutions = [];

  void parseEvolution(dynamic chain) {
    final species = chain['species'];
    final evolutionDetails = chain['evolution_details'];
    
    // Determine the evolution method
    String method = 'base';
    int? level;
    String? item;

    if (evolutionDetails.isNotEmpty) {
      final details = evolutionDetails[0];
      if (details['trigger']['name'] == 'level-up' && details['min_level'] != null) {
        method = 'level-up';
        level = details['min_level'];
      } else if (details['trigger']['name'] == 'use-item' && details['item'] != null) {
        method = 'use-item';
        item = details['item']['name'];
      } else if (details['trigger']['name'] == 'trade') {
        method = 'trade';
        item = details['held_item']?['name']; // Optional trade with an item
      }
    }

    evolutions.add(Evolution(
      name: species['name'],
      imageUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${_getPokemonIdFromUrl(species['url'])}.png',
      method: method,
      level: level,
      item: item,
    ));

    // Recursively parse next evolutions
    for (var next in chain['evolves_to']) {
      parseEvolution(next);
    }
  }

  parseEvolution(data['chain']); // Start parsing from the root
  return evolutions;
}


  /// Helper function to clean up description text
  String _cleanDescription(String rawText) {
    return rawText.replaceAll('\n', ' ').replaceAll('\f', ' ').trim();
  }

  /// Helper function to extract Pokémon ID from the URL
  int _getPokemonIdFromUrl(String url) {
    final segments = url.split('/');
    return int.parse(segments[segments.length - 2]);
  }
}
