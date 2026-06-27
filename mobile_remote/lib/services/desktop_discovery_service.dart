import 'dart:async';
import 'package:multicast_dns/multicast_dns.dart';

/// Service to discover SkyCanvas desktop app on local network
class DesktopDiscoveryService {
  final MDnsClient _mdns = MDnsClient();
  final List<DesktopDevice> _devices = [];
  bool _isScanning = false;

  static const String serviceType = '_skycanvas._tcp';

  /// Start scanning for desktop apps
  Future<void> startScanning() async {
    if (_isScanning) return;

    _isScanning = true;
    _devices.clear();

    try {
      await _mdns.start();

      // Look for SkyCanvas services
      await for (final PtrResourceRecord ptr in _mdns.lookup<PtrResourceRecord>(
        ResourceRecordQuery.serverPointer(serviceType),
      )) {
        // Get service details
        await for (final SrvResourceRecord srv in _mdns.lookup<SrvResourceRecord>(
          ResourceRecordQuery.service(ptr.domainName),
        )) {
          // Get address
          await for (final IPAddressResourceRecord ip in _mdns.lookup<IPAddressResourceRecord>(
            ResourceRecordQuery.addressIPv4(srv.target),
          )) {
            _devices.add(DesktopDevice(
              name: ptr.domainName,
              host: ip.address.address,
              port: srv.port,
            ));
          }
        }
      }
    } catch (e) {
      print('Error scanning for devices: $e');
    } finally {
      _isScanning = false;
    }
  }

  /// Stop scanning
  Future<void> stopScanning() async {
    _isScanning = false;
    _mdns.stop();
  }

  /// Get discovered devices
  List<DesktopDevice> get devices => List.unmodifiable(_devices);

  /// Check if scanning
  bool get isScanning => _isScanning;
}

/// Represents a SkyCanvas desktop app on the network
class DesktopDevice {
  final String name;
  final String host;
  final int port;

  DesktopDevice({
    required this.name,
    required this.host,
    required this.port,
  });

  String get connectionUrl => 'ws://$host:$port/skycanvas';

  @override
  String toString() => '$name ($host:$port)';
}
