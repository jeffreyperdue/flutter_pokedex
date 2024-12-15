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
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Failed to load Pokémon details'));
        }

        final pokemon = snapshot.data!;

        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: Text('${pokemon.name} (#${pokemon.id})'),
              bottom: TabBar(
                tabs: const [
                  Tab(text: 'About'),
                  Tab(text: 'Stats'),
                  Tab(text: 'Evolution'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                _buildAboutTab(pokemon),
                _buildStatsTab(pokemon),
                _buildEvolutionTab(pokemon),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAboutTab(PokemonDetail pokemon) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Description: ${pokemon.description}', style: TextStyle(fontSize: 16)),
          SizedBox(height: 8),
          Text('Height: ${pokemon.height} m'),
          Text('Weight: ${pokemon.weight} kg'),
          Text('Gender Ratio: ♂ ${pokemon.malePercentage}% / ♀ ${100 - pokemon.malePercentage}%'),
          Text('Generation: ${pokemon.generation}'),
        ],
      ),
    );
  }

  Widget _buildStatsTab(PokemonDetail pokemon) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: pokemon.stats.map((stat) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(stat.name),
              LinearProgressIndicator(value: stat.value / 255.0, minHeight: 8),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEvolutionTab(PokemonDetail pokemon) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: pokemon.evolutions.map((evolution) {
        return ListTile(
          leading: Image.network(evolution.imageUrl),
          title: Text(evolution.name),
          subtitle: Text('Method: ${evolution.method}'),
        );
      }).toList(),
    );
  }
}
