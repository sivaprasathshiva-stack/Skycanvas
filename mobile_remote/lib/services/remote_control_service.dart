import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Service to control desktop app via WebSocket
class RemoteControlService {
  WebSocketChannel? _channel;
  String? _connectedDevice;
  final _statusController = StreamController<ConnectionStatus>.broadcast();

  /// Connect to desktop app
  Future<bool> connect(String url) async {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      _connectedDevice = url;
      _statusController.add(ConnectionStatus.connected);

      // Listen for responses
      _channel!.stream.listen(
        (message) {
          _handleMessage(message);
        },
        onError: (error) {
          print('WebSocket error: $error');
          _statusController.add(ConnectionStatus.error);
        },
        onDone: () {
          _statusController.add(ConnectionStatus.disconnected);
        },
      );

      return true;
    } catch (e) {
      print('Error connecting: $e');
      _statusController.add(ConnectionStatus.error);
      return false;
    }
  }

  /// Disconnect from desktop app
  Future<void> disconnect() async {
    await _channel?.sink.close();
    _channel = null;
    _connectedDevice = null;
    _statusController.add(ConnectionStatus.disconnected);
  }

  /// Send command to desktop app
  void sendCommand(String command, Map<String, dynamic> params) {
    if (_channel == null) {
      throw Exception('Not connected');
    }

    final message = json.encode({
      'command': command,
      'params': params,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });

    _channel!.sink.add(message);
  }

  /// Set date and time
  void setDateTime(DateTime dateTime) {
    sendCommand('setDateTime', {
      'year': dateTime.year,
      'month': dateTime.month,
      'day': dateTime.day,
      'hour': dateTime.hour,
      'minute': dateTime.minute,
    });
  }

  /// Set location
  void setLocation(double latitude, double longitude) {
    sendCommand('setLocation', {
      'latitude': latitude,
      'longitude': longitude,
    });
  }

  /// Toggle play/pause
  void togglePlayPause() {
    sendCommand('togglePlayPause', {});
  }

  /// Set time speed
  void setTimeSpeed(double speed) {
    sendCommand('setTimeSpeed', {'speed': speed});
  }

  /// Zoom in/out
  void zoom(double delta) {
    sendCommand('zoom', {'delta': delta});
  }

  /// Pan sky
  void pan(double deltaX, double deltaY) {
    sendCommand('pan', {
      'deltaX': deltaX,
      'deltaY': deltaY,
    });
  }

  /// Toggle constellations
  void toggleConstellations() {
    sendCommand('toggleConstellations', {});
  }

  /// Search for object
  void searchObject(String name) {
    sendCommand('searchObject', {'name': name});
  }

  /// Reset to current time
  void resetTime() {
    sendCommand('resetTime', {});
  }

  /// Handle incoming messages
  void _handleMessage(dynamic message) {
    try {
      final data = json.decode(message as String);
      print('Received: $data');
      // Handle status updates, etc.
    } catch (e) {
      print('Error parsing message: $e');
    }
  }

  /// Get connection status stream
  Stream<ConnectionStatus> get statusStream => _statusController.stream;

  /// Check if connected
  bool get isConnected => _channel != null;

  /// Get connected device
  String? get connectedDevice => _connectedDevice;

  /// Dispose
  void dispose() {
    _channel?.sink.close();
    _statusController.close();
  }
}

/// Connection status enum
enum ConnectionStatus {
  disconnected,
  connecting,
  connected,
  error,
}
