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

  Evolution({required this.name, required this.imageUrl, required this.method});
}
