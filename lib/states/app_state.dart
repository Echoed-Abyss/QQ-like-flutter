import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../services/api_config.dart';
import '../services/tcp_service.dart';
import '../models/user_model.dart';

class AppState extends ChangeNotifier {
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal();

  bool _isLoggedIn = false;
  UserModel? _currentUser;
  List<UserDevice> _devices = [];
  List<FriendGroup> _friendGroups = [];
  List<GroupInfo> _groupList = [];
  List<FriendInfo> _friendList = [];
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoggedIn => _isLoggedIn;
  UserModel? get currentUser => _currentUser;
  List<UserDevice> get devices => _devices;
  List<FriendGroup> get friendGroups => _friendGroups;
  List<GroupInfo> get groupList => _groupList;
  List<FriendInfo> get friendList => _friendList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> login(String account, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiService().login(account, password);
      if (response.isSuccess && response.data != null) {
        final data = response.data!;
        final token = data['token'] as String?;
        if (token != null) {
          await StorageService.saveToken(token);
          await _loadUserInfo();
          _isLoggedIn = true;
          _isLoading = false;
          notifyListeners();
          TcpService().connect();
          return true;
        }
      }
      _errorMessage = response.message;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> register(String account, String password, String nickname) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiService().register(account, password, nickname);
      if (response.isSuccess) {
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _errorMessage = response.message;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> _loadUserInfo() async {
    try {
      final response = await ApiService().getUserInfo();
      if (response.isSuccess && response.data != null) {
        _currentUser = response.data!.user;
        _devices = response.data!.devices;
        _friendGroups = response.data!.friendGroups;
        _groupList = response.data!.groupList;
        _friendList = response.data!.friendList;

        await StorageService.saveUserId(_currentUser!.id);
        await StorageService.saveUsername(_currentUser!.username);
      }
    } catch (e) {
      if (kDebugMode) {
        print('加载用户信息失败: $e');
      }
    }
  }

  Future<void> refreshUserInfo() async {
    await _loadUserInfo();
    notifyListeners();
  }

  Future<void> updateOnlineStatus(int status) async {
    try {
      await ApiService().updateOnlineStatus(status);
      if (_currentUser != null) {
        _currentUser = UserModel(
          id: _currentUser!.id,
          qqNumber: _currentUser!.qqNumber,
          username: _currentUser!.username,
          nickname: _currentUser!.nickname,
          avatar: _currentUser!.avatar,
          banner: _currentUser!.banner,
          signature: _currentUser!.signature,
          level: _currentUser!.level,
          levelExp: _currentUser!.levelExp,
          gender: _currentUser!.gender,
          age: _currentUser!.age,
          constellation: _currentUser!.constellation,
          location: _currentUser!.location,
          occupation: _currentUser!.occupation,
          onlineStatus: status,
        );
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('更新状态失败: $e');
      }
    }
  }

  Future<void> refreshDevices() async {
    try {
      final response = await ApiService().getDevices();
      if (response.isSuccess && response.data != null) {
        _devices = response.data!;
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('刷新设备列表失败: $e');
      }
    }
  }

  Future<void> kickDevice(int deviceId) async {
    try {
      await ApiService().kickDevice(deviceId);
      await refreshDevices();
    } catch (e) {
      if (kDebugMode) {
        print('踢下设备失败: $e');
      }
    }
  }

  Future<void> logout() async {
    try {
      TcpService().disconnect();
      await ApiService().logout();
    } catch (e) {
      if (kDebugMode) {
        print('登出失败: $e');
      }
    }
    await StorageService.clearAll();
    _isLoggedIn = false;
    _currentUser = null;
    _devices = [];
    _friendGroups = [];
    _groupList = [];
    _friendList = [];
    notifyListeners();
  }

  Future<bool> checkLoginStatus() async {
    final token = await StorageService.getToken();
    if (token != null && token.isNotEmpty) {
      try {
        await _loadUserInfo();
        _isLoggedIn = true;
        notifyListeners();
        TcpService().connect();
        return true;
      } catch (e) {
        await StorageService.clearAll();
      }
    }
    return false;
  }
}
