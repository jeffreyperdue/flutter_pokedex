import 'package:flutter/material.dart';
import 'package:pokedex_app/features/pokesnap/pokesnap_screen.dart';
import 'features/pokedex/presentation/pokedex_screen.dart';

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
        fontFamily: 'Roboto',
        primarySwatch: Colors.red,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.redAccent.shade200,
                  Colors.yellow.shade200,
                  Colors.blueAccent.shade200,
                ],
              ),
            ),
          ),
          // Main Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              // Header
              _buildHeader(),
              const SizedBox(height: 50),
              // Feature Cards
              _buildFeatureCards(context),
            ],
          ),
        ],
      ),
    );
  }

  /// Build Header with Custom Font
  Widget _buildHeader() {
    return Center(
      child: Column(
        children: [
          Text(
            "My Dex",
            style: TextStyle(
              fontSize: 36,
              fontFamily: 'MyDex', // Apply custom font here
              color: Color(0xFFFFCB05),
              shadows: [
                Shadow(
                  blurRadius: 1.0,
                  color: Color(0xFF2A75BB),
                  offset: Offset(3.0, 3.0),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Explore the Pokémon World!",
            style: TextStyle(
              fontSize: 18,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}


  /// Build Header with a Bold, Fun Tagline
  Widget _buildHeader() {
    return Center(
      child: Column(
        children: [
          Text(
            "Explore the Pokémon World!",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: Colors.black54,
                  offset: Offset(2.0, 2.0),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Your Journey Begins Here",
            style: TextStyle(
              fontSize: 18,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  /// Build Feature Cards for Navigation
  Widget _buildFeatureCards(BuildContext context) {
    return Expanded(
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _buildFeatureCard(
            context,
            title: "Pokédex",
            icon: Icons.catching_pokemon,
            color: Colors.redAccent.shade400,
            onTap: () {
              Navigator.push(
              context,
            MaterialPageRoute(
              builder: (context) => PokedexScreen(), 
      ),
    );
  },
),
          _buildFeatureCard(
            context,
            title: "PokeSnap",
            icon: Icons.camera_alt,
            color: Colors.blueAccent.shade400,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PokeSnapScreen(),
                )
              );  
            },
          ),
        ],
      ),
    );
  }

  /// Create Individual Feature Card
  Widget _buildFeatureCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(4.0, 4.0),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: Colors.white,
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

/// Placeholder Screen for Navigation
class PlaceholderScreen extends StatelessWidget {
  final String title;

  PlaceholderScreen(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.redAccent,
      ),
      body: Center(
        child: Text(
          "Welcome to the $title Feature!",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
