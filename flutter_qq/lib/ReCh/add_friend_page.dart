import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rech/ReCh/widget/appbar.dart';
import 'package:rech/services/api_service.dart';

class AddFriendPage extends StatefulWidget {
  final int userId;
  final String nickname;
  final String? avatar;

  const AddFriendPage({
    super.key,
    required this.userId,
    required this.nickname,
    this.avatar,
  });

  @override
  State<AddFriendPage> createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  final TextEditingController _remarkController = TextEditingController();
  String? _selectedGroup;
  bool _hideMoments = false;
  bool _isLoading = false;

  final List<String> _groups = ['我的好友', '家人', '同事', '同学'];

  @override
  void initState() {
    super.initState();
    _selectedGroup = _groups.first;
  }

  @override
  void dispose() {
    _remarkController.dispose();
    super.dispose();
  }

  Future<void> _onSend() async {
    setState(() => _isLoading = true);
    try {
      final response = await ApiService().addFriend(
        widget.userId,
        _remarkController.text.trim(),
        _groups.indexOf(_selectedGroup ?? '我的好友'),
      );
      if (response.isSuccess) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('已发送好友申请')),
          );
          Navigator.pop(context);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message)),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('发送失败: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: StudyAppBar.MyAppBar(
        '添加好友',
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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFF5F6F8),
                        ),
                        child: widget.avatar != null && widget.avatar!.isNotEmpty
                            ? ClipOval(
                                child: Image.network(
                                  widget.avatar!,
                                  fit: BoxFit.cover,
                                  width: 64,
                                  height: 64,
                                ),
                              )
                            : const Icon(
                                Icons.person,
                                size: 32,
                                color: Color(0xFF8A8A8E),
                              ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.nickname,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'ID: ${widget.userId}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF8A8A8E),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _remarkController,
                    decoration: InputDecoration(
                      hintText: '设置备注',
                      hintStyle: const TextStyle(color: Color(0xFFC7C7CC)),
                      filled: true,
                      fillColor: const Color(0xFFF5F6F8),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (context) {
                          return SafeArea(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: _groups.map((group) {
                                return ListTile(
                                  title: Text(group),
                                  trailing: _selectedGroup == group
                                      ? const Icon(
                                          Icons.check,
                                          color: Color(0xFF12B7F5),
                                        )
                                      : null,
                                  onTap: () {
                                    setState(() => _selectedGroup = group);
                                    Navigator.pop(context);
                                  },
                                );
                              }).toList(),
                            ),
                          );
                        },
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F6F8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '分组',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                _selectedGroup ?? '我的好友',
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF8A8A8E),
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right,
                                color: Color(0xFFC7C7CC),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '不让他看我的动态',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      Switch(
                        value: _hideMoments,
                        onChanged: (v) => setState(() => _hideMoments = v),
                        activeColor: const Color(0xFF12B7F5),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: _isLoading ? null : _onSend,
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFF12B7F5),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF12B7F5).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          '发送',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
