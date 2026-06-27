import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_qq/QQ/widget/appbar.dart';
import 'package:flutter_qq/models/user_model.dart';
import 'package:flutter_qq/states/app_state.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class UserDevicePage extends StatefulWidget {
  const UserDevicePage({super.key});

  @override
  State<UserDevicePage> createState() => _UserDevicePageState();
}

class _UserDevicePageState extends State<UserDevicePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppState>(context, listen: false).refreshDevices();
    });
  }

  @override
  Widget build(BuildContext context) {
    double top = MediaQuery.of(context).padding.top;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: StudyAppBar.MyAppBar(
        "已登录设备",
        context,
        toolbarHeight: top + 20,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        textStyle: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF12B7F5),
                  Color(0xFF0A84B8),
                ],
              ),
            ),
            width: double.infinity,
            height: double.infinity,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Consumer<AppState>(
                builder: (context, appState, child) {
                  final devices = appState.devices;
                  final onlineDevices =
                      devices.where((d) => d.isOnline).toList();
                  final currentUser = appState.currentUser;

                  return Column(
                    children: [
                      const SizedBox(height: 20),
                      _buildUserInfo(currentUser),
                      const SizedBox(height: 24),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.85),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 0.5,
                                ),
                              ),
                              child: onlineDevices.isEmpty
                                  ? _buildEmptyState()
                                  : ListView.separated(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      itemCount: onlineDevices.length,
                                      separatorBuilder: (context, index) =>
                                          Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Divider(
                                          thickness: 0.3,
                                          height: 1,
                                          color:
                                              Colors.grey.withOpacity(0.2),
                                        ),
                                      ),
                                      itemBuilder: (context, index) {
                                        return _buildDeviceItem(
                                            onlineDevices[index], appState);
                                      },
                                    ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo(currentUser) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipOval(
            child: currentUser?.avatar != null &&
                    currentUser!.avatar.isNotEmpty
                ? Image.network(
                    currentUser.avatar,
                    fit: BoxFit.cover,
                    height: 72,
                    width: 72,
                    alignment: Alignment.topCenter,
                  )
                : Image.asset(
                    "assets/images/bit7.jpg",
                    fit: BoxFit.cover,
                    height: 72,
                    width: 72,
                    alignment: Alignment.topCenter,
                  ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          currentUser?.nickname ?? "用户",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/svg/desktop 1.svg",
            width: 64,
            color: Colors.white.withOpacity(0.6),
          ),
          const SizedBox(height: 16),
          const Text(
            "暂无在线设备",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceItem(UserDevice device, AppState appState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF34C759).withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Icon(
                _getDeviceIcon(device.deviceType),
                color: const Color(0xFF34C759),
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getDeviceTitle(device.deviceType),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  device.deviceName.isNotEmpty
                      ? device.deviceName
                      : getDeviceTypeName(device.deviceType),
                  style: const TextStyle(
                    color: Color(0xFF8A8A8E),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _showKickDialog(device, appState),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFF3B30).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "退出登录",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFFF3B30),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getDeviceIcon(int deviceType) {
    switch (deviceType) {
      case deviceTypeAndroid:
        return Icons.phone_android;
      case deviceTypeIOS:
        return Icons.phone_iphone;
      case deviceTypeWindows:
        return Icons.desktop_windows;
      case deviceTypeMac:
        return Icons.laptop_mac;
      case deviceTypeLinux:
        return Icons.laptop;
      case deviceTypeWeb:
        return Icons.language;
      default:
        return Icons.devices;
    }
  }

  String _getDeviceTitle(int deviceType) {
    switch (deviceType) {
      case deviceTypeAndroid:
        return "QQ Android版";
      case deviceTypeIOS:
        return "QQ iOS版";
      case deviceTypeWindows:
        return "QQ Windows版";
      case deviceTypeMac:
        return "QQ Mac版";
      case deviceTypeLinux:
        return "QQ Linux版";
      case deviceTypeWeb:
        return "QQ网页版";
      default:
        return "QQ 未知设备";
    }
  }

  void _showKickDialog(UserDevice device, AppState appState) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "退出登录",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            "确定要退出 ${_getDeviceTitle(device.deviceType)} 吗？",
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF8A8A8E),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "取消",
                style: TextStyle(
                  color: Color(0xFF8A8A8E),
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await appState.kickDevice(device.id);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("已退出登录"),
                      backgroundColor: Color(0xFF34C759),
                    ),
                  );
                }
              },
              child: const Text(
                "确定",
                style: TextStyle(
                  color: Color(0xFFFF3B30),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
