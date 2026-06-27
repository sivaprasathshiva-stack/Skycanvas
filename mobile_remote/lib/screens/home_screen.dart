import 'package:flutter/material.dart';
import '../services/desktop_discovery_service.dart';
import '../services/remote_control_service.dart';
import 'control_screen.dart';

class RemoteHomeScreen extends StatefulWidget {
  const RemoteHomeScreen({super.key});

  @override
  State<RemoteHomeScreen> createState() => _RemoteHomeScreenState();
}

class _RemoteHomeScreenState extends State<RemoteHomeScreen> {
  final _discoveryService = DesktopDiscoveryService();
  final _remoteService = RemoteControlService();
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _startScanning();
  }

  Future<void> _startScanning() async {
    setState(() => _isScanning = true);
    await _discoveryService.startScanning();
    setState(() => _isScanning = false);
  }

  Future<void> _connectToDevice(DesktopDevice device) async {
    final connected = await _remoteService.connect(device.connectionUrl);

    if (connected && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ControlScreen(remoteService: _remoteService),
        ),
      );
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to connect')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SkyCanvas Remote'),
      ),
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Icon(Icons.cast, size: 64, color: Colors.blue),
                const SizedBox(height: 16),
                const Text(
                  'Connect to SkyCanvas',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Make sure SkyCanvas desktop app is running',
                  style: TextStyle(color: Colors.grey.shade400),
                ),
              ],
            ),
          ),

          // Device list
          Expanded(
            child: _isScanning
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Scanning for devices...'),
                      ],
                    ),
                  )
                : _discoveryService.devices.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.devices_other,
                                size: 64, color: Colors.grey.shade600),
                            const SizedBox(height: 16),
                            const Text('No devices found'),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: _startScanning,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Scan Again'),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _discoveryService.devices.length,
                        itemBuilder: (context, index) {
                          final device = _discoveryService.devices[index];
                          return ListTile(
                            leading: const Icon(Icons.computer),
                            title: Text(device.name),
                            subtitle: Text(device.host),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => _connectToDevice(device),
                          );
                        },
                      ),
          ),

          // Manual connection
          Padding(
            padding: const EdgeInsets.all(16),
            child: OutlinedButton.icon(
              onPressed: () => _showManualConnectionDialog(),
              icon: const Icon(Icons.edit),
              label: const Text('Manual Connection'),
            ),
          ),
        ],
      ),
    );
  }

  void _showManualConnectionDialog() {
    final hostController = TextEditingController(text: '192.168.1.100');
    final portController = TextEditingController(text: '8765');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Manual Connection'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: hostController,
              decoration: const InputDecoration(labelText: 'Host/IP'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: portController,
              decoration: const InputDecoration(labelText: 'Port'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final url =
                  'ws://${hostController.text}:${portController.text}/skycanvas';
              Navigator.pop(context);
              _remoteService.connect(url).then((connected) {
                if (connected && mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ControlScreen(remoteService: _remoteService),
                    ),
                  );
                }
              });
            },
            child: const Text('Connect'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _discoveryService.stopScanning();
    _remoteService.dispose();
    super.dispose();
  }
}
