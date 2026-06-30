import 'package:flutter/material.dart';

enum ObjectType {
  star,
  planet,
  moon,
  sun,
  constellation,
  deepSpace,
}

class CelestialObject {
  final String id;
  final String name;
  final String? commonName;
  final ObjectType type;

  // Position
  final double rightAscension; // hours (0-24)
  final double declination;    // degrees (-90 to +90)
  final double? azimuth;       // degrees (0-360)
  final double? altitude;      // degrees (-90 to +90)

  // Visual properties
  final double magnitude;      // apparent magnitude
  final Color color;
  final double? size;          // angular size in arc-seconds

  // Additional data
  final String? constellation;
  final String? spectralType;
  final double? distance;      // light-years
  final String? description;
  final Map<String, dynamic>? metadata;

  // Visibility
  final bool isVisible;
  final DateTime? riseTime;
  final DateTime? setTime;

  CelestialObject({
    required this.id,
    required this.name,
    this.commonName,
    required this.type,
    required this.rightAscension,
    required this.declination,
    this.azimuth,
    this.altitude,
    required this.magnitude,
    required this.color,
    this.size,
    this.constellation,
    this.spectralType,
    this.distance,
    this.description,
    this.metadata,
    this.isVisible = true,
    this.riseTime,
    this.setTime,
  });

  String get displayName => commonName ?? name;

  String get typeString {
    switch (type) {
      case ObjectType.star:
        return 'Star';
      case ObjectType.planet:
        return 'Planet';
      case ObjectType.moon:
        return 'Moon';
      case ObjectType.sun:
        return 'Sun';
      case ObjectType.constellation:
        return 'Constellation';
      case ObjectType.deepSpace:
        return 'Deep Space Object';
    }
  }

  double get brightnessScale {
    // Convert magnitude to size scale (brighter = larger)
    // Magnitude scale is inverted (lower = brighter)
    if (magnitude < -1) return 8.0;
    if (magnitude < 0) return 6.0;
    if (magnitude < 1) return 5.0;
    if (magnitude < 2) return 4.0;
    if (magnitude < 3) return 3.0;
    if (magnitude < 4) return 2.5;
    if (magnitude < 5) return 2.0;
    return 1.5;
  }

  CelestialObject copyWith({
    String? id,
    String? name,
    String? commonName,
    ObjectType? type,
    double? rightAscension,
    double? declination,
    double? azimuth,
    double? altitude,
    double? magnitude,
    Color? color,
    double? size,
    String? constellation,
    String? spectralType,
    double? distance,
    String? description,
    Map<String, dynamic>? metadata,
    bool? isVisible,
    DateTime? riseTime,
    DateTime? setTime,
  }) {
    return CelestialObject(
      id: id ?? this.id,
      name: name ?? this.name,
      commonName: commonName ?? this.commonName,
      type: type ?? this.type,
      rightAscension: rightAscension ?? this.rightAscension,
      declination: declination ?? this.declination,
      azimuth: azimuth ?? this.azimuth,
      altitude: altitude ?? this.altitude,
      magnitude: magnitude ?? this.magnitude,
      color: color ?? this.color,
      size: size ?? this.size,
      constellation: constellation ?? this.constellation,
      spectralType: spectralType ?? this.spectralType,
      distance: distance ?? this.distance,
      description: description ?? this.description,
      metadata: metadata ?? this.metadata,
      isVisible: isVisible ?? this.isVisible,
      riseTime: riseTime ?? this.riseTime,
      setTime: setTime ?? this.setTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'commonName': commonName,
      'type': type.toString(),
      'rightAscension': rightAscension,
      'declination': declination,
      'azimuth': azimuth,
      'altitude': altitude,
      'magnitude': magnitude,
      'color': color.value,
      'size': size,
      'constellation': constellation,
      'spectralType': spectralType,
      'distance': distance,
      'description': description,
      'metadata': metadata,
      'isVisible': isVisible,
      'riseTime': riseTime?.toIso8601String(),
      'setTime': setTime?.toIso8601String(),
    };
  }

  factory CelestialObject.fromJson(Map<String, dynamic> json) {
    return CelestialObject(
      id: json['id'],
      name: json['name'],
      commonName: json['commonName'],
      type: ObjectType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => ObjectType.star,
      ),
      rightAscension: json['rightAscension'],
      declination: json['declination'],
      azimuth: json['azimuth'],
      altitude: json['altitude'],
      magnitude: json['magnitude'],
      color: Color(json['color']),
      size: json['size'],
      constellation: json['constellation'],
      spectralType: json['spectralType'],
      distance: json['distance'],
      description: json['description'],
      metadata: json['metadata'],
      isVisible: json['isVisible'] ?? true,
      riseTime: json['riseTime'] != null
        ? DateTime.parse(json['riseTime'])
        : null,
      setTime: json['setTime'] != null
        ? DateTime.parse(json['setTime'])
        : null,
    );
  }
}

// Helper to get color from spectral type
Color getColorFromSpectralType(String? spectralType) {
  if (spectralType == null || spectralType.isEmpty) {
    return Colors.white;
  }

  final type = spectralType[0].toUpperCase();
  switch (type) {
    case 'O':
    case 'B':
      return const Color(0xFFAABBFF); // Blue
    case 'A':
      return const Color(0xFFCAD7FF); // Blue-white
    case 'F':
      return const Color(0xFFF8F7FF); // White
    case 'G':
      return const Color(0xFFFFF4EA); // Yellow-white
    case 'K':
      return const Color(0xFFFFD2A1); // Orange
    case 'M':
      return const Color(0xFFFFCC6F); // Red
    default:
      return Colors.white;
  }
}
