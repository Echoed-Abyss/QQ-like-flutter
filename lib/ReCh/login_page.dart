import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rech/services/permission_service.dart';
import 'package:rech/services/notification_service.dart';
import 'package:rech/states/app_state.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _isRegisterMode = false;
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    try {
      await PermissionService().requestNotificationPermission();
    } catch (e) {
      if (mounted) {
        debugPrint('请求权限失败: $e');
      }
    }
    try {
      await NotificationService().requestPermissions();
    } catch (e) {
      if (mounted) {
        debugPrint('请求通知权限失败: $e');
      }
    }
  }

  Future<void> _handleLogin() async {
    final account = _accountController.text.trim();
    final password = _passwordController.text.trim();

    if (account.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请输入账号和密码'),
          backgroundColor: Color(0xFFFF3B30),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final appState = Provider.of<AppState>(context, listen: false);
    final success = await appState.login(account, password);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(appState.errorMessage ?? '登录失败'),
            backgroundColor: const Color(0xFFFF3B30),
          ),
        );
      }
    }
  }

  Future<void> _handleRegister() async {
    final account = _accountController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    final nickname = _nicknameController.text.trim();

    if (account.isEmpty || password.isEmpty || nickname.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请填写完整信息'),
          backgroundColor: Color(0xFFFF3B30),
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('两次密码输入不一致'),
          backgroundColor: Color(0xFFFF3B30),
        ),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('密码长度不能少于6位'),
          backgroundColor: Color(0xFFFF3B30),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await Provider.of<AppState>(context, listen: false)
          .register(account, password, nickname);
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        if (response) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('注册成功，请登录'),
              backgroundColor: Color(0xFF34C759),
            ),
          );
          setState(() {
            _isRegisterMode = false;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(Provider.of<AppState>(context, listen: false)
                      .errorMessage ??
                  '注册失败'),
              backgroundColor: const Color(0xFFFF3B30),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('注册失败: $e'),
            backgroundColor: const Color(0xFFFF3B30),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                _buildLogo(),
                const SizedBox(height: 40),
                _buildTitle(),
                const SizedBox(height: 32),
                _buildInputFields(),
                const SizedBox(height: 24),
                _buildActionButton(),
                const SizedBox(height: 16),
                _buildSwitchMode(),
                const SizedBox(height: 40),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Center(
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: const Color(0xFF12B7F5),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF12B7F5).withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Icon(
          Icons.chat_bubble_outline,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _isRegisterMode ? '注册账号' : '欢迎回来',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _isRegisterMode ? '创建一个新账号开始聊天' : '登录您的账号继续使用',
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFF8A8A8E),
          ),
        ),
      ],
    );
  }

  Widget _buildInputFields() {
    return Column(
      children: [
        _buildTextField(
          controller: _accountController,
          hintText: '请输入账号',
          icon: Icons.person_outline,
          keyboardType: TextInputType.text,
        ),
        const SizedBox(height: 16),
        if (_isRegisterMode) ...[
          _buildTextField(
            controller: _nicknameController,
            hintText: '请输入昵称',
            icon: Icons.badge_outlined,
            keyboardType: TextInputType.text,
          ),
          const SizedBox(height: 16),
        ],
        _buildTextField(
          controller: _passwordController,
          hintText: '请输入密码',
          icon: Icons.lock_outline,
          obscureText: _obscurePassword,
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: const Color(0xFF8A8A8E),
              size: 22,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
        ),
        if (_isRegisterMode) ...[
          const SizedBox(height: 16),
          _buildTextField(
            controller: _confirmPasswordController,
            hintText: '请确认密码',
            icon: Icons.lock_outline,
            obscureText: true,
          ),
        ],
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 16,
          color: Color(0xFF1A1A1A),
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 16,
            color: Color(0xFF8A8A8E),
          ),
          prefixIcon: Icon(
            icon,
            color: const Color(0xFF8A8A8E),
            size: 22,
          ),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading
            ? null
            : (_isRegisterMode ? _handleRegister : _handleLogin),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF12B7F5),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadowColor: const Color(0xFF12B7F5).withOpacity(0.3),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                _isRegisterMode ? '注册' : '登录',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildSwitchMode() {
    return Center(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isRegisterMode = !_isRegisterMode;
          });
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _isRegisterMode ? '已有账号？' : '还没有账号？',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF8A8A8E),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              _isRegisterMode ? '去登录' : '去注册',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF12B7F5),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: const Color(0xFFE5E5EA),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '其他登录方式',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF8A8A8E),
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 1,
                color: const Color(0xFFE5E5EA),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialIcon(Icons.qr_code_scanner_outlined, '扫码'),
            const SizedBox(width: 32),
            _buildSocialIcon(Icons.phone_android_outlined, '手机号'),
            const SizedBox(width: 32),
            _buildSocialIcon(Icons.mail_outline, '邮箱'),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: const Color(0xFF12B7F5),
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF8A8A8E),
          ),
        ),
      ],
    );
  }
}
