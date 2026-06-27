import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'api_config.dart';
import 'notification_service.dart';
import 'permission_service.dart';
import '../models/user_model.dart';
import '../states/app_state.dart';

class TcpService {
  static final TcpService _instance = TcpService._internal();
  factory TcpService() => _instance;
  TcpService._internal();

  Socket? _socket;
  bool _isConnected = false;
  String? _deviceId;
  Timer? _heartbeatTimer;

  final StreamController<Map<String, dynamic>> _messageController =
      StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;

  final StreamController<bool> _connectionController =
      StreamController<bool>.broadcast();
  Stream<bool> get connectionStream => _connectionController.stream;

  bool get isConnected => _isConnected;

  Future<void> connect() async {
    if (_isConnected) return;

    try {
      final token = await StorageService.getToken();
      if (token == null || token.isEmpty) {
        return;
      }

      _deviceId = 'flutter_${DateTime.now().millisecondsSinceEpoch}';

      _socket = await Socket.connect(
        ApiConfig.tcpHost,
        ApiConfig.tcpPort,
        timeout: const Duration(seconds: 10),
      );

      _isConnected = true;
      _connectionController.add(true);

      _socket!.listen(
        _onData,
        onError: _onError,
        onDone: _onDone,
      );

      _sendLogin(token);
      _startHeartbeat();
    } catch (e) {
      if (kDebugMode) {
        print('TCP连接失败: $e');
      }
      _isConnected = false;
      _connectionController.add(false);
    }
  }

  void _onData(List<int> data) {
    try {
      final message = utf8.decode(data);
      final jsonData = json.decode(message);
      _messageController.add(jsonData);
      _handleMessage(jsonData);
    } catch (e) {
      if (kDebugMode) {
        print('TCP消息解析失败: $e');
      }
    }
  }

  void _handleMessage(Map<String, dynamic> data) {
    final type = data['type'];
    switch (type) {
      case 'login_success':
        if (kDebugMode) {
          print('TCP登录成功');
        }
        break;
      case 'login_fail':
        if (kDebugMode) {
          print('TCP登录失败: ${data['content']}');
        }
        disconnect();
        break;
      case 'pong':
        break;
      case 'new_message':
        _handleNewMessage(data);
        break;
      case 'recall_message':
        break;
      case 'system':
        break;
      case 'kick_device':
        if (kDebugMode) {
          print('被踢下线: ${data['content']}');
        }
        disconnect();
        AppState().logout();
        break;
      case 'friend_online':
        break;
      case 'friend_offline':
        break;
    }
  }

  void _handleNewMessage(Map<String, dynamic> data) async {
    try {
      final msgData = data['message'] ?? data;
      final senderName = msgData['sender_name'] ?? '新消息';
      final content = msgData['content'] ?? '';
      final msgType = msgData['msg_type'] ?? msgTypeText;
      final msgId = msgData['id'] ?? DateTime.now().millisecondsSinceEpoch;

      String notificationBody = content;
      switch (msgType) {
        case msgTypeImage:
          notificationBody = '[图片]';
          break;
        case msgTypeVideo:
          notificationBody = '[视频]';
          break;
        case msgTypeVoice:
          notificationBody = '[语音]';
          break;
        case msgTypeFile:
          notificationBody = '[文件]';
          break;
        case msgTypeEmoji:
          notificationBody = '[表情]';
          break;
      }

      final granted = await PermissionService().isNotificationGranted();
      if (granted) {
        await NotificationService().showMessageNotification(
          id: msgId.hashCode,
          title: senderName,
          body: notificationBody,
          payload: json.encode(msgData),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('处理新消息通知失败: $e');
      }
    }
  }

  void _onError(error) {
    if (kDebugMode) {
      print('TCP错误: $error');
    }
    _isConnected = false;
    _connectionController.add(false);
  }

  void _onDone() {
    if (kDebugMode) {
      print('TCP连接关闭');
    }
    _isConnected = false;
    _connectionController.add(false);
    _stopHeartbeat();
  }

  void _sendLogin(String token) {
    final message = {
      'type': 'login',
      'token': token,
      'device_id': _deviceId,
      'device_type': deviceTypeAndroid,
      'device_name': 'Flutter App',
    };
    _send(message);
  }

  void _send(Map<String, dynamic> message) {
    if (_socket == null || !_isConnected) return;
    try {
      final data = json.encode(message);
      _socket!.write(data);
    } catch (e) {
      if (kDebugMode) {
        print('TCP发送失败: $e');
      }
    }
  }

  void _startHeartbeat() {
    _stopHeartbeat();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (_isConnected) {
        _send({'type': 'ping'});
      }
    });
  }

  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  void disconnect() {
    _stopHeartbeat();
    _socket?.destroy();
    _socket = null;
    _isConnected = false;
    _connectionController.add(false);
  }

  void sendMessage(Map<String, dynamic> message) {
    _send(message);
  }

  void dispose() {
    disconnect();
    _messageController.close();
    _connectionController.close();
  }
}
