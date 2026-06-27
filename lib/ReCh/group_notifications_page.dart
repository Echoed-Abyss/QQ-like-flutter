import 'package:flutter/material.dart';
import 'package:rech/ReCh/widget/appbar.dart';
import 'package:rech/services/api_service.dart';

class GroupNotificationsPage extends StatefulWidget {
  const GroupNotificationsPage({super.key});

  @override
  State<GroupNotificationsPage> createState() => _GroupNotificationsPageState();
}

class _GroupNotificationsPageState extends State<GroupNotificationsPage> {
  List<Map<String, dynamic>> _requests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    setState(() => _isLoading = true);
    try {
      final response = await ApiService().getGroupJoinRequests();
      if (response.isSuccess && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final list = data['list'] as List? ?? [];
        setState(() {
          _requests = list.cast<Map<String, dynamic>>();
        });
      }
    } catch (e) {
      // ignore
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleRequest(int requestId, bool accept) async {
    try {
      final response = await ApiService().handleGroupJoinRequest(
        requestId,
        accept ? 'accepted' : 'rejected',
      );
      if (response.isSuccess) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(accept ? '已同意' : '已拒绝')),
          );
        }
        await _loadRequests();
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
          SnackBar(content: Text('操作失败: $e')),
        );
      }
    }
  }

  Widget _buildRequestItem(Map<String, dynamic> item) {
    final groupName = item['group_name'] as String? ?? '未知群聊';
    final userNickname = item['user_nickname'] as String? ?? '未知用户';
    final userAvatar = item['user_avatar'] as String? ?? '';
    final time = item['created_at'] as String? ?? '';
    final requestId = item['id'] as int? ?? 0;

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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFF5F6F8),
                ),
                child: userAvatar.isNotEmpty
                    ? ClipOval(
                        child: Image.network(
                          userAvatar,
                          fit: BoxFit.cover,
                          width: 48,
                          height: 48,
                        ),
                      )
                    : const Icon(
                        Icons.person,
                        size: 24,
                        color: Color(0xFF8A8A8E),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userNickname,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '申请加入 $groupName',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF8A8A8E),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (time.isNotEmpty)
                      Text(
                        time,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFC7C7CC),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () => _handleRequest(requestId, false),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F6F8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    '拒绝',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF8A8A8E),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => _handleRequest(requestId, true),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF12B7F5).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    '同意',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF12B7F5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: StudyAppBar.MyAppBar(
        '群通知',
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
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF12B7F5),
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadRequests,
              color: const Color(0xFF12B7F5),
              child: _requests.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(height: 120),
                        Center(
                          child: Text(
                            '暂无群通知',
                            style: TextStyle(
                              color: Color(0xFF8A8A8E),
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(top: 8, bottom: 32),
                      itemCount: _requests.length,
                      itemBuilder: (context, index) {
                        return _buildRequestItem(_requests[index]);
                      },
                    ),
            ),
    );
  }
}
