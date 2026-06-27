import 'dart:math';

class CoordinateConverter {
  static const double deg2rad = pi / 180.0;
  static const double rad2deg = 180.0 / pi;

  // Convert equatorial coordinates (RA/Dec) to horizontal coordinates (Az/Alt)
  static Map<String, double> equatorialToHorizontal({
    required double ra,  // Right Ascension in hours (0-24)
    required double dec, // Declination in degrees (-90 to +90)
    required double lat, // Observer latitude in degrees
    required double lon, // Observer longitude in degrees
    required DateTime dateTime,
  }) {
    // Convert to radians
    final double raRad = ra * 15.0 * deg2rad; // Convert hours to degrees then to radians
    final double decRad = dec * deg2rad;
    final double latRad = lat * deg2rad;

    // Calculate Local Sidereal Time (LST)
    final double lst = calculateLocalSiderealTime(lon, dateTime);
    final double lstRad = lst * 15.0 * deg2rad;

    // Calculate Hour Angle
    final double ha = lstRad - raRad;

    // Calculate Altitude
    final double sinAlt = sin(decRad) * sin(latRad) +
        cos(decRad) * cos(latRad) * cos(ha);
    final double alt = asin(sinAlt);

    // Calculate Azimuth
    final double cosAz = (sin(decRad) - sin(alt) * sin(latRad)) /
        (cos(alt) * cos(latRad));
    double az = acos(cosAz.clamp(-1.0, 1.0));

    // Adjust azimuth based on hour angle
    if (sin(ha) > 0) {
      az = 2 * pi - az;
    }

    return {
      'azimuth': az * rad2deg,
      'altitude': alt * rad2deg,
    };
  }

  // Calculate Local Sidereal Time
  static double calculateLocalSiderealTime(double longitude, DateTime dateTime) {
    final utc = dateTime.toUtc();

    // Julian Date
    final double jd = dateTimeToJulianDate(utc);

    // Days since J2000.0
    final double d = jd - 2451545.0;

    // Greenwich Mean Sidereal Time (GMST) in degrees
    double gmst = 280.46061837 + 360.98564736629 * d;
    gmst = gmst % 360.0;
    if (gmst < 0) gmst += 360.0;

    // Local Sidereal Time
    double lst = gmst + longitude;
    lst = lst % 360.0;
    if (lst < 0) lst += 360.0;

    // Convert to hours
    return lst / 15.0;
  }

  // Convert DateTime to Julian Date
  static double dateTimeToJulianDate(DateTime dateTime) {
    final int year = dateTime.year;
    final int month = dateTime.month;
    final int day = dateTime.day;
    final int hour = dateTime.hour;
    final int minute = dateTime.minute;
    final int second = dateTime.second;

    int a = (14 - month) ~/ 12;
    int y = year + 4800 - a;
    int m = month + 12 * a - 3;

    double jdn = day + (153 * m + 2) ~/ 5 + 365 * y + y ~/ 4 - y ~/ 100 + y ~/ 400 - 32045;

    double jd = jdn + (hour - 12) / 24.0 + minute / 1440.0 + second / 86400.0;

    return jd;
  }

  // Stereographic projection for rendering
  static Map<String, double>? azAltToStereographic({
    required double azimuth,
    required double altitude,
    required double centerAz,
    required double centerAlt,
    double scale = 1.0,
  }) {
    if (altitude < 0) return null; // Below horizon

    final double azRad = azimuth * deg2rad;
    final double altRad = altitude * deg2rad;
    final double centerAzRad = centerAz * deg2rad;
    final double centerAltRad = centerAlt * deg2rad;

    // Angular distance from center
    final double cosDist = sin(altRad) * sin(centerAltRad) +
        cos(altRad) * cos(centerAltRad) * cos(azRad - centerAzRad);

    if (cosDist < 0) return null; // Behind viewer

    // Stereographic projection
    final double k = 2 / (1 + cosDist);

    final double x = k * cos(altRad) * sin(azRad - centerAzRad) * scale;
    final double y = k * (cos(centerAltRad) * sin(altRad) -
        sin(centerAltRad) * cos(altRad) * cos(azRad - centerAzRad)) * scale;

    return {'x': x, 'y': y};
  }

  // Calculate planet position (simplified - for basic sun/moon/planets)
  static Map<String, double> calculatePlanetPosition({
    required String planetName,
    required DateTime dateTime,
  }) {
    // Simplified planetary calculations
    // In production, use a library like 'astronomy' or 'skyfield'
    final double jd = dateTimeToJulianDate(dateTime.toUtc());
    final double d = jd - 2451545.0; // Days since J2000

    switch (planetName.toLowerCase()) {
      case 'sun':
        return _calculateSunPosition(d);
      case 'moon':
        return _calculateMoonPosition(d);
      case 'mercury':
        return _approximatePlanetPosition(d, 0.387, 47.87, 77.45);
      case 'venus':
        return _approximatePlanetPosition(d, 0.723, 35.02, 131.53);
      case 'mars':
        return _approximatePlanetPosition(d, 1.524, 24.13, 336.04);
      case 'jupiter':
        return _approximatePlanetPosition(d, 5.203, 13.06, 14.75);
      case 'saturn':
        return _approximatePlanetPosition(d, 9.537, 9.64, 92.43);
      default:
        return {'ra': 0.0, 'dec': 0.0};
    }
  }

