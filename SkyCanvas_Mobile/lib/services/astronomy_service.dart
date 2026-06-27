import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import '../models/celestial_object.dart';
import '../models/location_data.dart';
import '../utils/coordinate_converter.dart';

class AstronomyService extends ChangeNotifier {
  List<CelestialObject> _allObjects = [];
  List<CelestialObject> _visibleObjects = [];
  DateTime _currentDateTime = DateTime.now();
  LocationData? _observerLocation;
  bool _isLoading = false;

  double _zoomLevel = 1.0;
  double _centerAzimuth = 180.0; // South
  double _centerAltitude = 45.0;  // Mid-sky

  List<CelestialObject> get allObjects => _allObjects;
  List<CelestialObject> get visibleObjects => _visibleObjects;
  DateTime get currentDateTime => _currentDateTime;
  LocationData? get observerLocation => _observerLocation;
  bool get isLoading => _isLoading;

  double get zoomLevel => _zoomLevel;
  double get centerAzimuth => _centerAzimuth;
  double get centerAltitude => _centerAltitude;

  AstronomyService() {
    _loadStarCatalog();
  }

  Future<void> _loadStarCatalog() async {
    _isLoading = true;
    notifyListeners();

    try {
      final String catalogData = await rootBundle.loadString('assets/data/star_catalog.json');
      final List<dynamic> stars = json.decode(catalogData);

      _allObjects = stars.map((star) => CelestialObject.fromJson(star)).toList();
      await updateSkyView();
    } catch (e) {
      // If catalog fails to load, use built-in bright stars
      _loadBuiltInStars();
    }

    _isLoading = false;
    notifyListeners();
  }

