class UserModel {
  final int id;
  final String rechNumber;
  final String username;
  final String nickname;
  final String avatar;
  final String banner;
  final String signature;
  final int level;
  final int levelExp;
  final int gender;
  final int age;
  final String constellation;
  final String location;
  final String occupation;
  final int onlineStatus;
  final String bio;
  final List<String> tags;
  final int likes;
  final int exp;
  final String lastCheckIn;

  UserModel({
    required this.id,
    required this.rechNumber,
    required this.username,
    required this.nickname,
    required this.avatar,
    required this.banner,
    required this.signature,
    required this.level,
    required this.levelExp,
    required this.gender,
    required this.age,
    required this.constellation,
    required this.location,
    required this.occupation,
    required this.onlineStatus,
    required this.bio,
    required this.tags,
    required this.likes,
    required this.exp,
    required this.lastCheckIn,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      rechNumber: json['rech_number'] ?? '',
      username: json['username'] ?? '',
      nickname: json['nickname'] ?? '',
      avatar: json['avatar'] ?? '',
      banner: json['banner'] ?? '',
      signature: json['signature'] ?? '',
      level: json['level'] ?? 1,
      levelExp: json['level_exp'] ?? 0,
      gender: json['gender'] ?? 0,
      age: json['age'] ?? 0,
      constellation: json['constellation'] ?? '',
      location: json['location'] ?? '',
      occupation: json['occupation'] ?? '',
      onlineStatus: json['online_status'] ?? 0,
      bio: json['bio'] ?? '',
      tags: (json['tags'] as List?)?.map((e) => e.toString()).toList() ?? [],
      likes: json['likes'] ?? 0,
      exp: json['exp'] ?? 0,
      lastCheckIn: json['last_check_in'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rech_number': rechNumber,
      'username': username,
      'nickname': nickname,
      'avatar': avatar,
      'banner': banner,
      'signature': signature,
      'level': level,
      'level_exp': levelExp,
      'gender': gender,
      'age': age,
      'constellation': constellation,
      'location': location,
      'occupation': occupation,
      'online_status': onlineStatus,
      'bio': bio,
      'tags': tags,
      'likes': likes,
      'exp': exp,
      'last_check_in': lastCheckIn,
    };
  }
}

class UserDevice {
  final int id;
  final int userId;
  final int deviceType;
  final String deviceName;
  final String deviceModel;
  final String ipAddress;
  final DateTime lastOnline;
  final bool isOnline;

  UserDevice({
    required this.id,
    required this.userId,
    required this.deviceType,
    required this.deviceName,
    required this.deviceModel,
    required this.ipAddress,
    required this.lastOnline,
    required this.isOnline,
  });

  factory UserDevice.fromJson(Map<String, dynamic> json) {
    return UserDevice(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      deviceType: json['device_type'] ?? 0,
      deviceName: json['device_name'] ?? '',
      deviceModel: json['device_model'] ?? '',
      ipAddress: json['ip_address'] ?? '',
      lastOnline: json['last_online'] != null
          ? DateTime.parse(json['last_online'])
          : DateTime.now(),
      isOnline: json['is_online'] ?? false,
    );
  }
}

class FriendInfo {
  final int id;
  final String rechNumber;
  final String nickname;
  final String remark;
  final String avatar;
  final String signature;
  final int onlineStatus;

  FriendInfo({
    required this.id,
    required this.rechNumber,
    required this.nickname,
    required this.remark,
    required this.avatar,
    required this.signature,
    required this.onlineStatus,
  });

  factory FriendInfo.fromJson(Map<String, dynamic> json) {
    return FriendInfo(
      id: json['id'] ?? 0,
      rechNumber: json['rech_number'] ?? '',
      nickname: json['nickname'] ?? '',
      remark: json['remark'] ?? '',
      avatar: json['avatar'] ?? '',
      signature: json['signature'] ?? '',
      onlineStatus: json['online_status'] ?? 0,
    );
  }
}

class FriendGroup {
  final int id;
  final String name;
  final int sort;
  final List<FriendInfo> friends;
  final int onlineCount;
  final int totalCount;

  FriendGroup({
    required this.id,
    required this.name,
    required this.sort,
    required this.friends,
    required this.onlineCount,
    required this.totalCount,
  });

  factory FriendGroup.fromJson(Map<String, dynamic> json) {
    var friendsList = json['friends'] as List? ?? [];
    List<FriendInfo> friends =
        friendsList.map((i) => FriendInfo.fromJson(i)).toList();

    return FriendGroup(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      sort: json['sort'] ?? 0,
      friends: friends,
      onlineCount: json['online_count'] ?? 0,
      totalCount: json['total_count'] ?? 0,
    );
  }
}

class GroupInfo {
  final int id;
  final String groupNumber;
  final String name;
  final String avatar;
  final String description;
  final int memberCount;
  final int onlineCount;
  final String lastMsg;
  final String lastMsgTime;
  final int unreadCount;

  GroupInfo({
    required this.id,
    required this.groupNumber,
    required this.name,
    required this.avatar,
    required this.description,
    required this.memberCount,
    required this.onlineCount,
    required this.lastMsg,
    required this.lastMsgTime,
    required this.unreadCount,
  });

