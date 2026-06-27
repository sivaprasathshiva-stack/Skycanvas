import 'dart:async';
import 'package:screen_retriever/screen_retriever.dart';
import 'package:window_manager/window_manager.dart';

/// Service for managing displays and HDMI output
class DisplayService {
  List<Display> _displays = [];
  Display? _selectedDisplay;

  /// Get all available displays
  Future<List<Display>> getDisplays() async {
    try {
      _displays = await screenRetriever.getAllDisplays();
      return _displays;
    } catch (e) {
      print('Error getting displays: $e');
      return [];
    }
  }

  /// Get primary display
  Future<Display?> getPrimaryDisplay() async {
    try {
      return await screenRetriever.getPrimaryDisplay();
    } catch (e) {
      print('Error getting primary display: $e');
      return null;
    }
  }

  /// Select display for projection
  void selectDisplay(Display display) {
    _selectedDisplay = display;
  }

  /// Get currently selected display
  Display? get selectedDisplay => _selectedDisplay;

  /// Check if multiple displays are available
  Future<bool> hasMultipleDisplays() async {
    final displays = await getDisplays();
    return displays.length > 1;
  }

  /// Start fullscreen projection on selected display
  Future<void> startProjection() async {
    if (_selectedDisplay == null) {
      throw Exception('No display selected');
    }

    try {
      // Move window to selected display
      await windowManager.setPosition(
        Offset(
          _selectedDisplay!.visiblePosition!.dx,
          _selectedDisplay!.visiblePosition!.dy,
        ),
      );

      // Set fullscreen
      await windowManager.setFullScreen(true);
    } catch (e) {
      print('Error starting projection: $e');
      rethrow;
    }
  }

  /// Stop projection and return to windowed mode
  Future<void> stopProjection() async {
    try {
      await windowManager.setFullScreen(false);

      // Return to primary display
      final primary = await getPrimaryDisplay();
      if (primary != null) {
        await windowManager.setPosition(
          Offset(
            primary.visiblePosition!.dx + 100,
            primary.visiblePosition!.dy + 100,
          ),
        );
      }
    } catch (e) {
      print('Error stopping projection: $e');
      rethrow;
    }
  }

  /// Get display info string
  String getDisplayInfo(Display display) {
    final size = display.size;
    final scaleFactor = display.scaleFactor ?? 1.0;
    return '${size.width.toInt()}x${size.height.toInt()} @ ${scaleFactor}x';
  }
}
