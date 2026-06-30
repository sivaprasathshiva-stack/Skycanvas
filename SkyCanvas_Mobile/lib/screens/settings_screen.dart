import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/settings_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: Consumer<SettingsService>(
        builder: (context, settings, _) {
          return ListView(
            children: [
              _buildSectionHeader('Display'),
              SwitchListTile(
                title: const Text('Night Mode (Red Tint)', style: TextStyle(color: Colors.white)),
                subtitle: const Text(
                  'Preserves night vision with red overlay',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
                value: settings.isNightMode,
                onChanged: (value) => settings.setNightMode(value),
                secondary: Icon(
                  settings.isNightMode ? Icons.nightlight : Icons.nightlight_outlined,
                  color: settings.isNightMode ? Colors.red : Colors.white,
                ),
              ),
              const Divider(color: Colors.white24),
              _buildSectionHeader('Sky View'),
              SwitchListTile(
                title: const Text('Show Constellations', style: TextStyle(color: Colors.white)),
                subtitle: const Text(
                  'Display constellation lines and patterns',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
                value: settings.showConstellations,
                onChanged: (value) => settings.setShowConstellations(value),
                secondary: const Icon(Icons.connect_without_contact, color: Colors.white),
              ),
              SwitchListTile(
                title: const Text('Show Constellation Names', style: TextStyle(color: Colors.white)),
                subtitle: const Text(
                  'Label constellations on sky map',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
                value: settings.showConstellationNames,
                onChanged: settings.showConstellations
                    ? (value) => settings.setShowConstellationNames(value)
                    : null,
                secondary: const Icon(Icons.label, color: Colors.white),
              ),
              SwitchListTile(
                title: const Text('Show Planets', style: TextStyle(color: Colors.white)),
                subtitle: const Text(
                  'Display planets in the night sky',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
                value: settings.showPlanets,
                onChanged: (value) => settings.setShowPlanets(value),
                secondary: const Icon(Icons.public, color: Colors.white),
              ),
              const Divider(color: Colors.white24),
              _buildSectionHeader('Star Visibility'),
              ListTile(
                leading: const Icon(Icons.brightness_6, color: Colors.white),
                title: const Text('Magnitude Limit', style: TextStyle(color: Colors.white)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      'Show stars up to magnitude ${settings.magnitudeLimit.toStringAsFixed(1)}',
                      style: const TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                    Slider(
                      value: settings.magnitudeLimit,
                      min: 1.0,
                      max: 6.0,
                      divisions: 50,
                      label: settings.magnitudeLimit.toStringAsFixed(1),
                      onChanged: (value) => settings.setMagnitudeLimit(value),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Fewer stars', style: TextStyle(color: Colors.white54, fontSize: 10)),
                          Text('More stars', style: TextStyle(color: Colors.white54, fontSize: 10)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.white24),
              _buildSectionHeader('Location'),
              SwitchListTile(
                title: const Text('Auto-detect Location', style: TextStyle(color: Colors.white)),
                subtitle: const Text(
                  'Use GPS to automatically set your location',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
                value: settings.autoLocation,
                onChanged: (value) => settings.setAutoLocation(value),
                secondary: const Icon(Icons.my_location, color: Colors.white),
              ),
              const Divider(color: Colors.white24),
              _buildSectionHeader('Experience'),
              SwitchListTile(
                title: const Text('Beginner Mode', style: TextStyle(color: Colors.white)),
                subtitle: const Text(
                  'Show helpful tooltips and simplified interface',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
                value: settings.beginnerMode,
                onChanged: (value) => settings.setBeginnerMode(value),
                secondary: const Icon(Icons.school, color: Colors.white),
              ),
              const Divider(color: Colors.white24),
              _buildSectionHeader('About'),
              ListTile(
                leading: const Icon(Icons.info, color: Colors.white),
                title: const Text('App Version', style: TextStyle(color: Colors.white)),
                trailing: const Text('1.0.0', style: TextStyle(color: Colors.white54)),
              ),
              ListTile(
                leading: const Icon(Icons.star_rate, color: Colors.white),
                title: const Text('Rate Us', style: TextStyle(color: Colors.white)),
                trailing: const Icon(Icons.chevron_right, color: Colors.white54),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Opening app store...'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  // Launch app store URL (implement with url_launcher package)
                  // Android: market://details?id=com.skycanvas.mobile
                  // iOS: https://apps.apple.com/app/id<APP_ID>
                },
              ),
              ListTile(
                leading: const Icon(Icons.share, color: Colors.white),
                title: const Text('Share App', style: TextStyle(color: Colors.white)),
                trailing: const Icon(Icons.chevron_right, color: Colors.white54),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Share SkyCanvas with friends!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  // Implement share with share_plus package
                  // Share.share('Check out SkyCanvas - Your Pocket Planetarium!');
                },
              ),
              const Divider(color: Colors.white24),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: const Color(0xFF0F172A),
                        title: const Text('Reset Settings', style: TextStyle(color: Colors.white)),
                        content: const Text(
                          'Are you sure you want to reset all settings to default values?',
                          style: TextStyle(color: Colors.white70),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Reset'),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      await settings.resetToDefaults();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Settings reset to defaults')),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.restore),
                  label: const Text('Reset to Defaults'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.withOpacity(0.2),
                    foregroundColor: Colors.red,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Colors.blue,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
