import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// WebSocket server for mobile remote control
class WebSocketServer {
  HttpServer? _server;
  final List<WebSocket> _clients = [];
  final _commandController = StreamController<RemoteCommand>.broadcast();

  static const int defaultPort = 8765;

  /// Start the WebSocket server
  Future<void> start({int port = defaultPort}) async {
    try {
      _server = await HttpServer.bind(InternetAddress.anyIPv4, port);
      print('WebSocket server started on port $port');

      _server!.listen((HttpRequest request) {
        if (request.uri.path == '/skycanvas') {
          WebSocketTransformer.upgrade(request).then((WebSocket socket) {
            _handleClient(socket);
          });
        } else {
          request.response
            ..statusCode = HttpStatus.notFound
            ..close();
        }
      });
    } catch (e) {
      print('Error starting WebSocket server: $e');
      rethrow;
    }
  }

  /// Handle new client connection
  void _handleClient(WebSocket socket) {
    _clients.add(socket);
    print('Client connected. Total clients: ${_clients.length}');

    socket.listen(
      (message) {
        _handleMessage(socket, message);
      },
      onDone: () {
        _clients.remove(socket);
        print('Client disconnected. Total clients: ${_clients.length}');
      },
      onError: (error) {
        print('Client error: $error');
        _clients.remove(socket);
      },
    );

    // Send welcome message
    _sendToClient(socket, {
      'type': 'welcome',
      'message': 'Connected to SkyCanvas',
      'version': '0.1.0',
    });
  }

  /// Handle incoming message from client
  void _handleMessage(WebSocket socket, dynamic message) {
    try {
      final data = json.decode(message as String) as Map<String, dynamic>;
      final command = data['command'] as String;
      final params = data['params'] as Map<String, dynamic>;

      print('Received command: $command with params: $params');

      _commandController.add(RemoteCommand(
        command: command,
        params: params,
      ));

      // Send acknowledgment
      _sendToClient(socket, {
        'type': 'ack',
        'command': command,
      });
    } catch (e) {
      print('Error handling message: $e');
    }
  }

  /// Send message to specific client
  void _sendToClient(WebSocket socket, Map<String, dynamic> data) {
    try {
      socket.add(json.encode(data));
    } catch (e) {
      print('Error sending to client: $e');
    }
  }

  /// Broadcast message to all clients
  void broadcast(Map<String, dynamic> data) {
    final message = json.encode(data);
    for (final client in _clients) {
      try {
        client.add(message);
      } catch (e) {
        print('Error broadcasting to client: $e');
      }
    }
  }

  /// Get command stream
  Stream<RemoteCommand> get commandStream => _commandController.stream;

  /// Get number of connected clients
  int get clientCount => _clients.length;

  /// Stop the server
  Future<void> stop() async {
    for (final client in _clients) {
      await client.close();
    }
    _clients.clear();
    await _server?.close();
    _server = null;
    print('WebSocket server stopped');
  }
}

/// Represents a remote control command
class RemoteCommand {
  final String command;
  final Map<String, dynamic> params;

  RemoteCommand({
    required this.command,
    required this.params,
  });
}
