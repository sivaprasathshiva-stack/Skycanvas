/// Represents a constellation with its stars and connecting lines
class Constellation {
  final String name;
  final String abbreviation;
  final String englishName;
  final List<ConstellationLine> lines;
  final Map<String, StarPosition> stars;

  Constellation({
    required this.name,
    required this.abbreviation,
    required this.englishName,
    required this.lines,
    required this.stars,
  });

  factory Constellation.fromJson(Map<String, dynamic> json) {
    final linesData = json['lines'] as List;
    final lines = linesData.map((line) {
      final lineList = line as List;
      return ConstellationLine(
        from: lineList[0] as String,
        to: lineList[1] as String,
      );
    }).toList();

    final starsData = json['stars'] as Map<String, dynamic>;
    final stars = starsData.map((name, data) {
      return MapEntry(
        name,
        StarPosition.fromJson(data as Map<String, dynamic>),
      );
    });

    return Constellation(
      name: json['name'] as String,
      abbreviation: json['abbreviation'] as String,
      englishName: json['englishName'] as String,
      lines: lines,
      stars: stars,
    );
  }
}

/// Represents a line connecting two stars in a constellation
class ConstellationLine {
  final String from;
  final String to;

  ConstellationLine({
    required this.from,
    required this.to,
  });
}

/// Represents the position of a star (RA/Dec)
class StarPosition {
  final double ra;  // Right Ascension in hours
  final double dec; // Declination in degrees

  StarPosition({
    required this.ra,
    required this.dec,
  });

  factory StarPosition.fromJson(Map<String, dynamic> json) {
    return StarPosition(
      ra: (json['ra'] as num).toDouble(),
      dec: (json['dec'] as num).toDouble(),
    );
  }
}
