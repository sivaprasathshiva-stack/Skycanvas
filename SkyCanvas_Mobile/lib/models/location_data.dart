class LocationData {
  final double latitude;
  final double longitude;
  final double? altitude;
  final String? name;
  final String? city;
  final String? country;

  LocationData({
    required this.latitude,
    required this.longitude,
    this.altitude,
    this.name,
    this.city,
    this.country,
  });

  String get displayName {
    if (name != null) return name!;
    if (city != null) {
      return country != null ? '$city, $country' : city!;
    }
    return '${latitude.toStringAsFixed(4)}°, ${longitude.toStringAsFixed(4)}°';
  }

  String get coordinatesString =>
    '${latitude.toStringAsFixed(4)}°, ${longitude.toStringAsFixed(4)}°';

  LocationData copyWith({
    double? latitude,
    double? longitude,
    double? altitude,
    String? name,
    String? city,
    String? country,
  }) {
    return LocationData(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      altitude: altitude ?? this.altitude,
      name: name ?? this.name,
      city: city ?? this.city,
      country: country ?? this.country,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'altitude': altitude,
      'name': name,
      'city': city,
      'country': country,
    };
  }

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      latitude: json['latitude'],
      longitude: json['longitude'],
      altitude: json['altitude'],
      name: json['name'],
      city: json['city'],
      country: json['country'],
    );
  }
}
