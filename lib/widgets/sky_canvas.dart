import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/celestial_object.dart';

/// Custom painter for rendering the night sky
class SkyCanvas extends CustomPainter {
  final List<CelestialObject> objects;
  final double fieldOfView; // degrees (default 120)

  SkyCanvas({
    required this.objects,
    this.fieldOfView = 120.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    // Background (black)
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.black,
    );

    // Draw each celestial object
    for (final obj in objects) {
      if (!obj.isVisible) continue;

      // Convert alt/az to screen coordinates
      final position = _altAzToScreen(
        obj.altitude,
        obj.azimuth,
        center,
        radius,
      );

      if (position == null) continue;

      // Draw object based on type
      if (obj.type == 'star') {
        _drawStar(canvas, position, obj);
      } else if (obj.type == 'moon') {
        _drawMoon(canvas, position, obj);
      } else if (obj.type == 'planet') {
        _drawPlanet(canvas, position, obj);
      }
    }
  }

  Offset? _altAzToScreen(double altitude, double azimuth, Offset center, double radius) {
    // Stereographic projection (fisheye view)
    // Altitude: 0° = horizon (edge), 90° = zenith (center)
    // Azimuth: 0° = North, increases clockwise

    if (altitude < 0) return null;

    // Convert to radians
    final altRad = altitude * math.pi / 180;
    final azRad = azimuth * math.pi / 180;

    // Distance from center (0 at zenith, radius at horizon)
    final r = radius * (1 - altitude / 90);

    // Calculate x, y (azimuth 0° = top, increases clockwise)
    final x = center.dx + r * math.sin(azRad);
    final y = center.dy - r * math.cos(azRad);

    return Offset(x, y);
  }

  void _drawStar(Canvas canvas, Offset position, CelestialObject star) {
    // Get color
    Color color = Colors.white;
    if (star.color == 'red') {
      color = Colors.red.shade300;
    } else if (star.color == 'orange') {
      color = Colors.orange.shade200;
    } else if (star.color == 'yellow') {
      color = Colors.yellow.shade100;
    } else if (star.color == 'blue') {
      color = Colors.blue.shade200;
    }

    // Draw star with glow
    final size = star.visualSize.clamp(2.0, 15.0);

    // Outer glow
    canvas.drawCircle(
      position,
      size * 1.5,
      Paint()
        ..color = color.withAlpha(50)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );

    // Star core
    canvas.drawCircle(
      position,
      size,
      Paint()..color = color,
    );
  }

  void _drawMoon(Canvas canvas, Offset position, CelestialObject moon) {
    final size = moon.visualSize;

    // Draw moon
    canvas.drawCircle(
      position,
      size,
      Paint()
        ..color = Colors.grey.shade300
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
    );

    // Draw phase shadow if not full moon
    if (moon.illumination != null && moon.illumination! < 95) {
      canvas.drawCircle(
        position,
        size,
        Paint()..color = Colors.black.withAlpha(180),
      );
    }
  }

  void _drawPlanet(Canvas canvas, Offset position, CelestialObject planet) {
    final size = planet.visualSize;

    // Planet colors
    Color color = Colors.yellow;
    if (planet.name == 'Mars') {
      color = Colors.red.shade400;
    } else if (planet.name == 'Saturn') {
      color = Colors.yellow.shade200;
    } else if (planet.name == 'Jupiter') {
      color = Colors.orange.shade200;
    } else if (planet.name == 'Venus') {
      color = Colors.yellow.shade100;
    }

    // Draw planet with glow
    canvas.drawCircle(
      position,
      size * 1.5,
      Paint()
        ..color = color.withAlpha(80)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );

    canvas.drawCircle(
      position,
      size,
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(covariant SkyCanvas oldDelegate) {
    return oldDelegate.objects != objects ||
        oldDelegate.fieldOfView != fieldOfView;
  }
}
