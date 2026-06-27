import 'package:flutter/material.dart';
import 'package:rech/ReCh/widget/appbar.dart';
import 'package:rech/services/api_service.dart';
import 'package:rech/states/app_state.dart';
import 'package:provider/provider.dart';

class LikeRankPage extends StatefulWidget {
  const LikeRankPage({super.key});

  @override
  State<LikeRankPage> createState() => _LikeRankPageState();
}

class _LikeRankPageState extends State<LikeRankPage> {
  List<Map<String, dynamic>> _rankList = [];
  bool _isLoading = true;
  int? _currentUserId;

  @override
  void initState() {
    super.initState();
    _currentUserId = Provider.of<AppState>(context, listen: false).currentUser?.id;
    _loadRank();
  }

  Future<void> _loadRank() async {
    try {
      final response = await ApiService().getLikeRank();
      if (response.isSuccess && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final list = data['list'] as List? ?? [];
        setState(() {
          _rankList = list.cast<Map<String, dynamic>>();
        });
      }
    } catch (e) {
      // ignore
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildTopThree() {
    if (_rankList.length < 3) return const SizedBox.shrink();

    final top3 = _rankList.take(3).toList();
    final colors = [
      const Color(0xFFFFD700),
      const Color(0xFFC0C0C0),
      const Color(0xFFCD7F32),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTopItem(top3[1], 1, colors[1]),
          _buildTopItem(top3[0], 0, colors[0], isCenter: true),
          _buildTopItem(top3[2], 2, colors[2]),
        ],
      ),
    );
  }

  Widget _buildTopItem(Map<String, dynamic> item, int index, Color crownColor,
      {bool isCenter = false}) {
    final size = isCenter ? 80.0 : 64.0;
    final avatar = item['avatar'] as String? ?? '';
    final nickname = item['nickname'] as String? ?? '用户';
    final likes = item['likes'] as int? ?? 0;

    return Expanded(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                margin: EdgeInsets.only(top: isCenter ? 0 : 16),
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: crownColor,
                      width: 3,
                    ),
                  ),
                  child: ClipOval(
                    child: avatar.isNotEmpty
                        ? Image.network(
                            avatar,
                            fit: BoxFit.cover,
                            width: size,
                            height: size,
                          )
                        : Image.asset(
                            'assets/images/bit7.jpg',
                            fit: BoxFit.cover,
                            width: size,
                            height: size,
                          ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                child: Icon(
                  Icons.emoji_events,
                  color: crownColor,
                  size: isCenter ? 28 : 22,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            nickname,
            style: TextStyle(
              fontSize: isCenter ? 15 : 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1A1A),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            '$likes 赞',
            style: TextStyle(
              fontSize: isCenter ? 13 : 12,
              color: const Color(0xFF8A8A8E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankItem(int index, Map<String, dynamic> item) {
    final rank = index + 1;
    final avatar = item['avatar'] as String? ?? '';
    final nickname = item['nickname'] as String? ?? '用户';
    final likes = item['likes'] as int? ?? 0;
    final userId = item['user_id'] as int? ?? 0;
    final isMe = userId == _currentUserId;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isMe ? const Color(0xFF12B7F5).withOpacity(0.08) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          if (!isMe)
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            child: Text(
              '$rank',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: rank <= 3 ? const Color(0xFFFFB800) : const Color(0xFF8A8A8E),
              ),
            ),
          ),
          ClipOval(
            child: avatar.isNotEmpty
                ? Image.network(
                    avatar,
                    fit: BoxFit.cover,
                    width: 44,
                    height: 44,
                  )
                : Image.asset(
                    'assets/images/bit7.jpg',
                    fit: BoxFit.cover,
                    width: 44,
                    height: 44,
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nickname,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isMe ? const Color(0xFF12B7F5) : const Color(0xFF1A1A1A),
                  ),
                ),
                if (isMe)
                  const Text(
                    '我',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF12B7F5),
                    ),
                  ),
              ],
            ),
          ),
          Text(
            '$likes',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFFFF3B30),
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.favorite,
            size: 16,
            color: Color(0xFFFF3B30),
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
        '获赞排行榜',
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
              onRefresh: _loadRank,
              color: const Color(0xFF12B7F5),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: _buildTopThree(),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return _buildRankItem(index, _rankList[index]);
                      },
                      childCount: _rankList.length > 50 ? 50 : _rankList.length,
                    ),
                  ),
                  const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
                ],
              ),
            ),
    );
  }
}
