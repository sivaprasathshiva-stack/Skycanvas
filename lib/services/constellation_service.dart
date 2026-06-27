import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/constellation.dart';

/// Service for managing constellation data
class ConstellationService {
  List<Constellation> _constellations = [];
  bool _isLoaded = false;

  /// Load constellation data from assets
  Future<void> loadConstellations() async {
    if (_isLoaded) return;

    try {
      final jsonString = await rootBundle.loadString('assets/data/constellations.json');
      final jsonList = json.decode(jsonString) as List;

      _constellations = jsonList
          .map((json) => Constellation.fromJson(json as Map<String, dynamic>))
          .toList();

      _isLoaded = true;
      print('Loaded ${_constellations.length} constellations');
    } catch (e) {
      print('Error loading constellations: $e');
      rethrow;
    }
  }

  /// Get all constellations
  List<Constellation> get constellations => List.unmodifiable(_constellations);

  /// Get constellation by name
  Constellation? getByName(String name) {
    try {
      return _constellations.firstWhere(
        (c) => c.name.toLowerCase() == name.toLowerCase() ||
            c.abbreviation.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  /// Check if constellations are loaded
  bool get isLoaded => _isLoaded;

  /// Get constellation names for dropdown
  List<String> getConstellationNames() {
    return _constellations.map((c) => c.name).toList()..sort();
  }
}
