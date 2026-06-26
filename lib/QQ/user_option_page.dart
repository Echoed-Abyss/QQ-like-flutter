// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_qq/QQ/user_information_page.dart';
import 'package:flutter_qq/QQ/widget/appbar.dart';
import 'package:flutter_qq/QQ/widget/bitmeun.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class UserOptionPage extends StatefulWidget {
  const UserOptionPage({super.key});

  @override
  State<UserOptionPage> createState() => _UserOptionPageState();
}

class _UserOptionPageState extends State<UserOptionPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    double top = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      extendBodyBehindAppBar: true,
      appBar: StudyAppBar.MyAppBar("", context,
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          leadingWidth: 100,
          leading: MyMeun(
              context: context,
              offsetdy: 56,
              child: TextButton.icon(
                onPressed: () {},
                style: const ButtonStyle(
                    padding: MaterialStatePropertyAll(EdgeInsets.zero),
                    overlayColor:
                        MaterialStatePropertyAll(Colors.transparent)),
                icon: SvgPicture.asset(
                  "assets/svg/Checkbox_Check.svg",
                  color: Colors.white,
                ),
                label: const Text("打卡",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
              items: [
                BitMeunItem(
                  icon: SvgPicture.asset("assets/svg/Group 151.svg"),
                  onTap: () {},
                  text: '创建DAO',
                ),
                BitMeunItem(
                  icon: SvgPicture.asset("assets/svg/QQ.svg"),
                  onTap: () {},
                  text: '创建群聊',
                ),
                BitMeunItem(
                  icon: SvgPicture.asset("assets/svg/User-plus.svg"),
                  onTap: () {},
                  text: '添加好友',
                ),
                BitMeunItem(
                  icon: SvgPicture.asset("assets/svg/Expand.svg"),
                  onTap: () {},
                  text: '扫一扫',
                ),
              ]),
          actions: [
            IconButton(
              padding: const EdgeInsets.only(right: 12),
              onPressed: () {
                Get.back();
              },
              icon: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              style: const ButtonStyle(
                  padding: MaterialStatePropertyAll(EdgeInsets.zero)),
            ),
          ]),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: top + 280,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/dao.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: top + 280,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.0),
                        const Color(0xFF1A1A1A),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
                Positioned(
                  top: top + 80,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.05),
                              width: 0.5,
                            ),
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(
                                            const UserInformationPage(),
                                            transition:
                                                Transition.downToUp);
                                      },
                                      child: Hero(
                                        tag: "assets/images/bit7.jpg",
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.3),
                                                blurRadius: 10,
                                                offset:
                                                    const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: ClipOval(
                                            child: Image.asset(
                                              "assets/images/bit7.jpg",
                                              alignment:
                                                  Alignment.topCenter,
                                              fit: BoxFit.cover,
                                              width: 64,
                                              height: 64,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Shimmer.fromColors(
                                            baseColor:
                                                const Color(0xFFFF6B6B),
                                            highlightColor:
                                                const Color(0xFFFFD93D),
                                            child: const Text(
                                              "7_bit",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight:
                                                    FontWeight.w700,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              Image.asset(
                                                "assets/images/level/sun.png",
                                                height: 16,
                                              ),
                                              const SizedBox(width: 2),
                                              Image.asset(
                                                "assets/images/level/sun.png",
                                                height: 16,
                                              ),
                                              const SizedBox(width: 2),
                                              Image.asset(
                                                "assets/images/level/moon.png",
                                                height: 16,
                                              ),
                                              const SizedBox(width: 2),
                                              Image.asset(
                                                "assets/images/level/star.png",
                                                height: 16,
                                              ),
                                              const SizedBox(width: 8),
                                              Container(
                                                height: 12,
                                                width: 0.5,
                                                color: Colors.white
                                                    .withOpacity(0.2),
                                              ),
                                              const SizedBox(width: 8),
                                              Image.asset(
                                                "assets/images/level/king.png",
                                                height: 16,
                                              ),
                                              const SizedBox(width: 2),
                                              const Text(
                                                "6",
                                                style: TextStyle(
                                                  color: Color(0xFFFFB800),
                                                  fontSize: 12,
                                                  fontWeight:
                                                      FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            mainAxisSize:
                                                MainAxisSize.min,
                                            children: [
                                              const Flexible(
                                                child: Text(
                                                  "sex robot",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color:
                                                        Color(0xFF8A8A8E),
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow
                                                          .ellipsis,
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              SvgPicture.asset(
                                                "assets/svg/edit.svg",
                                                height: 14,
                                                color: const Color(
                                                    0xFF666666),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF12B7F5)
                                      .withOpacity(0.15),
                                  borderRadius:
                                      BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.qr_code,
                                  color: Color(0xFF12B7F5),
                                  size: 20,
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.05),
                              width: 0.5,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                            children: [
                              _buildBottomItem("setting", "设置"),
                              _buildBottomItem("mobile", "等级"),
                              _buildBottomItem("dark mode", "夜间"),
                              _buildBottomItem("On", "天气"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.05),
                  width: 0.5,
                ),
              ),
              child: Column(
                children: [
                  _buildMenuItem("picture", "相册", const Color(0xFFFF2D55)),
                  _buildDivider(),
                  _buildMenuItem("bookmark", "收藏", const Color(0xFFFFCC00)),
                  _buildDivider(),
                  _buildMenuItem("folder", "文件", const Color(0xFF007AFF)),
                  _buildDivider(),
                  _buildMenuItem("tethering 1", "钱包", const Color(0xFFFF3B30)),
                  _buildDivider(),
                  _buildMenuItem("controller 1", "会员中心", const Color(0xFFFF6B6B)),
                  _buildDivider(),
                  _buildMenuItem("upload 1", "个性装扮", const Color(0xFFFF2D55),
                      trailing: "6个好友正在使用"),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.05),
                  width: 0.5,
                ),
              ),
              child: Column(
                children: [
                  _buildMenuItem("wifi", "免流量", const Color(0xFF34C759),
                      trailing: "月月送SVIP"),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 56),
      child: Divider(
        thickness: 0.3,
        height: 1,
        color: Colors.white.withOpacity(0.08),
      ),
    );
  }

  Widget _buildMenuItem(String svg, String str, Color color,
      {String? trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Center(
              child: SvgPicture.asset(
                "assets/svg/$svg.svg",
                width: 18,
                color: color,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              str,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (trailing != null)
            Text(
              trailing,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF666666),
              ),
            ),
          const SizedBox(width: 6),
          SvgPicture.asset(
            "assets/svg/chevronright.svg",
            height: 18,
            color: const Color(0xFF555555),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomItem(String svg, String str) {
    return Column(
      children: [
        SvgPicture.asset(
          "assets/svg/$svg.svg",
          width: 24,
          color: Colors.white,
        ),
        const SizedBox(height: 4),
        Text(
          str,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF8A8A8E),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
