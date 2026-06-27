import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_qq/QQ/widget/appbar.dart';
import 'package:flutter_qq/models/user_model.dart';
import 'package:flutter_qq/services/api_service.dart';
import 'package:flutter_qq/states/app_state.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class UserInformationPage extends StatefulWidget {
  const UserInformationPage({super.key, this.userId = 0});
  final int userId;

  @override
  State<UserInformationPage> createState() => _UserInformationPageState();
}

class _UserInformationPageState extends State<UserInformationPage>
    with TickerProviderStateMixin {
  final double imageheight = 200;
  final ValueNotifier<double> _extraPicHeight = ValueNotifier(0.0);
  double _dy = 0;

  late AnimationController animatedContainer;
  late Animation<double> animation;

  UserModel? _user;
  bool _isLoading = true;
  bool _isCurrentUser = false;

  void _updateHeight(double position) {
    if (_dy == 0) {
      _dy = position;
    }
    final newHeight = _extraPicHeight.value + position - _dy;
    if (newHeight <= -150 || newHeight >= 200) {
      return;
    }
    _extraPicHeight.value = newHeight;
    _dy = position;
  }

  void _runAnimate() {
    animation = Tween(
      begin: _extraPicHeight.value,
      end: .0,
    ).animate(animatedContainer)
      ..addListener(() {
        _extraPicHeight.value = animation.value;
      });
    _dy = 0;
    animatedContainer.forward(from: .0);
  }

  @override
  void initState() {
    super.initState();
    animatedContainer = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    animation = Tween(begin: 0.0, end: 0.0).animate(animatedContainer);
    _loadUserInfo();
  }

  @override
  void dispose() {
    _extraPicHeight.dispose();
    animatedContainer.dispose();
    super.dispose();
  }

  Future<void> _loadUserInfo() async {
    final appState = Provider.of<AppState>(context, listen: false);
    final currentUser = appState.currentUser;

    if (widget.userId == 0 ||
        (currentUser != null && widget.userId == currentUser.id)) {
      _user = currentUser;
      _isCurrentUser = true;
      _isLoading = false;
      setState(() {});
      return;
    }

    try {
      final response = await ApiService().getUserProfile(widget.userId);
      if (response.isSuccess && response.data != null) {
        _user = response.data!;
        _isCurrentUser = false;
      }
    } catch (e) {
      // Use mock data on error
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _getGenderText(int gender) {
    switch (gender) {
      case 1:
        return '男';
      case 2:
        return '女';
      default:
        return '保密';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      extendBodyBehindAppBar: true,
      appBar: StudyAppBar.MyAppBar("", context,
          backgroundColor: Colors.transparent,
          leading: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black.withOpacity(0.3),
                ),
                margin: const EdgeInsets.all(8),
                child: const BackButton(
                  color: Colors.white,
                  style: ButtonStyle(
                      padding: MaterialStatePropertyAll(EdgeInsets.zero)),
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              icon: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black.withOpacity(0.3),
                ),
                child: const Icon(
                  Icons.qr_code,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              style: const ButtonStyle(
                  padding: MaterialStatePropertyAll(EdgeInsets.zero)),
            ),
            const SizedBox(width: 8),
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              icon: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black.withOpacity(0.3),
                ),
                child: const Icon(
                  Icons.more_horiz,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              style: const ButtonStyle(
                  padding: MaterialStatePropertyAll(EdgeInsets.zero)),
            ),
            const SizedBox(width: 12),
          ]),
      body: Listener(
        onPointerMove: (event) {
          _updateHeight(event.position.dy / 2);
        },
        onPointerUp: (value) {
          _runAnimate();
        },
        child: ValueListenableBuilder<double>(
          valueListenable: _extraPicHeight,
          builder: (context, height, child) {
            return Stack(
              children: [
                _buildBanner(),
                ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    SizedBox(
                      height: imageheight - 30 + height,
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFF5F6F8),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                      ),
                      child: Column(
                        children: [
                          _buildUserInfoCard(),
                          const SizedBox(height: 12),
                          _buildSignatureCard(),
                          const SizedBox(height: 12),
                          _buildDataCard(),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(24)),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            border: Border(
                              top: BorderSide(
                                color: Colors.grey.withOpacity(0.1),
                                width: 0.5,
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                          child: Row(
                            children: [
                              if (_isCurrentUser) ...[
                                Expanded(
                                  child: _buildActionButton(
                                    '个性名片',
                                    const Color(0xFF8A8A8E),
                                    Colors.white,
                                    borderColor: const Color(0xFFE5E5EA),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildActionButton(
                                    '编辑资料',
                                    const Color(0xFF8A8A8E),
                                    Colors.white,
                                    borderColor: const Color(0xFFE5E5EA),
                                  ),
                                ),
                              ] else ...[
                                Expanded(
                                  child: _buildActionButton(
                                    '加好友',
                                    const Color(0xFF8A8A8E),
                                    Colors.white,
                                    borderColor: const Color(0xFFE5E5EA),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildActionButton(
                                    '发消息',
                                    Colors.white,
                                    const Color(0xFF12B7F5),
                                    hasShadow: true,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBanner() {
    final bannerUrl = _user?.banner;
    return GestureDetector(
      onTap: () {
        if (bannerUrl != null && bannerUrl.isNotEmpty) {
          _showImageDialog(bannerUrl, isNetwork: true);
        }
      },
      child: RepaintBoundary(
        child: bannerUrl != null && bannerUrl.isNotEmpty
            ? ExtendedImage.network(
                bannerUrl,
                height: imageheight + _extraPicHeight.value,
                fit: BoxFit.cover,
                width: double.infinity,
                loadStateChanged: (state) {
                  if (state.extendedImageLoadState == LoadState.loading) {
                    return Shimmer.fromColors(
                        baseColor: const Color.fromARGB(255, 240, 240, 240),
                        highlightColor: Colors.white,
                        child: Container(
                          height: imageheight,
                          width: double.infinity,
                          color: Colors.white,
                        ));
                  } else if (state.extendedImageLoadState ==
                      LoadState.failed) {
                    return Image.asset(
                      "assets/images/dao.jpg",
                      height: imageheight + _extraPicHeight.value,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    );
                  }
                  return null;
                },
              )
            : Image.asset(
                "assets/images/dao.jpg",
                height: imageheight + _extraPicHeight.value,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
      ),
    );
  }

  Widget _buildUserInfoCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      _buildAvatar(),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildNickname(),
                          const SizedBox(height: 4),
                          _buildQQNumber(),
                          const SizedBox(height: 6),
                          _buildLevelRow(),
                        ],
                      ),
                    ],
                  ),
                  _buildFavoriteButton(),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                thickness: 0.3,
                height: 1,
                color: Color(0xFFE5E5EA),
              ),
            ),
            _buildGenderAgeRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    final avatarUrl = _user?.avatar;
    return GestureDetector(
      onTap: () {
        if (avatarUrl != null && avatarUrl.isNotEmpty) {
          _showImageDialog(avatarUrl, isNetwork: true);
        } else {
          _showImageDialog("assets/images/bit7.jpg", isNetwork: false);
        }
      },
      child: Hero(
        tag: "user_avatar_${widget.userId}",
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipOval(
            child: avatarUrl != null && avatarUrl.isNotEmpty
                ? ExtendedImage.network(
                    avatarUrl,
                    alignment: Alignment.topCenter,
                    fit: BoxFit.cover,
                    width: 72,
                    height: 72,
                  )
                : Image.asset(
                    "assets/images/bit7.jpg",
                    alignment: Alignment.topCenter,
                    fit: BoxFit.cover,
                    width: 72,
                    height: 72,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildNickname() {
    if (_isLoading) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: 100,
          height: 22,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      );
    }
    return Text(
      _user?.nickname ?? '用户',
      style: const TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w700,
        color: Color(0xFF1A1A1A),
      ),
    );
  }

  Widget _buildQQNumber() {
    if (_isLoading) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: 150,
          height: 14,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      );
    }
    return Text.rich(
      TextSpan(children: [
        TextSpan(
          text: "QQ号：${_user?.qqNumber ?? ''}",
          style: const TextStyle(color: Color(0xFF8A8A8E)),
        ),
        TextSpan(
            text: " (ID：${_user?.username ?? ''})",
            style: const TextStyle(color: Color(0xFF8A8A8E))),
      ]),
      style: const TextStyle(fontSize: 12),
    );
  }

  Widget _buildLevelRow() {
    final level = _user?.level ?? 1;
    return Row(
      children: [
        _buildLevelIcon(level),
        const SizedBox(width: 8),
        Text(
          "Lv.$level",
          style: const TextStyle(
            color: Color(0xFFFFB800),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildLevelIcon(int level) {
    if (level >= 100) {
      return Image.asset(
        "assets/images/level/king.png",
        height: 16,
      );
    } else if (level >= 64) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset("assets/images/level/sun.png", height: 16),
          const SizedBox(width: 2),
          Image.asset("assets/images/level/sun.png", height: 16),
          const SizedBox(width: 2),
          Image.asset("assets/images/level/moon.png", height: 16),
        ],
      );
    } else if (level >= 32) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset("assets/images/level/sun.png", height: 16),
          const SizedBox(width: 2),
          Image.asset("assets/images/level/moon.png", height: 16),
          const SizedBox(width: 2),
          Image.asset("assets/images/level/star.png", height: 16),
        ],
      );
    } else if (level >= 16) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset("assets/images/level/moon.png", height: 16),
          const SizedBox(width: 2),
          Image.asset("assets/images/level/star.png", height: 16),
          const SizedBox(width: 2),
          Image.asset("assets/images/level/star.png", height: 16),
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset("assets/images/level/star.png", height: 16),
          const SizedBox(width: 2),
          Image.asset("assets/images/level/star.png", height: 16),
          const SizedBox(width: 2),
          Image.asset("assets/images/level/star_0.png", height: 16),
        ],
      );
    }
  }

  Widget _buildFavoriteButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {},
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFFF3B30).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: SvgPicture.asset(
                "assets/svg/favorite.svg",
                width: 20,
                color: const Color(0xFFFF3B30),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          "1024",
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF8A8A8E),
          ),
        )
      ],
    );
  }

  Widget _buildGenderAgeRow() {
    return SizedBox(
      height: 52,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: const Color(0xFF007AFF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.person_outline,
                color: Color(0xFF007AFF),
                size: 16,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text.rich(
                TextSpan(children: [
                  TextSpan(
                      text: _getGenderText(_user?.gender ?? 0),
                      style: const TextStyle(color: Color(0xFF1A1A1A))),
                  const TextSpan(
                      text: " | ",
                      style: TextStyle(color: Color(0xFFC7C7CC))),
                  TextSpan(
                      text: "${_user?.age ?? 0}岁",
                      style: const TextStyle(color: Color(0xFF1A1A1A))),
                  const TextSpan(
                      text: " | ",
                      style: TextStyle(color: Color(0xFFC7C7CC))),
                  TextSpan(
                      text: _user?.constellation ?? '未知',
                      style: const TextStyle(color: Color(0xFF1A1A1A))),
                  const TextSpan(
                      text: " | ",
                      style: TextStyle(color: Color(0xFFC7C7CC))),
                  TextSpan(
                      text: _user?.location ?? '未知',
                      style: const TextStyle(color: Color(0xFF1A1A1A))),
                  const TextSpan(
                      text: " | ",
                      style: TextStyle(color: Color(0xFFC7C7CC))),
                  TextSpan(
                      text: _user?.occupation ?? '未知',
                      style: const TextStyle(color: Color(0xFF1A1A1A))),
                ]),
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            SvgPicture.asset(
              "assets/svg/chevronright.svg",
              height: 18,
              color: const Color(0xFFC7C7CC),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSignatureCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Flexible(
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9500).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        "assets/svg/document 1.svg",
                        width: 16,
                        color: const Color(0xFFFF9500),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _user?.signature ?? '这个人很懒，什么都没留下',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1A1A1A),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  )
                ],
              ),
            ),
            if (_isCurrentUser)
              Row(
                children: [
                  const Text(
                    "去完善",
                    style: TextStyle(
                      color: Color(0xFF12B7F5),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SvgPicture.asset(
                    "assets/svg/chevronright.svg",
                    height: 18,
                    color: const Color(0xFFC7C7CC),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            _buildDataItem(
                "assets/svg/Star.svg", "QQ空间", "分享新鲜事", const Color(0xFFFFB800)),
            const SizedBox(height: 14),
            _buildDataItem("assets/svg/More_Grid_Big.svg", "精选照片",
                "添加精美照片、展示个性的你", const Color(0xFF5856D6)),
          ],
        ),
      ),
    );
  }

  Widget _buildDataItem(
      String icon, String title, String subtitle, Color color) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    icon,
                    width: 16,
                    color: color,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1A1A1A),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              )
            ],
          ),
        ),
        Row(
          children: [
            Text(
              subtitle,
              style: const TextStyle(
                color: Color(0xFF8A8A8E),
                fontSize: 12,
              ),
            ),
            SvgPicture.asset(
              "assets/svg/chevronright.svg",
              height: 18,
              color: const Color(0xFFC7C7CC),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildActionButton(String text, Color textColor, Color bgColor,
      {Color? borderColor, bool hasShadow = false}) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: borderColor != null
            ? Border.all(color: borderColor, width: 0.5)
            : null,
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: const Color(0xFF12B7F5).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showImageDialog(String url, {bool isNetwork = false}) {
    showDialog(
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Center(
              child: isNetwork
                  ? ExtendedImage.network(
                      url,
                      fit: BoxFit.contain,
                    )
                  : Image.asset(url),
            ),
          ),
        );
      },
      context: context,
    );
  }
}
