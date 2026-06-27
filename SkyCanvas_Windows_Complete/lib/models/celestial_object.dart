/// Represents a celestial object (star, planet, moon, sun)
class CelestialObject {
  final String name;
  final double altitude; // degrees above horizon
  final double azimuth; // degrees from north
  final String type; // 'star', 'planet', 'moon', 'sun'
  final double? magnitude; // brightness (only for stars)
  final String? color; // color for stars
  final double? illumination; // percentage (only for moon)

  CelestialObject({
    required this.name,
    required this.altitude,
    required this.azimuth,
    required this.type,
    this.magnitude,
    this.color,
    this.illumination,
  });

  factory CelestialObject.fromJson(Map<String, dynamic> json) {
    return CelestialObject(
      name: json['name'] as String,
      altitude: (json['altitude'] as num).toDouble(),
      azimuth: (json['azimuth'] as num).toDouble(),
      type: json['type'] as String,
      magnitude: json['magnitude'] != null ? (json['magnitude'] as num).toDouble() : null,
      color: json['color'] as String?,
      illumination: json['illumination'] != null ? (json['illumination'] as num).toDouble() : null,
    );
  }

  bool get isVisible => altitude > 0;

  /// Get size based on magnitude (brighter = larger)
  double get visualSize {
    if (type == 'moon') return 20.0;
    if (type == 'sun') return 25.0;
    if (type == 'planet') return 8.0;

    // Stars: magnitude to size (lower magnitude = brighter = larger)
    if (magnitude != null) {
      return 10.0 - magnitude!;
    }
    return 5.0;
  }
}
