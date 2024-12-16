import 'package:flutter/material.dart';
import '../data/pokemon_service.dart';
import '../data/pokemon_model.dart';

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
  // Get the color based on the first Pokémon type
  final Color primaryColor = typeColors[pokemon.types.first] ?? Colors.grey;

  return SliverAppBar(
    expandedHeight: 300,
    pinned: true,
    flexibleSpace: FlexibleSpaceBar(
      title: Text(
        '${pokemon.name.toUpperCase()} - #${pokemon.id.toString().padLeft(3, '0')}',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      background: Stack(
        fit: StackFit.expand,
        children: [
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
          Positioned(
            bottom: 40,
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
        ],
      ),
    ),
  );
}

Widget _buildAboutTab(PokemonDetail pokemon) {
  return ListView(
    padding: const EdgeInsets.all(16.0),
    children: [
      // Improved Description Section
      Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.description, color: Colors.blueAccent),
                  const SizedBox(width: 8),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    width: constraints.maxWidth, // Force full width
                    child: Text(
                      pokemon.description,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.5, // Increase line spacing
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 16),

      // Other Info Sections
      _buildInfoTile(Icons.height, 'Height', '${pokemon.height} m'),
      _buildInfoTile(Icons.balance, 'Weight', '${pokemon.weight} kg'),
      _buildInfoTile(Icons.transgender, 'Gender Ratio',
          '♂ ${pokemon.malePercentage}% / ♀ ${100 - pokemon.malePercentage}%'),
      _buildInfoTile(Icons.timeline, 'Generation', pokemon.generation),
    ],
  );
}


  /// Info Tile Helper
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

  /// Modernized Stats Tab with Progress Bars
  Widget _buildStatsTab(PokemonDetail pokemon) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: pokemon.stats.map((stat) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                stat.name.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6),
              LinearProgressIndicator(
                value: stat.value / 255.0, // Normalize to 0-1 range
                backgroundColor: Colors.grey[300],
                color: Colors.blueAccent,
                minHeight: 10,
              ),
              SizedBox(height: 8),
            ],
          ),
        );
      }).toList(),
    );
  }

Widget _buildEvolutionTab(PokemonDetail pokemon) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.all(16.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: pokemon.evolutions.map((evolution) {
        // Safely check evolution method and determine display text
        String displayText = '';
        final method = evolution.method?.toLowerCase() ?? '';

        if (method.contains('level')) {
          displayText = 'Level ${evolution.level ?? '??'}';
        } else if (method.contains('item')) {
          displayText = 'Use ${evolution.item ?? 'an item'}';
        } else if (method.contains('trade')) {
          displayText = evolution.item != null
              ? 'Trade with ${evolution.item}' // Trade with item
              : 'Trade'; // Standard trade evolution
        }

        return Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(evolution.imageUrl),
              ),
              const SizedBox(height: 8),
              Text(
                evolution.name.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              if (displayText.isNotEmpty)
                Text(
                  displayText,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
            ],
          ),
        );
      }).toList(),
    ),
  );
}
}