  void _loadBuiltInStars() {
    // Fallback: 20 brightest stars
    _allObjects = [
      // Sirius - Brightest star
      CelestialObject(
        id: 'star_sirius',
        name: 'Sirius',
        commonName: 'Alpha Canis Majoris',
        type: ObjectType.star,
        rightAscension: 6.7525,
        declination: -16.7161,
        magnitude: -1.46,
        color: const Color(0xFFCAD7FF),
        spectralType: 'A1V',
        distance: 8.6,
        constellation: 'Canis Major',
        description: 'The brightest star in the night sky',
      ),
      // Canopus
      CelestialObject(
        id: 'star_canopus',
        name: 'Canopus',
        type: ObjectType.star,
        rightAscension: 6.3992,
        declination: -52.6956,
        magnitude: -0.74,
        color: const Color(0xFFFFF4EA),
        spectralType: 'A9II',
        distance: 310,
        constellation: 'Carina',
      ),
      // Arcturus
      CelestialObject(
        id: 'star_arcturus',
        name: 'Arcturus',
        type: ObjectType.star,
        rightAscension: 14.2610,
        declination: 19.1824,
        magnitude: -0.05,
        color: const Color(0xFFFFD2A1),
        spectralType: 'K0III',
        distance: 36.7,
        constellation: 'Bootes',
      ),
      // Vega
      CelestialObject(
        id: 'star_vega',
        name: 'Vega',
        type: ObjectType.star,
        rightAscension: 18.6156,
        declination: 38.7837,
        magnitude: 0.03,
        color: const Color(0xFFAABBFF),
        spectralType: 'A0V',
        distance: 25,
        constellation: 'Lyra',
      ),
      // Capella
      CelestialObject(
        id: 'star_capella',
        name: 'Capella',
        type: ObjectType.star,
        rightAscension: 5.2781,
        declination: 45.9980,
        magnitude: 0.08,
        color: const Color(0xFFFFF4EA),
        spectralType: 'G8III',
        distance: 42.9,
        constellation: 'Auriga',
      ),
      // Rigel
      CelestialObject(
        id: 'star_rigel',
        name: 'Rigel',
        type: ObjectType.star,
        rightAscension: 5.2422,
        declination: -8.2017,
        magnitude: 0.13,
        color: const Color(0xFFAABBFF),
        spectralType: 'B8Ia',
        distance: 860,
        constellation: 'Orion',
      ),
      // Procyon
      CelestialObject(
        id: 'star_procyon',
        name: 'Procyon',
        type: ObjectType.star,
        rightAscension: 7.6553,
        declination: 5.2250,
        magnitude: 0.34,
        color: const Color(0xFFF8F7FF),
        spectralType: 'F5IV',
        distance: 11.5,
        constellation: 'Canis Minor',
      ),
      // Betelgeuse
      CelestialObject(
        id: 'star_betelgeuse',
        name: 'Betelgeuse',
        type: ObjectType.star,
        rightAscension: 5.9195,
        declination: 7.4070,
        magnitude: 0.50,
        color: const Color(0xFFFFCC6F),
        spectralType: 'M1Ia',
        distance: 548,
        constellation: 'Orion',
      ),
      // Altair
      CelestialObject(
        id: 'star_altair',
        name: 'Altair',
        type: ObjectType.star,
        rightAscension: 19.8463,
        declination: 8.8683,
        magnitude: 0.76,
        color: const Color(0xFFF8F7FF),
        spectralType: 'A7V',
        distance: 16.7,
        constellation: 'Aquila',
      ),
      // Aldebaran
      CelestialObject(
        id: 'star_aldebaran',
        name: 'Aldebaran',
        type: ObjectType.star,
        rightAscension: 4.5987,
        declination: 16.5093,
        magnitude: 0.85,
        color: const Color(0xFFFFD2A1),
        spectralType: 'K5III',
        distance: 65.3,
        constellation: 'Taurus',
      ),
      // Spica
      CelestialObject(
        id: 'star_spica',
        name: 'Spica',
        type: ObjectType.star,
        rightAscension: 13.4199,
        declination: -11.1614,
        magnitude: 0.97,
        color: const Color(0xFFAABBFF),
        spectralType: 'B1V',
        distance: 250,
        constellation: 'Virgo',
      ),
      // Antares
      CelestialObject(
        id: 'star_antares',
        name: 'Antares',
        type: ObjectType.star,
        rightAscension: 16.4901,
        declination: -26.4320,
        magnitude: 1.06,
        color: const Color(0xFFFFCC6F),
        spectralType: 'M1Ib',
        distance: 550,
        constellation: 'Scorpius',
      ),
      // Pollux
      CelestialObject(
        id: 'star_pollux',
        name: 'Pollux',
        type: ObjectType.star,
        rightAscension: 7.7553,
        declination: 28.0262,
        magnitude: 1.14,
        color: const Color(0xFFFFD2A1),
        spectralType: 'K0III',
        distance: 33.7,
        constellation: 'Gemini',
      ),
      // Deneb
      CelestialObject(
        id: 'star_deneb',
        name: 'Deneb',
        type: ObjectType.star,
        rightAscension: 20.6905,
        declination: 45.2803,
        magnitude: 1.25,
        color: const Color(0xFFF8F7FF),
        spectralType: 'A2Ia',
        distance: 2615,
        constellation: 'Cygnus',
      ),
      // Regulus
      CelestialObject(
        id: 'star_regulus',
        name: 'Regulus',
        type: ObjectType.star,
        rightAscension: 10.1395,
        declination: 11.9672,
        magnitude: 1.35,
        color: const Color(0xFFCAD7FF),
        spectralType: 'B7V',
        distance: 79.3,
        constellation: 'Leo',
      ),
    ];
  }

