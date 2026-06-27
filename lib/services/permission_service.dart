import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

class PermissionService {
  static final PermissionService _instance = PermissionService._internal();
  factory PermissionService() => _instance;
  PermissionService._internal();

  Future<bool> requestCameraPermission() async {
    try {
      final status = await ph.Permission.camera.request();
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
      final status = await ph.Permission.photos.request();
      if (status.isGranted) return true;
      final storageStatus = await ph.Permission.storage.request();
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
      final status = await ph.Permission.storage.request();
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
      final status = await ph.Permission.notification.request();
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
      final status = await ph.Permission.microphone.request();
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
        ph.Permission.camera,
        ph.Permission.photos,
        ph.Permission.notification,
        ph.Permission.microphone,
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
    return await ph.Permission.camera.isGranted;
  }

  Future<bool> isPhotosGranted() async {
    return await ph.Permission.photos.isGranted ||
        await ph.Permission.storage.isGranted;
  }

  Future<bool> isNotificationGranted() async {
    return await ph.Permission.notification.isGranted;
  }

  Future<void> openAppSettings() async {
    await ph.openAppSettings();
  }
}
