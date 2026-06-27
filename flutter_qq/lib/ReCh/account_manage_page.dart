import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rech/ReCh/widget/appbar.dart';
import 'package:rech/models/user_model.dart';
import 'package:rech/services/api_service.dart';
import 'package:rech/states/app_state.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class AccountManagePage extends StatefulWidget {
  const AccountManagePage({super.key});

  @override
  State<AccountManagePage> createState() => _AccountManagePageState();
}

class _AccountManagePageState extends State<AccountManagePage> {
  List<Map<String, dynamic>> _accounts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  Future<void> _loadAccounts() async {
    final appState = Provider.of<AppState>(context, listen: false);
    setState(() {
      _accounts = List.from(appState.accounts);
      final currentUser = appState.currentUser;
      if (currentUser != null) {
        final existing = _accounts.any(
          (a) => a['id'] == currentUser.id,
        );
        if (!existing) {
          _accounts.insert(0, {
            'id': currentUser.id,
            'username': currentUser.username,
            'nickname': currentUser.nickname,
            'avatar': currentUser.avatar,
            'isCurrent': true,
          });
        }
      }
      _isLoading = false;
    });
  }

  Future<void> _switchAccount(int index) async {
    final appState = Provider.of<AppState>(context, listen: false);
    final account = _accounts[index];
    if (account['isCurrent'] == true) return;

    setState(() => _isLoading = true);
    try {
      final success = await appState.switchAccount(index);
      if (success && mounted) {
        Navigator.pop(context);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('切换账号失败')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('切换失败: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _removeAccount(int index) async {
    final account = _accounts[index];
    if (account['isCurrent'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('当前登录账号不能删除')),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('删除账号'),
        content: Text('确定要从本机删除账号「${account['nickname'] ?? account['username']}」吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: const Color(0xFFFF3B30)),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      final appState = Provider.of<AppState>(context, listen: false);
      appState.removeAccount(index);
      setState(() {
        _accounts.removeAt(index);
      });
    }
  }

  void _addAccount() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: StudyAppBar.MyAppBar(
        '账号管理',
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                ...List.generate(_accounts.length, (index) {
                  final account = _accounts[index];
                  final isCurrent = account['isCurrent'] == true;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => _switchAccount(index),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFFE5E5EA),
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: Color(0xFF8A8A8E),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      account['nickname'] ?? account['username'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF1A1A1A),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      account['username'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF8A8A8E),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isCurrent)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF34C759).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    '当前登录',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF34C759),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              if (!isCurrent)
                                IconButton(
                                  icon: const Icon(Icons.close, color: Color(0xFFC7C7CC)),
                                  onPressed: () => _removeAccount(index),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 16),
                Container(
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
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: _addAccount,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.add, color: Color(0xFF12B7F5)),
                            SizedBox(width: 8),
                            Text(
                              '添加账号',
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF12B7F5),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
