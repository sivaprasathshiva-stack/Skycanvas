import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/celestial_object.dart';
import '../utils/coordinate_converter.dart';

class SkyCanvas extends StatefulWidget {
  final List<CelestialObject> objects;
  final double centerAzimuth;
  final double centerAltitude;
  final double zoomLevel;
  final bool showConstellations;
  final Function(CelestialObject)? onObjectTap;

  const SkyCanvas({
    super.key,
    required this.objects,
    this.centerAzimuth = 180.0,
    this.centerAltitude = 45.0,
    this.zoomLevel = 1.0,
    this.showConstellations = false,
    this.onObjectTap,
  });

  @override
  State<SkyCanvas> createState() => _SkyCanvasState();
}

class _SkyCanvasState extends State<SkyCanvas> {
  CelestialObject? _selectedObject;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => _handleTap(details.localPosition),
      child: CustomPaint(
        painter: SkyPainter(
          objects: widget.objects,
          centerAzimuth: widget.centerAzimuth,
          centerAltitude: widget.centerAltitude,
          zoomLevel: widget.zoomLevel,
          showConstellations: widget.showConstellations,
          selectedObject: _selectedObject,
        ),
        size: Size.infinite,
      ),
    );
  }

  void _handleTap(Offset position) {
    final size = context.size!;
    final center = Offset(size.width / 2, size.height / 2);

    double minDistance = double.infinity;
    CelestialObject? tappedObject;

    for (var obj in widget.objects) {
      if (obj.azimuth == null || obj.altitude == null) continue;

      final projected = CoordinateConverter.azAltToStereographic(
        azimuth: obj.azimuth!,
        altitude: obj.altitude!,
        centerAz: widget.centerAzimuth,
        centerAlt: widget.centerAltitude,
        scale: 300 * widget.zoomLevel,
      );

      if (projected != null) {
        final objPos = Offset(
          center.dx + projected['x']!,
          center.dy - projected['y']!,
        );

        final distance = (position - objPos).distance;
        final hitRadius = obj.brightnessScale * 5;

        if (distance < hitRadius && distance < minDistance) {
          minDistance = distance;
          tappedObject = obj;
        }
      }
    }

    if (tappedObject != null) {
      setState(() => _selectedObject = tappedObject);
      widget.onObjectTap?.call(tappedObject);
    }
  }
}

class SkyPainter extends CustomPainter {
  final List<CelestialObject> objects;
  final double centerAzimuth;
  final double centerAltitude;
  final double zoomLevel;
  final bool showConstellations;
  final CelestialObject? selectedObject;

  SkyPainter({
    required this.objects,
    this.centerAzimuth = 180.0,
    this.centerAltitude = 45.0,
    this.zoomLevel = 1.0,
    this.showConstellations = false,
    this.selectedObject,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Draw horizon circle
    _drawHorizon(canvas, center, size);

    // Draw cardinal directions
    _drawCardinalDirections(canvas, center, size);

    // Draw constellation lines (if enabled)
    if (showConstellations) {
      _drawConstellationLines(canvas, center);
    }

    // Draw objects (stars, planets)
    for (var obj in objects) {
      if (obj.azimuth == null || obj.altitude == null) continue;

      final projected = CoordinateConverter.azAltToStereographic(
        azimuth: obj.azimuth!,
        altitude: obj.altitude!,
        centerAz: centerAzimuth,
        centerAlt: centerAltitude,
        scale: 300 * zoomLevel,
      );

      if (projected != null) {
        final pos = Offset(
          center.dx + projected['x']!,
          center.dy - projected['y']!,
        );

        _drawObject(canvas, obj, pos);

        // Draw selection indicator
        if (selectedObject?.id == obj.id) {
          _drawSelection(canvas, pos, obj.brightnessScale * 3);
        }
      }
    }
  }

  void _drawHorizon(Canvas canvas, Offset center, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawCircle(center, size.width * 0.4, paint);
  }

  void _drawCardinalDirections(Canvas canvas, Offset center, Size size) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final directions = ['N', 'E', 'S', 'W'];
    final angles = [0.0, 90.0, 180.0, 270.0];

    for (int i = 0; i < directions.length; i++) {
      final angle = angles[i] * math.pi / 180;
      final radius = size.width * 0.42;
      final pos = Offset(
        center.dx + radius * math.sin(angle),
        center.dy - radius * math.cos(angle),
      );

      textPainter.text = TextSpan(
        text: directions[i],
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        pos - Offset(textPainter.width / 2, textPainter.height / 2),
      );
    }
  }

