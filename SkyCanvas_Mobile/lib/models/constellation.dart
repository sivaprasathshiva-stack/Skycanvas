class Constellation {
  final String id;
  final String name;
  final String abbreviation;
  final List<ConstellationLine> lines;
  final Map<String, dynamic>? metadata;

  Constellation({
    required this.id,
    required this.name,
    required this.abbreviation,
    required this.lines,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'abbreviation': abbreviation,
      'lines': lines.map((line) => line.toJson()).toList(),
      'metadata': metadata,
    };
  }

  factory Constellation.fromJson(Map<String, dynamic> json) {
    return Constellation(
      id: json['id'],
      name: json['name'],
      abbreviation: json['abbreviation'],
      lines: (json['lines'] as List)
          .map((line) => ConstellationLine.fromJson(line))
          .toList(),
      metadata: json['metadata'],
    );
  }
}

class ConstellationLine {
  final ConstellationPoint start;
  final ConstellationPoint end;

  ConstellationLine({
    required this.start,
    required this.end,
  });

  Map<String, dynamic> toJson() {
    return {
      'start': start.toJson(),
      'end': end.toJson(),
    };
  }

  factory ConstellationLine.fromJson(Map<String, dynamic> json) {
    return ConstellationLine(
      start: ConstellationPoint.fromJson(json['start']),
      end: ConstellationPoint.fromJson(json['end']),
    );
  }
}

class ConstellationPoint {
  final double rightAscension; // hours (0-24)
  final double declination;    // degrees (-90 to +90)
  final String? starName;

  ConstellationPoint({
    required this.rightAscension,
    required this.declination,
    this.starName,
  });

  Map<String, dynamic> toJson() {
    return {
      'ra': rightAscension,
      'dec': declination,
      'starName': starName,
    };
  }

  factory ConstellationPoint.fromJson(Map<String, dynamic> json) {
    return ConstellationPoint(
      rightAscension: json['ra'],
      declination: json['dec'],
      starName: json['starName'],
    );
  }
}
