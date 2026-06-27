import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/astronomy_service.dart';
import '../services/settings_service.dart';
import '../services/location_service.dart';
import '../widgets/sky_canvas.dart';
import '../models/celestial_object.dart';
import 'settings_screen.dart';
import 'search_screen.dart';

class SkyMapScreen extends StatefulWidget {
  const SkyMapScreen({super.key});

  @override
  State<SkyMapScreen> createState() => _SkyMapScreenState();
}

class _SkyMapScreenState extends State<SkyMapScreen> {
  bool _showControls = true;
  CelestialObject? _selectedObject;
  Offset? _lastPanPosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer3<AstronomyService, SettingsService, LocationService>(
        builder: (context, astronomy, settings, location, child) {
          return Stack(
            children: [
              // Sky canvas
              GestureDetector(
                onScaleStart: (details) {
                  _lastPanPosition = details.focalPoint;
                },
                onScaleUpdate: (details) {
                  if (_lastPanPosition != null) {
                    final delta = details.focalPoint - _lastPanPosition!;
                    astronomy.pan(-delta.dx * 0.5, delta.dy * 0.5);
                    _lastPanPosition = details.focalPoint;
                  }

                  // Handle zoom
                  if (details.scale != 1.0) {
                    astronomy.setZoom(astronomy.zoomLevel * details.scale);
                  }
                },
                onScaleEnd: (details) {
                  _lastPanPosition = null;
                },
                child: SkyCanvas(
                  objects: astronomy.visibleObjects,
                  centerAzimuth: astronomy.centerAzimuth,
                  centerAltitude: astronomy.centerAltitude,
                  zoomLevel: astronomy.zoomLevel,
                  showConstellations: settings.showConstellations,
                  onObjectTap: (obj) {
                    setState(() => _selectedObject = obj);
                    _showObjectDetails(obj);
                  },
                ),
              ),

              // Top bar
              if (_showControls)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: _buildTopBar(context, astronomy, settings, location),
                ),

              // Bottom controls
              if (_showControls)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _buildBottomControls(context, astronomy),
                ),

              // Toggle controls button
              Positioned(
                top: MediaQuery.of(context).padding.top + 16,
                right: 16,
                child: IconButton(
                  icon: Icon(
                    _showControls ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() => _showControls = !_showControls);
                  },
                ),
              ),

              // Object count badge
              Positioned(
                top: MediaQuery.of(context).padding.top + 70,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.blue, width: 1),
                  ),
                  child: Text(
                    '${astronomy.visibleObjects.length} objects',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTopBar(
    BuildContext context,
    AstronomyService astronomy,
    SettingsService settings,
    LocationService location,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.8),
            Colors.transparent,
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  // Menu button
                  IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: () => _showMenu(context),
                  ),
                  const Spacer(),
                  // Search button
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.white),
                    onPressed: () => _showSearch(context),
                  ),
                  // Night mode toggle
                  IconButton(
                    icon: Icon(
                      settings.isNightMode ? Icons.nightlight : Icons.nightlight_outlined,
                      color: settings.isNightMode ? Colors.red : Colors.white,
                    ),
                    onPressed: () => settings.toggleNightMode(),
                  ),
                  // Settings
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingsScreen()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Location and time info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 16, color: Colors.blue),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            location.currentLocation?.displayName ?? 'Unknown',
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 16, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('MMM dd, yyyy  hh:mm a').format(astronomy.currentDateTime),
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomControls(BuildContext context, AstronomyService astronomy) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withOpacity(0.8),
            Colors.transparent,
          ],
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Zoom controls
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, color: Colors.white),
                    onPressed: () => astronomy.setZoom(astronomy.zoomLevel - 0.2),
                  ),
                  Text(
                    '${(astronomy.zoomLevel * 100).toInt()}%',
                    style: const TextStyle(color: Colors.white),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: () => astronomy.setZoom(astronomy.zoomLevel + 0.2),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    onPressed: () => astronomy.resetView(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Quick action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildQuickAction(
                    icon: Icons.wb_sunny,
                    label: 'Sun',
                    onTap: () => _findAndCenter(astronomy, 'Sun'),
                  ),
                  _buildQuickAction(
                    icon: Icons.nightlight,
                    label: 'Moon',
                    onTap: () => _findAndCenter(astronomy, 'Moon'),
                  ),
                  _buildQuickAction(
                    icon: Icons.lens,
                    label: 'Jupiter',
                    onTap: () => _findAndCenter(astronomy, 'Jupiter'),
                  ),
                  _buildQuickAction(
                    icon: Icons.star,
                    label: 'Polaris',
                    onTap: () => _findAndCenter(astronomy, 'Polaris'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.blue, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.white),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  void _findAndCenter(AstronomyService astronomy, String objectName) {
    final obj = astronomy.findObject(objectName);
    if (obj != null) {
      astronomy.centerOnObject(obj);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Centered on $objectName')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$objectName not visible')),
      );
    }
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F172A),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.access_time, color: Colors.white),
              title: const Text('Change Date/Time', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _showDateTimePicker(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_on, color: Colors.white),
              title: const Text('Change Location', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _showLocationPicker(context);
              },
            ),
            Consumer<SettingsService>(
              builder: (context, settings, _) => SwitchListTile(
                secondary: const Icon(Icons.connect_without_contact, color: Colors.white),
                title: const Text('Show Constellations', style: TextStyle(color: Colors.white)),
                value: settings.showConstellations,
                onChanged: (value) => settings.setShowConstellations(value),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info, color: Colors.white),
              title: const Text('About', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _showAbout(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSearch(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SearchScreen()),
    );
  }

  void _showDateTimePicker(BuildContext context) async {
    final astronomy = Provider.of<AstronomyService>(context, listen: false);

    final date = await showDatePicker(
      context: context,
      initialDate: astronomy.currentDateTime,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(astronomy.currentDateTime),
      );

      if (time != null) {
        final newDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
        astronomy.setDateTime(newDateTime);
      }
    }
  }

  void _showLocationPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F172A),
      builder: (context) => Consumer<LocationService>(
        builder: (context, location, _) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Select Location',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.my_location, color: Colors.blue),
                title: const Text('Use Current Location', style: TextStyle(color: Colors.white)),
                onTap: () async {
                  await location.getCurrentLocation();
                  if (mounted) {
                    final astronomy = Provider.of<AstronomyService>(context, listen: false);
                    if (location.currentLocation != null) {
                      astronomy.setLocation(location.currentLocation!);
                    }
                    Navigator.pop(context);
                  }
                },
              ),
              const Divider(color: Colors.white24),
              ...location.getPresetLocations().map((loc) => ListTile(
                leading: const Icon(Icons.location_city, color: Colors.white),
                title: Text(loc.displayName, style: const TextStyle(color: Colors.white)),
                onTap: () {
                  final astronomy = Provider.of<AstronomyService>(context, listen: false);
                  location.setLocation(loc);
                  astronomy.setLocation(loc);
                  Navigator.pop(context);
                },
              )),
            ],
          ),
        ),
      ),
    );
  }

  void _showObjectDetails(CelestialObject obj) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F172A),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: obj.color,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: obj.color.withOpacity(0.5),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      obj.displayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                obj.typeString,
                style: TextStyle(
                  color: Colors.blue.shade300,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              if (obj.description != null) ...[
                Text(
                  obj.description!,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 16),
              ],
              _buildDetailRow('Magnitude', obj.magnitude.toStringAsFixed(2)),
              if (obj.distance != null)
                _buildDetailRow('Distance', '${obj.distance!.toStringAsFixed(1)} light-years'),
              if (obj.constellation != null)
                _buildDetailRow('Constellation', obj.constellation!),
              if (obj.spectralType != null)
                _buildDetailRow('Spectral Type', obj.spectralType!),
              if (obj.azimuth != null)
                _buildDetailRow('Azimuth', '${obj.azimuth!.toStringAsFixed(1)}°'),
              if (obj.altitude != null)
                _buildDetailRow('Altitude', '${obj.altitude!.toStringAsFixed(1)}°'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'SkyCanvas',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 60,
        height: 60,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [Colors.blue, Colors.black],
          ),
        ),
        child: const Icon(Icons.nightlight_round, color: Colors.white),
      ),
      children: [
        const Text(
          'Your pocket planetarium for exploring the night sky. '
          'Featuring accurate star positions, planet tracking, and constellation overlays.',
        ),
      ],
    );
  }
}
