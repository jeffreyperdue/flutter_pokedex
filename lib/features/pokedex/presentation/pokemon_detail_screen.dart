import 'package:flutter/material.dart';
import '../data/pokemon_model.dart';
import '../data/pokemon_service.dart';

class PokemonDetailScreen extends StatelessWidget {
  final int pokemonId;

  const PokemonDetailScreen({Key? key, required this.pokemonId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PokemonDetail>(
      future: PokemonService().fetchPokemonDetail(pokemonId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Failed to load Pokémon details'));
        }

        final pokemon = snapshot.data!;

        return DefaultTabController(
          length: 3,
          child: Scaffold(
            body: CustomScrollView(
              slivers: [
                _buildHeader(context, pokemon),
                SliverFillRemaining(
                  child: Column(
                    children: [
                      const TabBar(
                        labelColor: Colors.black,
                        indicatorColor: Colors.blueAccent,
                        tabs: [
                          Tab(text: 'About'),
                          Tab(text: 'Stats'),
                          Tab(text: 'Evolution'),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            _buildAboutTab(pokemon),
                            _buildStatsTab(pokemon),
                            _buildEvolutionTab(pokemon),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

Widget _buildHeader(BuildContext context, PokemonDetail pokemon) {
  final Color primaryColor = typeColors[pokemon.types.first] ?? Colors.grey;

  return SliverAppBar(
    expandedHeight: 350, // Increased height to accommodate type buttons
    pinned: true,
    flexibleSpace: FlexibleSpaceBar(
      title: Text(
        '${pokemon.name.toUpperCase()} - #${pokemon.id.toString().padLeft(3, '0')}',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      background: Stack(
        fit: StackFit.expand,
        children: [
          // Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primaryColor,
                  primaryColor.withOpacity(0.6), // Transparent version
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Pokémon Image
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: Image.network(
                pokemon.imageUrl,
                width: 150,
                height: 150,
                fit: BoxFit.contain,
              ),
            ),
          ),
          // Type Buttons
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: pokemon.types.map((type) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Chip(
                    label: Text(
                      type.toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    backgroundColor: typeColors[type] ?? Colors.grey,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    ),
  );
}


  Widget _buildAboutTab(PokemonDetail pokemon) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildInfoTile(Icons.description, 'Description', pokemon.description),
        _buildInfoTile(Icons.height, 'Height', '${pokemon.height} m'),
        _buildInfoTile(Icons.balance, 'Weight', '${pokemon.weight} kg'),
        _buildInfoTile(Icons.transgender, 'Gender Ratio',
            '♂ ${pokemon.malePercentage}% / ♀ ${100 - pokemon.malePercentage}%'),
        _buildInfoTile(Icons.timeline, 'Generation', pokemon.generation),
      ],
    );
  }

  Widget _buildStatsTab(PokemonDetail pokemon) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: pokemon.stats.map((stat) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(stat.name.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 6),
            LinearProgressIndicator(
              value: stat.value / 255.0,
              backgroundColor: Colors.grey[300],
              color: Colors.blueAccent,
              minHeight: 10,
            ),
            SizedBox(height: 8),
          ],
        );
      }).toList(),
    );
  }

Widget _buildEvolutionTab(PokemonDetail pokemon) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.all(16.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: pokemon.evolutions.map((evolution) {
        // Safely determine the evolution method text
        String displayText = '';
        final method = evolution.method?.toLowerCase() ?? '';

        if (method.contains('level') && evolution.level != null) {
          displayText = 'Level ${evolution.level}';
        } else if (method.contains('item') && evolution.item != null) {
          displayText = 'Use ${evolution.item}';
        } else if (method.contains('trade')) {
          displayText = evolution.item != null
              ? 'Trade with ${evolution.item}'
              : 'Trade';
        } else if (method.isEmpty && evolution.level == null && evolution.item == null) {
          displayText = 'Friendship'; // Default for baby Pokémon or happiness evolutions
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(evolution.imageUrl),
                backgroundColor: Colors.white,
              ),
              const SizedBox(height: 8),
              Text(
                evolution.name.toUpperCase(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              if (displayText.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  displayText,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        );
      }).toList(),
    ),
  );
}


  Widget _buildInfoTile(IconData icon, String title, String value) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }
}
