import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/location_data.dart';

class LocationService extends ChangeNotifier {
  LocationData? _currentLocation;
  bool _isLoading = false;
  String? _error;
  List<LocationData> _savedLocations = [];

  LocationData? get currentLocation => _currentLocation;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<LocationData> get savedLocations => _savedLocations;

  LocationService() {
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    await requestLocationPermission();
    await getCurrentLocation();
  }

  Future<bool> requestLocationPermission() async {
    final status = await Permission.location.request();
    return status.isGranted;
  }

  Future<void> getCurrentLocation() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      String? cityName;
      String? countryName;

      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          cityName = place.locality ?? place.administrativeArea;
          countryName = place.country;
        }
      } catch (e) {
        // Geocoding failed, but we still have coordinates
      }

      _currentLocation = LocationData(
        latitude: position.latitude,
        longitude: position.longitude,
        altitude: position.altitude,
        city: cityName,
        country: countryName,
      );

      _error = null;
    } catch (e) {
      _error = e.toString();
      // Set default location (New Delhi) if GPS fails
      _currentLocation = LocationData(
        latitude: 28.6139,
        longitude: 77.2090,
        name: 'New Delhi (Default)',
        city: 'New Delhi',
        country: 'India',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setLocation(LocationData location) async {
    _currentLocation = location;
    notifyListeners();
  }

  Future<void> setLocationByCoordinates(double latitude, double longitude) async {
    _isLoading = true;
    notifyListeners();

    try {
      String? cityName;
      String? countryName;

      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          latitude,
          longitude,
        );

        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          cityName = place.locality ?? place.administrativeArea;
          countryName = place.country;
        }
      } catch (e) {
        // Geocoding failed
      }

      _currentLocation = LocationData(
        latitude: latitude,
        longitude: longitude,
        city: cityName,
        country: countryName,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<LocationData?> searchLocation(String query) async {
    try {
      List<Location> locations = await locationFromAddress(query);

      if (locations.isNotEmpty) {
        final location = locations.first;

        String? cityName;
        String? countryName;

        try {
          List<Placemark> placemarks = await placemarkFromCoordinates(
            location.latitude,
            location.longitude,
          );

          if (placemarks.isNotEmpty) {
            final place = placemarks.first;
            cityName = place.locality ?? place.administrativeArea;
            countryName = place.country;
          }
        } catch (e) {
          // Geocoding failed
        }

        return LocationData(
          latitude: location.latitude,
          longitude: location.longitude,
          name: query,
          city: cityName,
          country: countryName,
        );
      }
    } catch (e) {
      _error = 'Location not found';
    }

    return null;
  }

  void saveLocation(LocationData location) {
    if (!_savedLocations.any((loc) =>
      loc.latitude == location.latitude &&
      loc.longitude == location.longitude)) {
      _savedLocations.add(location);
      notifyListeners();
    }
  }

  void removeSavedLocation(LocationData location) {
    _savedLocations.removeWhere((loc) =>
      loc.latitude == location.latitude &&
      loc.longitude == location.longitude);
    notifyListeners();
  }

  // Preset locations
  List<LocationData> getPresetLocations() {
    return [
      LocationData(
        latitude: 40.7128,
        longitude: -74.0060,
        name: 'New York',
        city: 'New York',
        country: 'USA',
      ),
      LocationData(
        latitude: 51.5074,
        longitude: -0.1278,
        name: 'London',
        city: 'London',
        country: 'UK',
      ),
      LocationData(
        latitude: 35.6762,
        longitude: 139.6503,
        name: 'Tokyo',
        city: 'Tokyo',
        country: 'Japan',
      ),
      LocationData(
        latitude: -33.8688,
        longitude: 151.2093,
        name: 'Sydney',
        city: 'Sydney',
        country: 'Australia',
      ),
      LocationData(
        latitude: 28.6139,
        longitude: 77.2090,
        name: 'New Delhi',
        city: 'New Delhi',
        country: 'India',
      ),
      LocationData(
        latitude: 48.8566,
        longitude: 2.3522,
        name: 'Paris',
        city: 'Paris',
        country: 'France',
      ),
    ];
  }
}
