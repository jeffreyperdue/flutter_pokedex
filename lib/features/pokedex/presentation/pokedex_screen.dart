import 'package:flutter/material.dart';
import '../data/pokemon_model.dart';
import '../data/pokemon_service.dart';
import 'pokemon_detail_screen.dart';

class PokedexScreen extends StatelessWidget {
  const PokedexScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pokedex')),
      body: FutureBuilder<List<PokemonModel>>(
        future: PokemonService().getAllPokemon(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final pokemonList = snapshot.data!;

          return ListView.builder(
            itemCount: pokemonList.length,
            itemBuilder: (context, index) {
              final pokemon = pokemonList[index];
              return ListTile(
                leading: Image.network(pokemon.imageUrl),
                title: Text(pokemon.name),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PokemonDetailScreen(pokemonId: pokemon.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
