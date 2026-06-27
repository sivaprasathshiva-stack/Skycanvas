import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/astronomy_service.dart';
import '../models/celestial_object.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<CelestialObject> _searchResults = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query, AstronomyService astronomy) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _searchResults = astronomy.searchObjects(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        title: const Text('Search Sky'),
        elevation: 0,
      ),
      body: Consumer<AstronomyService>(
        builder: (context, astronomy, _) {
          return Column(
            children: [
              // Search bar
              Container(
                color: const Color(0xFF0F172A),
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search for stars, planets, constellations...',
                    hintStyle: const TextStyle(color: Colors.white54),
                    prefixIcon: const Icon(Icons.search, color: Colors.blue),
                    suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.white54),
                          onPressed: () {
                            _searchController.clear();
                            _performSearch('', astronomy);
                          },
                        )
                      : null,
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (query) => _performSearch(query, astronomy),
                ),
              ),

              // Search results
              Expanded(
                child: _buildSearchResults(astronomy),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchResults(AstronomyService astronomy) {
    if (!_isSearching || _searchController.text.isEmpty) {
      return _buildPopularObjects(astronomy);
    }

    if (_searchResults.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.white24),
            SizedBox(height: 16),
            Text(
              'No results found',
              style: TextStyle(color: Colors.white54, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final obj = _searchResults[index];
        return _buildObjectTile(obj, astronomy);
      },
    );
  }

  Widget _buildPopularObjects(AstronomyService astronomy) {
    final popularObjects = [
      'Sirius', 'Betelgeuse', 'Rigel', 'Vega', 'Polaris',
      'Sun', 'Moon', 'Venus', 'Jupiter', 'Mars', 'Saturn'
    ];

    final visiblePopular = popularObjects
        .map((name) => astronomy.findObject(name))
        .where((obj) => obj != null)
        .cast<CelestialObject>()
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Popular Objects',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: visiblePopular.length,
            itemBuilder: (context, index) {
              return _buildObjectTile(visiblePopular[index], astronomy);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildObjectTile(CelestialObject obj, AstronomyService astronomy) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: obj.color.withOpacity(0.3),
          border: Border.all(color: obj.color, width: 2),
        ),
        child: Center(
          child: Icon(
            _getIconForType(obj.type),
            color: obj.color,
            size: 20,
          ),
        ),
      ),
      title: Text(
        obj.displayName,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        obj.typeString + (obj.constellation != null ? ' in ${obj.constellation}' : ''),
        style: const TextStyle(color: Colors.white70, fontSize: 12),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'Mag ${obj.magnitude.toStringAsFixed(1)}',
            style: const TextStyle(color: Colors.blue, fontSize: 12),
          ),
          if (obj.altitude != null)
            Text(
              '${obj.altitude!.toStringAsFixed(0)}° alt',
              style: const TextStyle(color: Colors.white54, fontSize: 10),
            ),
        ],
      ),
      onTap: () {
        astronomy.centerOnObject(obj);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Centered on ${obj.displayName}'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
    );
  }

  IconData _getIconForType(ObjectType type) {
    switch (type) {
      case ObjectType.star:
        return Icons.star;
      case ObjectType.planet:
        return Icons.public;
      case ObjectType.sun:
        return Icons.wb_sunny;
      case ObjectType.moon:
        return Icons.nightlight;
      case ObjectType.constellation:
        return Icons.connect_without_contact;
      case ObjectType.deepSpace:
        return Icons.blur_circular;
    }
  }
}
