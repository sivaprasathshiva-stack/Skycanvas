import 'package:flutter/material.dart';
import 'package:shared_preferences.dart';

class SettingsService extends ChangeNotifier {
  static const String _keyNightMode = 'night_mode';
  static const String _keyShowConstellations = 'show_constellations';
  static const String _keyShowConstellationNames = 'show_constellation_names';
  static const String _keyShowPlanets = 'show_planets';
  static const String _keyMagnitudeLimit = 'magnitude_limit';
  static const String _keyAutoLocation = 'auto_location';
  static const String _keyBeginnerMode = 'beginner_mode';

  SharedPreferences? _prefs;

  bool _isNightMode = false;
  bool _showConstellations = true;
  bool _showConstellationNames = true;
  bool _showPlanets = true;
  double _magnitudeLimit = 5.0;
  bool _autoLocation = true;
  bool _beginnerMode = false;

  bool get isNightMode => _isNightMode;
  bool get showConstellations => _showConstellations;
  bool get showConstellationNames => _showConstellationNames;
  bool get showPlanets => _showPlanets;
  double get magnitudeLimit => _magnitudeLimit;
  bool get autoLocation => _autoLocation;
  bool get beginnerMode => _beginnerMode;

  SettingsService() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _prefs = await SharedPreferences.getInstance();
    _isNightMode = _prefs?.getBool(_keyNightMode) ?? false;
    _showConstellations = _prefs?.getBool(_keyShowConstellations) ?? true;
    _showConstellationNames = _prefs?.getBool(_keyShowConstellationNames) ?? true;
    _showPlanets = _prefs?.getBool(_keyShowPlanets) ?? true;
    _magnitudeLimit = _prefs?.getDouble(_keyMagnitudeLimit) ?? 5.0;
    _autoLocation = _prefs?.getBool(_keyAutoLocation) ?? true;
    _beginnerMode = _prefs?.getBool(_keyBeginnerMode) ?? false;
    notifyListeners();
  }

  Future<void> setNightMode(bool value) async {
    _isNightMode = value;
    await _prefs?.setBool(_keyNightMode, value);
    notifyListeners();
  }

  Future<void> toggleNightMode() async {
    await setNightMode(!_isNightMode);
  }

  Future<void> setShowConstellations(bool value) async {
    _showConstellations = value;
    await _prefs?.setBool(_keyShowConstellations, value);
    notifyListeners();
  }

  Future<void> toggleShowConstellations() async {
    await setShowConstellations(!_showConstellations);
  }

  Future<void> setShowConstellationNames(bool value) async {
    _showConstellationNames = value;
    await _prefs?.setBool(_keyShowConstellationNames, value);
    notifyListeners();
  }

  Future<void> setShowPlanets(bool value) async {
    _showPlanets = value;
    await _prefs?.setBool(_keyShowPlanets, value);
    notifyListeners();
  }

  Future<void> setMagnitudeLimit(double value) async {
    _magnitudeLimit = value;
    await _prefs?.setDouble(_keyMagnitudeLimit, value);
    notifyListeners();
  }

  Future<void> setAutoLocation(bool value) async {
    _autoLocation = value;
    await _prefs?.setBool(_keyAutoLocation, value);
    notifyListeners();
  }

  Future<void> setBeginnerMode(bool value) async {
    _beginnerMode = value;
    await _prefs?.setBool(_keyBeginnerMode, value);
    notifyListeners();
  }

  Future<void> resetToDefaults() async {
    await setNightMode(false);
    await setShowConstellations(true);
    await setShowConstellationNames(true);
    await setShowPlanets(true);
    await setMagnitudeLimit(5.0);
    await setAutoLocation(true);
    await setBeginnerMode(false);
  }
}
