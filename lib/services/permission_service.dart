import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static final PermissionService _instance = PermissionService._internal();
  factory PermissionService() => _instance;
  PermissionService._internal();

  Future<bool> requestCameraPermission() async {
    try {
      final status = await Permission.camera.request();
      return status.isGranted;
    } catch (e) {
      if (kDebugMode) {
        print('请求相机权限失败: $e');
      }
      return false;
    }
  }

  Future<bool> requestPhotosPermission() async {
    try {
      final status = await Permission.photos.request();
      if (status.isGranted) return true;
      final storageStatus = await Permission.storage.request();
      return storageStatus.isGranted;
    } catch (e) {
      if (kDebugMode) {
        print('请求相册权限失败: $e');
      }
      return false;
    }
  }

  Future<bool> requestStoragePermission() async {
    try {
      final status = await Permission.storage.request();
      return status.isGranted;
    } catch (e) {
      if (kDebugMode) {
        print('请求存储权限失败: $e');
      }
      return false;
    }
  }

  Future<bool> requestNotificationPermission() async {
    try {
      final status = await Permission.notification.request();
      return status.isGranted;
    } catch (e) {
      if (kDebugMode) {
        print('请求通知权限失败: $e');
      }
      return false;
    }
  }

  Future<bool> requestMicrophonePermission() async {
    try {
      final status = await Permission.microphone.request();
      return status.isGranted;
    } catch (e) {
      if (kDebugMode) {
        print('请求麦克风权限失败: $e');
      }
      return false;
    }
  }

  Future<Map<Permission, PermissionStatus>> requestAllPermissions() async {
    try {
      final permissions = [
        Permission.camera,
        Permission.photos,
        Permission.notification,
        Permission.microphone,
      ];
      return await permissions.request();
    } catch (e) {
      if (kDebugMode) {
        print('请求所有权限失败: $e');
      }
      return {};
    }
  }

  Future<bool> isCameraGranted() async {
    return await Permission.camera.isGranted;
  }

  Future<bool> isPhotosGranted() async {
    return await Permission.photos.isGranted ||
        await Permission.storage.isGranted;
  }

  Future<bool> isNotificationGranted() async {
    return await Permission.notification.isGranted;
  }

  Future<void> openAppSettings() async {
    await openAppSettings();
  }
}
