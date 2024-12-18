import 'package:flutter/material.dart';
import '../data/pokemon_model.dart';
import '../data/pokemon_service.dart';
import 'pokemon_detail_screen.dart';

class PokedexScreen extends StatelessWidget {
  const PokedexScreen({Key? key}) : super(key: key);

  // Map for Type Colors
  Color _getTypeColor(String type) {
    return typeColors[type.toLowerCase()] ?? Colors.grey.shade200;
  }

  // Group Pokémon by Region Dynamically
  Map<String, List<PokemonModel>> _groupByRegion(List<PokemonModel> pokemonList) {
    return {
      'Kanto': pokemonList.where((p) => p.id >= 1 && p.id <= 151).toList(),
      'Johto': pokemonList.where((p) => p.id >= 152 && p.id <= 251).toList(),
      'Hoenn': pokemonList.where((p) => p.id >= 252 && p.id <= 386).toList(),
      'Sinnoh': pokemonList.where((p) => p.id >= 387 && p.id <= 493).toList(),
      'Unova': pokemonList.where((p) => p.id >= 494 && p.id <= 649).toList(),
      'Kalos': pokemonList.where((p) => p.id >= 650 && p.id <= 721).toList(),
      'Alola': pokemonList.where((p) => p.id >= 722 && p.id <= 809).toList(),
      'Galar': pokemonList.where((p) => p.id >= 810 && p.id <= 898).toList(),
      'Paldea': pokemonList.where((p) => p.id >= 899).toList(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Pokédex',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<PokemonModel>>(
        future: PokemonService().getAllPokemon(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final pokemonList = snapshot.data!;
          final regions = _groupByRegion(pokemonList);

          return SingleChildScrollView(
            child: Column(
              children: regions.entries.map((region) {
                final regionName = region.key;
                final pokemons = region.value;

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ExpansionTile(
                    initiallyExpanded: false,
                    title: Text(
                      regionName.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    trailing: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
                    children: [
                      ListView.builder(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  itemCount: pokemons.length,
  itemBuilder: (context, index) {
    final pokemon = pokemons[index];
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PokemonDetailScreen(pokemonId: pokemon.id),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: _buildGradient(pokemon.types),
        ),
        child: Row(
          children: [
            // Pokémon Image
            Image.network(
              pokemon.imageUrl,
              height: 60,
              width: 60,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 12),
            // Pokémon Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '#${pokemon.id.toString().padLeft(3, '0')}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    pokemon.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Pokémon Types
                  Row(
                    children: pokemon.types.map((type) {
                      return Container(
                        margin: const EdgeInsets.only(right: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getTypeColor(type),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          type.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  },
),
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  /// Helper Method: Build Gradient for Dual Types
  LinearGradient _buildGradient(List<String> types) {
    Color primaryColor = typeColors[types.first.toLowerCase()] ?? Colors.grey;
    Color secondaryColor = types.length > 1
        ? typeColors[types[1].toLowerCase()] ?? Colors.grey
        : primaryColor;

    return LinearGradient(
      colors: [primaryColor, secondaryColor],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}
