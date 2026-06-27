import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rech/ReCh/change_password_page.dart';
import 'package:rech/ReCh/delete_account_page.dart';
import 'package:rech/ReCh/user_device_page.dart';
import 'package:rech/ReCh/widget/appbar.dart';
import 'package:rech/services/api_service.dart';
import 'package:rech/states/app_state.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _vibrateEnabled = true;
  bool _systemNotificationEnabled = true;
  bool _dndEnabled = false;

  Widget _buildGroupTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 24, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF8A8A8E),
        ),
      ),
    );
  }

  Widget _buildCard({required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildTile({
    required String title,
    String? subtitle,
    Color? titleColor,
    Widget? trailing,
    VoidCallback? onTap,
    bool showArrow = true,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      color: titleColor ?? const Color(0xFF1A1A1A),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF8A8A8E),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (trailing != null) trailing,
            if (showArrow && trailing == null)
              SvgPicture.asset(
                "assets/svg/chevronright.svg",
                height: 18,
                color: const Color(0xFFC7C7CC),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Divider(
        thickness: 0.3,
        height: 1,
        color: Colors.grey.withOpacity(0.15),
      ),
    );
  }

  Future<void> _checkUpdate() async {
    final response = await ApiService().checkUpdate();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response.isSuccess ? '已是最新版本' : response.message,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: StudyAppBar.MyAppBar(
        '设置',
        context,
        backgroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        textStyle: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1A1A1A),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFFF5F6F8),
              ),
              child: const BackButton(
                color: Color(0xFF1A1A1A),
                style: ButtonStyle(
                    padding: MaterialStatePropertyAll(EdgeInsets.zero)),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGroupTitle('账号与安全'),
            _buildCard(
              children: [
                Consumer<AppState>(
                  builder: (context, appState, child) {
                    return _buildTile(
                      title: '账号管理',
                      subtitle: appState.currentUser?.username ?? '',
                      onTap: () {
                        // TODO: multi-account management
                      },
                    );
                  },
                ),
                _buildDivider(),
                _buildTile(
                  title: '修改密码',
                  onTap: () => Get.to(const ChangePasswordPage()),
                ),
                _buildDivider(),
                _buildTile(
                  title: '登录设备管理',
                  onTap: () => Get.to(const UserDevicePage()),
                ),
                _buildDivider(),
                _buildTile(
                  title: '注销账号',
                  titleColor: const Color(0xFFFF3B30),
                  showArrow: true,
                  onTap: () => Get.to(const DeleteAccountPage()),
                ),
              ],
            ),
            _buildGroupTitle('功能'),
            _buildCard(
              children: [
                _buildTile(
                  title: '消息通知',
                  trailing: Switch(
                    value: _notificationsEnabled,
                    onChanged: (v) => setState(() => _notificationsEnabled = v),
                    activeColor: const Color(0xFF12B7F5),
                  ),
                  showArrow: false,
                ),
                if (_notificationsEnabled) ...[
                  _buildDivider(),
                  _buildTile(
                    title: '震动',
                    trailing: Switch(
                      value: _vibrateEnabled,
                      onChanged: (v) => setState(() => _vibrateEnabled = v),
                      activeColor: const Color(0xFF12B7F5),
                    ),
                    showArrow: false,
                  ),
                  _buildDivider(),
                  _buildTile(
                    title: '系统通知栏',
                    trailing: Switch(
                      value: _systemNotificationEnabled,
                      onChanged: (v) =>
                          setState(() => _systemNotificationEnabled = v),
                      activeColor: const Color(0xFF12B7F5),
                    ),
                    showArrow: false,
                  ),
                  _buildDivider(),
                  _buildTile(
                    title: '免打扰',
                    trailing: Switch(
                      value: _dndEnabled,
                      onChanged: (v) => setState(() => _dndEnabled = v),
                      activeColor: const Color(0xFF12B7F5),
                    ),
                    showArrow: false,
                  ),
                ],
              ],
            ),
            _buildGroupTitle('关于'),
            _buildCard(
              children: [
                _buildTile(
                  title: '版本号',
                  subtitle: '1.0.0',
                  showArrow: false,
                ),
                _buildDivider(),
                _buildTile(
                  title: '检查更新',
                  onTap: _checkUpdate,
                ),
                _buildDivider(),
                _buildTile(
                  title: 'Powered by ROTeam',
                  showArrow: false,
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
