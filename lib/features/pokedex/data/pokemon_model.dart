import 'package:flutter/material.dart';

class PokemonModel {
  final int id;
  final String name;
  final String imageUrl;

  PokemonModel({
    required this.id,
    required this.name,
    required this.imageUrl,
  });
}


class PokemonDetail {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> types;
  final String description;
  final double height;
  final double weight;
  final double malePercentage;
  final String generation;
  final List<Stat> stats;
  final List<Evolution> evolutions;

  PokemonDetail({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.description,
    required this.height,
    required this.weight,
    required this.malePercentage,
    required this.generation,
    required this.stats,
    required this.evolutions,
  });
}

class Stat {
  final String name;
  final int value;

  Stat({required this.name, required this.value});
}

class Evolution {
  final String name;
  final String imageUrl;
  final String method;
  final int? level; // Optional for level-based evolutions
  final String? item; // Optional for item-based evolutions

  Evolution({
    required this.name,
    required this.imageUrl,
    required this.method,
    this.level,
    this.item,
  });
}

const Map<String, Color> typeColors = {
  'normal': Colors.grey,
  'fire': Colors.deepOrangeAccent,
  'water': Colors.blueAccent,
  'electric': Colors.amberAccent,
  'grass': Colors.green,
  'ice': Colors.lightBlueAccent,
  'fighting': Colors.redAccent,
  'poison': Colors.purpleAccent,
  'ground': Colors.orangeAccent,
  'flying': Colors.lightBlue,
  'psychic': Colors.pinkAccent,
  'bug': Colors.lime,
  'rock': Color.fromARGB(255, 65, 63, 63),
  'ghost': Colors.deepPurple,
  'dragon': Colors.indigo,
  'dark': Colors.black87,
  'steel': Colors.blueGrey,
  'fairy': Colors.pink,
};