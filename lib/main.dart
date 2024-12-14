import 'package:flutter/material.dart';

void main() {
  runApp(PokedexApp());
}

class PokedexApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pokedex App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokedex Home'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            FeatureCard(
              title: 'Pokédex',
              icon: Icons.search,
              onTap: () {
                // Navigate to Pokémon List screen
              },
            ),
            FeatureCard(
              title: 'Battle Simulator',
              icon: Icons.sports_martial_arts,
              onTap: () {
                // Navigate to Battle Simulator screen
              },
            ),
            FeatureCard(
              title: 'Team Builder',
              icon: Icons.group_work,
              onTap: () {
                // Navigate to Team Builder screen
              },
            ),
            FeatureCard(
              title: 'PokéSnap',
              icon: Icons.camera_alt,
              onTap: () {
                // Navigate to PokeSnap screen
              },
            ),
            FeatureCard(
              title: 'Who\'s That Pokémon?',
              icon: Icons.question_mark,
              onTap: () {
                // Navigate to Who's That Pokémon? screen
              },
            ),
            FeatureCard(
              title: 'Pokémon Trivia',
              icon: Icons.quiz,
              onTap: () {
                // Navigate to Trivia game screen
              },
            ),
            FeatureCard(
              title: 'Achievements',
              icon: Icons.emoji_events,
              onTap: () {
                // Navigate to Achievements screen
              },
            ),
            FeatureCard(
              title: 'Profile',
              icon: Icons.person,
              onTap: () {
                // Navigate to Profile screen
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  FeatureCard({required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48.0,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 8.0),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}