  void _drawConstellationLines(Canvas canvas, Offset center) {
    // Constellation lines will be drawn when constellation service is integrated
    // For now, the structure is ready for future implementation
    // Future enhancement: Load constellation JSON and draw connecting lines

    final linePaint = Paint()
      ..color = Colors.blue.withOpacity(0.3)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Placeholder: constellation lines would be drawn here using
    // CoordinateConverter.azAltToStereographic for each star in the line
  }

  void _drawObject(Canvas canvas, CelestialObject obj, Offset position) {
    if (obj.type == ObjectType.star) {
      _drawStar(canvas, obj, position);
    } else if (obj.type == ObjectType.planet) {
      _drawPlanet(canvas, obj, position);
    } else if (obj.type == ObjectType.sun) {
      _drawSun(canvas, position);
    } else if (obj.type == ObjectType.moon) {
      _drawMoon(canvas, position);
    }
  }

  void _drawStar(Canvas canvas, CelestialObject obj, Offset position) {
    final radius = obj.brightnessScale * zoomLevel;

    // Draw glow
    final glowPaint = Paint()
      ..color = obj.color.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    canvas.drawCircle(position, radius * 2, glowPaint);

    // Draw core
    final corePaint = Paint()
      ..color = obj.color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(position, radius, corePaint);

    // Draw sparkle for very bright stars
    if (obj.magnitude < 1.0) {
      _drawSparkle(canvas, position, radius * 2, obj.color);
    }
  }

  void _drawPlanet(Canvas canvas, CelestialObject obj, Offset position) {
    final radius = 6.0 * zoomLevel;

    // Draw glow
    final glowPaint = Paint()
      ..color = obj.color.withOpacity(0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawCircle(position, radius * 1.5, glowPaint);

    // Draw planet
    final planetPaint = Paint()
      ..color = obj.color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(position, radius, planetPaint);

    // Draw highlight
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      position - Offset(radius * 0.3, radius * 0.3),
      radius * 0.4,
      highlightPaint,
    );
  }

  void _drawSun(Canvas canvas, Offset position) {
    final radius = 12.0 * zoomLevel;

    // Draw outer glow
    final outerGlowPaint = Paint()
      ..color = const Color(0xFFFDB813).withOpacity(0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawCircle(position, radius * 2, outerGlowPaint);

    // Draw inner glow
    final innerGlowPaint = Paint()
      ..color = const Color(0xFFFDB813).withOpacity(0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawCircle(position, radius * 1.2, innerGlowPaint);

    // Draw sun
    final sunPaint = Paint()
      ..color = const Color(0xFFFDB813)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(position, radius, sunPaint);
  }

  void _drawMoon(Canvas canvas, Offset position) {
    final radius = 10.0 * zoomLevel;

    // Draw glow
    final glowPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    canvas.drawCircle(position, radius * 1.5, glowPaint);

    // Draw moon
    final moonPaint = Paint()
      ..color = const Color(0xFFE8E8E8)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(position, radius, moonPaint);

    // Draw craters (simple texture)
    final craterPaint = Paint()
      ..color = const Color(0xFFD0D0D0)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(position + Offset(radius * 0.3, -radius * 0.2), radius * 0.2, craterPaint);
    canvas.drawCircle(position + Offset(-radius * 0.3, radius * 0.3), radius * 0.15, craterPaint);
  }

  void _drawSparkle(Canvas canvas, Offset center, double size, Color color) {
    final paint = Paint()
      ..color = color.withOpacity(0.6)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Draw cross sparkle
    canvas.drawLine(
      center - Offset(size, 0),
      center + Offset(size, 0),
      paint,
    );
    canvas.drawLine(
      center - Offset(0, size),
      center + Offset(0, size),
      paint,
    );
  }

  void _drawSelection(Canvas canvas, Offset position, double radius) {
    final paint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(position, radius + 5, paint);
  }

  @override
  bool shouldRepaint(SkyPainter oldDelegate) {
    return oldDelegate.objects != objects ||
           oldDelegate.centerAzimuth != centerAzimuth ||
           oldDelegate.centerAltitude != centerAltitude ||
           oldDelegate.zoomLevel != zoomLevel ||
           oldDelegate.showConstellations != showConstellations ||
           oldDelegate.selectedObject != selectedObject;
  }
}