  Future<void> updateSkyView() async {
    if (_observerLocation == null) return;

    _visibleObjects = [];

    // Add stars
    for (var star in _allObjects) {
      final coords = CoordinateConverter.equatorialToHorizontal(
        ra: star.rightAscension,
        dec: star.declination,
        lat: _observerLocation!.latitude,
        lon: _observerLocation!.longitude,
        dateTime: _currentDateTime,
      );

      final altitude = coords['altitude']!;
      final azimuth = coords['azimuth']!;

      if (altitude > 0) {
        _visibleObjects.add(star.copyWith(
          altitude: altitude,
          azimuth: azimuth,
          isVisible: true,
        ));
      }
    }

    // Add planets
    final planets = ['Sun', 'Moon', 'Mercury', 'Venus', 'Mars', 'Jupiter', 'Saturn'];

    for (var planetName in planets) {
      final position = CoordinateConverter.calculatePlanetPosition(
        planetName: planetName,
        dateTime: _currentDateTime,
      );

      final coords = CoordinateConverter.equatorialToHorizontal(
        ra: position['ra']!,
        dec: position['dec']!,
        lat: _observerLocation!.latitude,
        lon: _observerLocation!.longitude,
        dateTime: _currentDateTime,
      );

      final altitude = coords['altitude']!;
      final azimuth = coords['azimuth']!;

      if (altitude > -5) { // Show planets slightly below horizon
        Color planetColor = Colors.white;
        double magnitude = 0.0;

        switch (planetName.toLowerCase()) {
          case 'sun':
            planetColor = const Color(0xFFFDB813);
            magnitude = -26.7;
            break;
          case 'moon':
            final moonPhase = CoordinateConverter.calculateMoonPhase(_currentDateTime);
            planetColor = const Color(0xFFE8E8E8);
            magnitude = -12.6;
            break;
          case 'venus':
            planetColor = const Color(0xFFFFF4E6);
            magnitude = -4.0;
            break;
          case 'jupiter':
            planetColor = const Color(0xFFE8D4B0);
            magnitude = -2.0;
            break;
          case 'mars':
            planetColor = const Color(0xFFCD5C5C);
            magnitude = -1.0;
            break;
          case 'mercury':
            planetColor = const Color(0xFFD3D3D3);
            magnitude = -0.5;
            break;
          case 'saturn':
            planetColor = const Color(0xFFEAD6B8);
            magnitude = 0.5;
            break;
        }

        _visibleObjects.add(CelestialObject(
          id: 'planet_${planetName.toLowerCase()}',
          name: planetName,
          type: planetName.toLowerCase() == 'sun' ? ObjectType.sun :
                planetName.toLowerCase() == 'moon' ? ObjectType.moon :
                ObjectType.planet,
          rightAscension: position['ra']!,
          declination: position['dec']!,
          altitude: altitude,
          azimuth: azimuth,
          magnitude: magnitude,
          color: planetColor,
          isVisible: altitude > 0,
        ));
      }
    }

    notifyListeners();
  }

  void setDateTime(DateTime dateTime) {
    _currentDateTime = dateTime;
    updateSkyView();
  }

  void setLocation(LocationData location) {
    _observerLocation = location;
    updateSkyView();
  }

  void setZoom(double zoom) {
    _zoomLevel = zoom.clamp(0.5, 3.0);
    notifyListeners();
  }

  void pan(double deltaAz, double deltaAlt) {
    _centerAzimuth = (_centerAzimuth + deltaAz) % 360;
    _centerAltitude = (_centerAltitude + deltaAlt).clamp(0, 90);
    notifyListeners();
  }

  void resetView() {
    _zoomLevel = 1.0;
    _centerAzimuth = 180.0;
    _centerAltitude = 45.0;
    notifyListeners();
  }

  List<CelestialObject> searchObjects(String query) {
    final lowerQuery = query.toLowerCase();
    return _visibleObjects.where((obj) {
      return obj.name.toLowerCase().contains(lowerQuery) ||
             (obj.commonName?.toLowerCase().contains(lowerQuery) ?? false) ||
             (obj.constellation?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }

  CelestialObject? findObject(String name) {
    return _visibleObjects.cast<CelestialObject?>().firstWhere(
      (obj) => obj!.name.toLowerCase() == name.toLowerCase() ||
               obj.commonName?.toLowerCase() == name.toLowerCase(),
      orElse: () => null,
    );
  }

  void centerOnObject(CelestialObject object) {
    if (object.azimuth != null && object.altitude != null) {
      _centerAzimuth = object.azimuth!;
      _centerAltitude = object.altitude!;
      notifyListeners();
    }
  }
}
