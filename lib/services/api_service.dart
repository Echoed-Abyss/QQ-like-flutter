import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import '../models/user_model.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  Future<ApiResponse<T>> _post<T>(
    String path,
    Map<String, dynamic> body, {
    bool needAuth = true,
    T Function(dynamic)? dataParser,
  }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiVersion}$path');
    final timestamp = SignatureUtil.getTimestamp();
    final nonce = SignatureUtil.generateNonce();
    final bodyStr = json.encode(body);
    final sign = SignatureUtil.generateSignature(bodyStr, timestamp, nonce);

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'X-Timestamp': timestamp.toString(),
      'X-Nonce': nonce,
      'X-Sign': sign,
    };

    if (needAuth) {
      final token = await StorageService.getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: bodyStr,
      ).timeout(const Duration(seconds: 15));

      final jsonData = json.decode(response.body);
      return ApiResponse<T>.fromJson(jsonData, dataParser);
    } catch (e) {
      return ApiResponse<T>(
        code: -1,
        message: '网络请求失败: $e',
        time: 0,
      );
    }
  }

  Future<ApiResponse<T>> _get<T>(
    String path, {
    Map<String, dynamic>? query,
    bool needAuth = true,
    T Function(dynamic)? dataParser,
  }) async {
    String queryString = '';
    if (query != null && query.isNotEmpty) {
      queryString = '?' +
          query.entries
              .map((e) =>
                  '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString())}')
              .join('&');
    }

    final url =
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiVersion}$path$queryString');
    final timestamp = SignatureUtil.getTimestamp();
    final nonce = SignatureUtil.generateNonce();
    final sign = SignatureUtil.generateSignature('', timestamp, nonce);

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'X-Timestamp': timestamp.toString(),
      'X-Nonce': nonce,
      'X-Sign': sign,
    };

    if (needAuth) {
      final token = await StorageService.getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    try {
      final response = await http.get(
        url,
        headers: headers,
      ).timeout(const Duration(seconds: 15));

      final jsonData = json.decode(response.body);
      return ApiResponse<T>.fromJson(jsonData, dataParser);
    } catch (e) {
      return ApiResponse<T>(
        code: -1,
        message: '网络请求失败: $e',
        time: 0,
      );
    }
  }

  Future<ApiResponse<UserModel>> register(
      String username, String password, String nickname) async {
    return _post<UserModel>(
      '/auth/register',
      {
        'username': username,
        'password': password,
        'nickname': nickname,
      },
      needAuth: false,
      dataParser: (data) => UserModel.fromJson(data),
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> login(
    String account,
    String password, {
    int deviceType = deviceTypeAndroid,
    String deviceName = '',
    String deviceModel = '',
  }) async {
    return _post<Map<String, dynamic>>(
      '/auth/login',
      {
        'account': account,
        'password': password,
        'device_type': deviceType,
        'device_name': deviceName,
        'device_model': deviceModel,
      },
      needAuth: false,
      dataParser: (data) => data as Map<String, dynamic>,
    );
  }

  Future<ApiResponse> logout() async {
    return _post(
      '/auth/logout',
      {},
      dataParser: null,
    );
  }

  Future<ApiResponse<UserInfoResponse>> getUserInfo() async {
    return _get<UserInfoResponse>(
      '/user/info',
      dataParser: (data) => UserInfoResponse.fromJson(data),
    );
  }

  Future<ApiResponse<UserModel>> getUserProfile(int userId) async {
    return _get<UserModel>(
      '/user/profile/$userId',
      dataParser: (data) => UserModel.fromJson(data),
    );
  }

  Future<ApiResponse> updateOnlineStatus(int status) async {
    return _post(
      '/user/status',
      {'status': status},
      dataParser: null,
    );
  }

  Future<ApiResponse<List<UserDevice>>> getDevices() async {
    return _get<List<UserDevice>>(
      '/user/devices',
      dataParser: (data) {
        List list = data as List;
        return list.map((e) => UserDevice.fromJson(e)).toList();
      },
    );
  }

  Future<ApiResponse> kickDevice(int deviceId) async {
    return _get(
      '/user/device/$deviceId',
      dataParser: null,
    );
  }

  Future<ApiResponse<MessageModel>> sendMessage({
    required int sessionType,
    required int sessionId,
    required int msgType,
    String content = '',
    String mediaUrl = '',
    String fileName = '',
  }) async {
    return _post<MessageModel>(
      '/message/send',
      {
        'session_type': sessionType,
        'session_id': sessionId,
        'msg_type': msgType,
        'content': content,
        'media_url': mediaUrl,
        'file_name': fileName,
      },
      dataParser: (data) => MessageModel.fromJson(data),
    );
  }

  Future<ApiResponse> recallMessage(int msgId) async {
    return _post(
      '/message/$msgId/recall',
      {},
      dataParser: null,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> getMessageList({
    required int sessionType,
    required int sessionId,
    int page = 1,
    int pageSize = 20,
  }) async {
    return _get<Map<String, dynamic>>(
      '/message/list',
      query: {
        'session_type': sessionType,
        'session_id': sessionId,
        'page': page,
        'page_size': pageSize,
      },
      dataParser: (data) => data as Map<String, dynamic>,
    );
  }

  Future<ApiResponse> addFavorite(int msgId) async {
    return _post(
      '/message/favorite',
      {'msg_id': msgId},
      dataParser: null,
    );
  }

  Future<ApiResponse> removeFavorite(int favoriteId) async {
    return _get(
      '/message/favorite/$favoriteId',
      dataParser: null,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> getFavorites({
    int page = 1,
    int pageSize = 20,
  }) async {
    return _get<Map<String, dynamic>>(
      '/message/favorites',
      query: {'page': page, 'page_size': pageSize},
      dataParser: (data) => data as Map<String, dynamic>,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> getGroupInfo(int groupId) async {
    return _get<Map<String, dynamic>>(
      '/group/$groupId',
      dataParser: (data) => data as Map<String, dynamic>,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> createGroup(
      String name, String description) async {
    return _post<Map<String, dynamic>>(
      '/group/create',
      {'name': name, 'description': description},
      dataParser: (data) => data as Map<String, dynamic>,
    );
  }

  Future<ApiResponse> joinGroup(String groupNumber, String message) async {
    return _post(
      '/group/join',
      {'group_number': groupNumber, 'message': message},
      dataParser: null,
    );
  }

  Future<ApiResponse> leaveGroup(int groupId) async {
    return _get(
      '/group/$groupId/leave',
      dataParser: null,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> getUserQRCode() async {
    return _get<Map<String, dynamic>>(
      '/qrcode/user',
      dataParser: (data) => data as Map<String, dynamic>,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> getGroupQRCode(int groupId) async {
    return _get<Map<String, dynamic>>(
      '/qrcode/group/$groupId',
      dataParser: (data) => data as Map<String, dynamic>,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> parseQRCode(String content) async {
    return _post<Map<String, dynamic>>(
      '/qrcode/parse',
      {'content': content},
      dataParser: (data) => data as Map<String, dynamic>,
    );
  }
}
