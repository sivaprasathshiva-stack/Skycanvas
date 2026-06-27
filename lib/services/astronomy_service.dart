import 'dart:convert';
import 'dart:io';
import '../models/celestial_object.dart';

/// Service to communicate with Python astronomy engine
class AstronomyService {
  Future<List<CelestialObject>> calculateSky({
    required double latitude,
    required double longitude,
    required DateTime dateTime,
  }) async {
    try {
      // Call Python script
      final result = await Process.run(
        'python',
        [
          'python/sky_engine.py',
          latitude.toString(),
          longitude.toString(),
          dateTime.year.toString(),
          dateTime.month.toString(),
          dateTime.day.toString(),
          dateTime.hour.toString(),
          dateTime.minute.toString(),
        ],
      );

      if (result.exitCode != 0) {
        throw Exception('Python script failed: ${result.stderr}');
      }

      // Parse JSON output
      final output = result.stdout as String;
      final jsonStart = output.indexOf('{');
      final jsonEnd = output.lastIndexOf('}') + 1;

      if (jsonStart == -1 || jsonEnd == 0) {
        throw Exception('No JSON found in output');
      }

      final jsonStr = output.substring(jsonStart, jsonEnd);
      final data = json.decode(jsonStr) as Map<String, dynamic>;

      // Extract celestial objects
      final objects = <CelestialObject>[];
      final objectsData = data['objects'] as Map<String, dynamic>;

      // Add sun
      if (objectsData.containsKey('sun')) {
        objects.add(CelestialObject.fromJson(objectsData['sun']));
      }

      // Add moon
      if (objectsData.containsKey('moon')) {
        objects.add(CelestialObject.fromJson(objectsData['moon']));
      }

      // Add planets
      if (objectsData.containsKey('planets')) {
        final planets = objectsData['planets'] as List;
        objects.addAll(planets.map((p) => CelestialObject.fromJson(p)));
      }

      // Add stars
      if (objectsData.containsKey('stars')) {
        final stars = objectsData['stars'] as List;
        objects.addAll(stars.map((s) => CelestialObject.fromJson(s)));
      }

      return objects;
    } catch (e) {
      print('Error calculating sky: $e');
      rethrow;
    }
  }

  /// Quick test with sample data
  List<CelestialObject> getSampleSky() {
    return [
      CelestialObject(
        name: 'Vega',
        altitude: 71.0,
        azimuth: 307.0,
        type: 'star',
        magnitude: 0.03,
        color: 'white',
      ),
      CelestialObject(
        name: 'Deneb',
        altitude: 70.0,
        azimuth: 26.0,
        type: 'star',
        magnitude: 0.76,
        color: 'white',
      ),
      CelestialObject(
        name: 'Arcturus',
        altitude: 18.0,
        azimuth: 282.0,
        type: 'star',
        magnitude: -0.72,
        color: 'orange',
      ),
      CelestialObject(
        name: 'Moon',
        altitude: 45.0,
        azimuth: 180.0,
        type: 'moon',
        illumination: 50.0,
      ),
    ];
  }
}