  static Map<String, double> _calculateSunPosition(double d) {
    // Mean longitude
    double L = (280.460 + 0.9856474 * d) % 360.0;
    // Mean anomaly
    double g = (357.528 + 0.9856003 * d) % 360.0;
    double gRad = g * deg2rad;

    // Ecliptic longitude
    double lambda = L + 1.915 * sin(gRad) + 0.020 * sin(2 * gRad);
    double lambdaRad = lambda * deg2rad;

    // Obliquity of ecliptic
    double epsilon = 23.439 - 0.0000004 * d;
    double epsilonRad = epsilon * deg2rad;

    // Right Ascension
    double ra = atan2(cos(epsilonRad) * sin(lambdaRad), cos(lambdaRad));
    ra = ra * rad2deg / 15.0; // Convert to hours
    if (ra < 0) ra += 24;

    // Declination
    double dec = asin(sin(epsilonRad) * sin(lambdaRad)) * rad2deg;

    return {'ra': ra, 'dec': dec};
  }

  static Map<String, double> _calculateMoonPosition(double d) {
    // Simplified moon position
    double L = (218.316 + 13.176396 * d) % 360.0;
    double M = (134.963 + 13.064993 * d) % 360.0;
    double F = (93.272 + 13.229350 * d) % 360.0;

    double MRad = M * deg2rad;
    double FRad = F * deg2rad;

    double lambda = L + 6.289 * sin(MRad);
    double beta = 5.128 * sin(FRad);

    double lambdaRad = lambda * deg2rad;
    double betaRad = beta * deg2rad;

    double epsilon = 23.439 - 0.0000004 * d;
    double epsilonRad = epsilon * deg2rad;

    // Right Ascension
    double ra = atan2(
      sin(lambdaRad) * cos(epsilonRad) - tan(betaRad) * sin(epsilonRad),
      cos(lambdaRad),
    );
    ra = ra * rad2deg / 15.0;
    if (ra < 0) ra += 24;

    // Declination
    double dec = asin(
      sin(betaRad) * cos(epsilonRad) +
      cos(betaRad) * sin(epsilonRad) * sin(lambdaRad),
    ) * rad2deg;

    return {'ra': ra, 'dec': dec};
  }

  static Map<String, double> _approximatePlanetPosition(
    double d,
    double a,
    double n,
    double L0,
  ) {
    // Very simplified orbital calculation
    double M = (L0 + n * d) % 360.0;
    double MRad = M * deg2rad;

    // Approximate ecliptic longitude
    double lambda = M + 2 * sin(MRad) * rad2deg;
    double lambdaRad = lambda * deg2rad;

    double epsilon = 23.439 * deg2rad;

    // Convert to RA/Dec
    double ra = atan2(cos(epsilon) * sin(lambdaRad), cos(lambdaRad));
    ra = ra * rad2deg / 15.0;
    if (ra < 0) ra += 24;

    double dec = asin(sin(epsilon) * sin(lambdaRad)) * rad2deg;

    return {'ra': ra, 'dec': dec};
  }

  // Calculate moon phase
  static Map<String, dynamic> calculateMoonPhase(DateTime dateTime) {
    final double jd = dateTimeToJulianDate(dateTime.toUtc());
    final double d = jd - 2451545.0;

    // Sun's mean longitude
    final double Ls = (280.460 + 0.9856474 * d) % 360.0;

    // Moon's mean longitude
    final double Lm = (218.316 + 13.176396 * d) % 360.0;

    // Phase angle
    double phase = (Lm - Ls) % 360.0;
    if (phase < 0) phase += 360.0;

    // Illumination
    final double illumination = (1 - cos(phase * deg2rad)) / 2;

    String phaseName;
    if (phase < 45) {
      phaseName = 'New Moon';
    } else if (phase < 90) {
      phaseName = 'Waxing Crescent';
    } else if (phase < 135) {
      phaseName = 'First Quarter';
    } else if (phase < 180) {
      phaseName = 'Waxing Gibbous';
    } else if (phase < 225) {
      phaseName = 'Full Moon';
    } else if (phase < 270) {
      phaseName = 'Waning Gibbous';
    } else if (phase < 315) {
      phaseName = 'Last Quarter';
    } else {
      phaseName = 'Waning Crescent';
    }

    return {
      'illumination': illumination,
      'phase': phaseName,
      'phaseAngle': phase,
    };
  }
}
