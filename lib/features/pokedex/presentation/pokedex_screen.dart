import 'package:flutter/material.dart';
import 'package:pokedex_app/features/pokedex/data/pokemon_service.dart';
import 'package:pokedex_app/features/pokedex/data/pokemon_model.dart';
import 'pokemon_detail_screen.dart';

class PokedexScreen extends StatefulWidget {
  @override
  _PokedexScreenState createState() => _PokedexScreenState();
}

class _PokedexScreenState extends State<PokedexScreen> {
  List<PokemonModel> _allPokemon = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPokemon();
  }

  Future<void> _loadPokemon() async {
    try {
      final pokemonList = await PokemonService.getAllPokemon();
      setState(() {
        _allPokemon = pokemonList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load Pokémon: $e')),
      );
    }
  }

  void _navigateToDetailScreen(BuildContext context, PokemonModel pokemon) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PokemonDetailScreen(pokemon: pokemon),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokédex'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _allPokemon.length,
        itemBuilder: (context, index) {
          final pokemon = _allPokemon[index];
          return ListTile(
            leading: Image.network(pokemon.imageUrl),
            title: Text(pokemon.name),
            subtitle: Text(pokemon.type),
            onTap: () => _navigateToDetailScreen(context, pokemon),
          );
        },
      ),
    );
  }
}
