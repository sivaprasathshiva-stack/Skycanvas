import 'package:flutter/material.dart';
import '../services/remote_control_service.dart';

class ControlScreen extends StatefulWidget {
  final RemoteControlService remoteService;

  const ControlScreen({super.key, required this.remoteService});

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  double _timeSpeed = 1.0;
  bool _isPlaying = false;
  bool _showConstellations = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remote Control'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              widget.remoteService.disconnect();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Connection status
            _buildConnectionStatus(),
            const SizedBox(height: 24),

            // Time controls
            _buildTimeControls(),
            const SizedBox(height: 24),

            // Sky controls
            _buildSkyControls(),
            const SizedBox(height: 24),

            // View controls
            _buildViewControls(),
            const SizedBox(height: 24),

            // Quick actions
            _buildQuickActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionStatus() {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.cast_connected, color: Colors.green),
        title: const Text('Connected'),
        subtitle: Text(widget.remoteService.connectedDevice ?? 'Unknown'),
      ),
    );
  }

  Widget _buildTimeControls() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Time Controls',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Play/Pause
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.filled(
                  onPressed: () {
                    setState(() => _isPlaying = !_isPlaying);
                    widget.remoteService.togglePlayPause();
                  },
                  icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                  iconSize: 32,
                ),
                const SizedBox(width: 16),
                IconButton.outlined(
                  onPressed: () {
                    widget.remoteService.resetTime();
                  },
                  icon: const Icon(Icons.restore),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Time speed
            const Text('Speed'),
            Slider(
              value: _timeSpeed,
              min: 0.1,
              max: 1000.0,
              divisions: 100,
              label: '${_timeSpeed.toStringAsFixed(1)}x',
              onChanged: (value) {
                setState(() => _timeSpeed = value);
                widget.remoteService.setTimeSpeed(value);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkyControls() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sky View',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Pan control (virtual joystick placeholder)
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text('Drag to pan sky'),
              ),
            ),
            const SizedBox(height: 16),

            // Zoom buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.outlined(
                  onPressed: () => widget.remoteService.zoom(-0.1),
                  icon: const Icon(Icons.zoom_out),
                ),
                const SizedBox(width: 16),
                IconButton.outlined(
                  onPressed: () => widget.remoteService.zoom(0.1),
                  icon: const Icon(Icons.zoom_in),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewControls() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'View Options',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            SwitchListTile(
              title: const Text('Show Constellations'),
              value: _showConstellations,
              onChanged: (value) {
                setState(() => _showConstellations = value);
                widget.remoteService.toggleConstellations();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ActionChip(
                  label: const Text('Show Jupiter'),
                  onPressed: () => widget.remoteService.searchObject('Jupiter'),
                ),
                ActionChip(
                  label: const Text('Show Mars'),
                  onPressed: () => widget.remoteService.searchObject('Mars'),
                ),
                ActionChip(
                  label: const Text('Show Moon'),
                  onPressed: () => widget.remoteService.searchObject('Moon'),
                ),
                ActionChip(
                  label: const Text('Show Orion'),
                  onPressed: () => widget.remoteService.searchObject('Orion'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