  factory GroupInfo.fromJson(Map<String, dynamic> json) {
    return GroupInfo(
      id: json['id'] ?? 0,
      groupNumber: json['group_number'] ?? '',
      name: json['name'] ?? '',
      avatar: json['avatar'] ?? '',
      description: json['description'] ?? '',
      memberCount: json['member_count'] ?? 0,
      onlineCount: json['online_count'] ?? 0,
      lastMsg: json['last_msg'] ?? '',
      lastMsgTime: json['last_msg_time'] ?? '',
      unreadCount: json['unread_count'] ?? 0,
    );
  }
}

class MessageModel {
  final int id;
  final int sessionType;
  final int sessionId;
  final int senderId;
  final String senderName;
  final String senderAvatar;
  final int senderLevel;
  final int msgType;
  final String content;
  final String mediaUrl;
  final int mediaSize;
  final double mediaDuration;
  final String thumbUrl;
  final int width;
  final int height;
  final String fileName;
  final bool isRecalled;
  final int sendTime;

  MessageModel({
    required this.id,
    required this.sessionType,
    required this.sessionId,
    required this.senderId,
    required this.senderName,
    required this.senderAvatar,
    this.senderLevel = 1,
    required this.msgType,
    required this.content,
    required this.mediaUrl,
    required this.mediaSize,
    required this.mediaDuration,
    required this.thumbUrl,
    required this.width,
    required this.height,
    required this.fileName,
    required this.isRecalled,
    required this.sendTime,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] ?? 0,
      sessionType: json['session_type'] ?? 1,
      sessionId: json['session_id'] ?? 0,
      senderId: json['sender_id'] ?? 0,
      senderName: json['sender_name'] ?? '',
      senderAvatar: json['sender_avatar'] ?? '',
      senderLevel: json['sender_level'] ?? 1,
      msgType: json['msg_type'] ?? 1,
      content: json['content'] ?? '',
      mediaUrl: json['media_url'] ?? '',
      mediaSize: json['media_size'] ?? 0,
      mediaDuration: (json['media_duration'] ?? 0).toDouble(),
      thumbUrl: json['thumb_url'] ?? '',
      width: json['width'] ?? 0,
      height: json['height'] ?? 0,
      fileName: json['file_name'] ?? '',
      isRecalled: json['is_recalled'] ?? false,
      sendTime: json['send_time'] ?? 0,
    );
  }
}

class UserInfoResponse {
  final UserModel user;
  final List<UserDevice> devices;
  final List<FriendGroup> friendGroups;
  final List<GroupInfo> groupList;
  final List<FriendInfo> friendList;

  UserInfoResponse({
    required this.user,
    required this.devices,
    required this.friendGroups,
    required this.groupList,
    required this.friendList,
  });

  factory UserInfoResponse.fromJson(Map<String, dynamic> json) {
    var userJson = json['user'] ?? <String, dynamic>{};
    var devicesList = json['devices'] as List? ?? [];
    var groupsList = json['friend_groups'] as List? ?? [];
    var groupList = json['group_list'] as List? ?? [];
    var friendList = json['friend_list'] as List? ?? [];

    return UserInfoResponse(
      user: UserModel.fromJson(userJson),
      devices: devicesList.map((i) => UserDevice.fromJson(i)).toList(),
      friendGroups:
          groupsList.map((i) => FriendGroup.fromJson(i)).toList(),
      groupList: groupList.map((i) => GroupInfo.fromJson(i)).toList(),
      friendList: friendList.map((i) => FriendInfo.fromJson(i)).toList(),
    );
  }
}

class ApiResponse<T> {
  final int code;
  final String message;
  final T? data;
  final int time;

  ApiResponse({
    required this.code,
    required this.message,
    this.data,
    required this.time,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json, T Function(dynamic)? dataParser) {
    return ApiResponse<T>(
      code: json['code'] ?? -1,
      message: json['message'] ?? '',
      data: json['data'] != null && dataParser != null
          ? dataParser(json['data'])
          : json['data'],
      time: json['time'] ?? 0,
    );
  }

  bool get isSuccess => code == 0;
}

const int deviceTypeAndroid = 1;
const int deviceTypeIOS = 2;
const int deviceTypeWindows = 3;
const int deviceTypeMac = 4;
const int deviceTypeLinux = 5;
const int deviceTypeWeb = 6;

const int onlineStatusOnline = 0;
const int onlineStatusAway = 1;
const int onlineStatusBusy = 2;
const int onlineStatusDoNotDisturb = 3;
const int onlineStatusInvisible = 4;
const int onlineStatusOffline = 5;

const int sessionTypePrivate = 1;
const int sessionTypeGroup = 2;

const int msgTypeText = 1;
const int msgTypeImage = 2;
const int msgTypeVideo = 3;
const int msgTypeVoice = 4;
const int msgTypeFile = 5;
const int msgTypeEmoji = 6;
const int msgTypeSystem = 7;
const int msgTypeRecall = 8;
const int msgTypeAt = 9;

String getOnlineStatusText(int status) {
  switch (status) {
    case onlineStatusOnline:
      return '在线';
    case onlineStatusAway:
      return '离开';
    case onlineStatusBusy:
      return '忙碌';
    case onlineStatusDoNotDisturb:
      return '勿扰';
    case onlineStatusInvisible:
      return '隐身';
    case onlineStatusOffline:
      return '离线';
    default:
      return '未知';
  }
}

String getDeviceTypeName(int type) {
  switch (type) {
    case deviceTypeAndroid:
      return 'Android';
    case deviceTypeIOS:
      return 'iOS';
    case deviceTypeWindows:
      return 'Windows';
    case deviceTypeMac:
      return 'Mac';
    case deviceTypeLinux:
      return 'Linux';
    case deviceTypeWeb:
      return 'Web';
    default:
      return '未知';
  }
}
