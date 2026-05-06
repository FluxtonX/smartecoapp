import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:flutter/foundation.dart';
import 'dart:async';

class TrackingSocketService {
  static final TrackingSocketService _instance = TrackingSocketService._internal();
  factory TrackingSocketService() => _instance;
  TrackingSocketService._internal();

  io.Socket? _socket;
  final String _socketUrl = 'http://10.0.2.2:3000/tracking'; // Adjust for production

  // Stream controllers for different events
  final _locationUpdatesController = StreamController<Map<String, dynamic>>.broadcast();
  final _statusUpdatesController = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get locationUpdates => _locationUpdatesController.stream;
  Stream<Map<String, dynamic>> get statusUpdates => _statusUpdatesController.stream;

  bool get isConnected => _socket?.connected ?? false;

  void connect(String token) {
    if (isConnected) return;

    final url = kIsWeb ? 'http://localhost:3000/tracking' : _socketUrl;

    _socket = io.io(url, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'auth': {'token': token},
    });

    _socket!.onConnect((_) {
      debugPrint('TrackingSocketService: Connected');
    });

    _socket!.onDisconnect((_) {
      debugPrint('TrackingSocketService: Disconnected');
    });

    _socket!.onConnectError((err) {
      debugPrint('TrackingSocketService: Connect Error: $err');
    });

    _socket!.onError((err) {
      debugPrint('TrackingSocketService: Error: $err');
    });

    // Listen for broadcast events
    _socket!.on('collector:location:broadcast', (data) {
      _locationUpdatesController.add(Map<String, dynamic>.from(data));
    });

    _socket!.on('pickup:status:changed', (data) {
      _statusUpdatesController.add(Map<String, dynamic>.from(data));
    });

    _socket!.connect();
  }

  void joinPickupRoom(String pickupId) {
    if (!isConnected) return;
    _socket!.emit('join:pickup', {'pickupId': pickupId});
  }

  void leavePickupRoom(String pickupId) {
    if (!isConnected) return;
    _socket!.emit('leave:pickup', {'pickupId': pickupId});
  }

  void sendLocationUpdate({
    required double latitude,
    required double longitude,
    double? heading,
    double? speed,
    String? pickupId,
  }) {
    if (!isConnected) return;
    
    final data = <String, dynamic>{
      'latitude': latitude,
      'longitude': longitude,
    };
    if (heading != null) data['heading'] = heading;
    if (speed != null) data['speed'] = speed;
    if (pickupId != null) data['pickupId'] = pickupId;

    _socket!.emit('collector:location:update', data);
  }

  void disconnect() {
    _socket?.disconnect();
    _socket = null;
  }
}
