import 'package:flutter/material.dart';
import '../data/pokemon_model.dart';

class PokemonDetailScreen extends StatelessWidget {
  final PokemonModel pokemon;

  const PokemonDetailScreen({required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pokemon.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(pokemon.imageUrl),
            SizedBox(height: 16.0),
            Text(
              pokemon.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              pokemon.type,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
