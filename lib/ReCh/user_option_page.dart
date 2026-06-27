import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rech/ReCh/user_information_page.dart';
import 'package:rech/ReCh/widget/appbar.dart';
import 'package:rech/ReCh/widget/bitmeun.dart';
import 'package:rech/models/user_model.dart';
import 'package:rech/states/app_state.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:rech/ReCh/settings_page.dart';
import 'package:rech/ReCh/create_group_page.dart';
import 'package:rech/ReCh/scan_page.dart';

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
    double bottom = MediaQuery.of(context).padding.bottom;

    return Consumer<AppState>(
      builder: (context, appState, child) {
        final user = appState.currentUser;
        final isDarkMode = appState.isDarkMode;
        return Scaffold(
          backgroundColor: const Color(0xFFF5F6F8),
          extendBodyBehindAppBar: true,
          appBar: StudyAppBar.MyAppBar("", context,
              backgroundColor: Colors.transparent,
              systemOverlayStyle: SystemUiOverlayStyle.dark,
              leadingWidth: 140,
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton.icon(
                    onPressed: () async {
                      final result = await appState.checkIn();
                      if (result != null && context.mounted) {
                        final exp = result['added_exp'] ?? 0;
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            title: const Text('打卡成功', textAlign: TextAlign.center),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.check_circle, color: Color(0xFF34C759), size: 64),
                                const SizedBox(height: 16),
                                Text('获得 $exp 经验值', style: const TextStyle(fontSize: 18)),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('确定', style: TextStyle(color: Color(0xFF12B7F5))),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    style: const ButtonStyle(
                        padding: MaterialStatePropertyAll(EdgeInsets.zero),
                        overlayColor:
                            MaterialStatePropertyAll(Colors.transparent)),
                    icon: SvgPicture.asset(
                      "assets/svg/Checkbox_Check.svg",
                      color: const Color(0xFF1A1A1A),
                    ),
                    label: const Text("打卡",
                        style: TextStyle(
                            color: Color(0xFF1A1A1A), fontSize: 16)),
                  ),
                  const SizedBox(width: 4),
                  MyMeun(
                      context: context,
                      offsetdy: 56,
                      offsetWidth: 180,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Color(0xFF1A1A1A),
                          size: 20,
                        ),
                      ),
                      items: [
                        BitMeunItem(
                          icon: SvgPicture.asset("assets/svg/Add_Plus_Circle.svg"),
                          onTap: () {
                            Get.to(() => const CreateGroupPage());
                          },
                          text: '创建群聊',
                        ),
                        BitMeunItem(
                          icon: SvgPicture.asset("assets/svg/Expand.svg"),
                          onTap: () {
                            Get.to(() => const ScanPage());
                          },
                          text: '扫一扫',
                        ),
                      ]),
                ],
              ),
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
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Color(0xFF1A1A1A),
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
                      height: top + 240,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: user?.banner != null && user!.banner.isNotEmpty
                              ? NetworkImage(user.banner)
                              : const AssetImage("assets/images/dao.jpg")
                                  as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      height: top + 240,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.15),
                            Colors.black.withOpacity(0.0),
                            const Color(0xFFF5F6F8),
                          ],
                          stops: const [0.0, 0.6, 1.0],
                        ),
                      ),
                    ),
                    Positioned(
                      top: top + 60,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 15,
                                offset: const Offset(0, 4),
                              ),
                            ],
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
                                        tag: "user_avatar",
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                blurRadius: 8,
                                                offset:
                                                    const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: ClipOval(
                                            child: user?.avatar != null &&
                                                    user!.avatar.isNotEmpty
                                                ? Image.network(
                                                    user.avatar,
                                                    alignment:
                                                        Alignment.topCenter,
                                                    fit: BoxFit.cover,
                                                    width: 64,
                                                    height: 64,
                                                  )
                                                : Image.asset(
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
                                          Text(
                                            user?.nickname ?? "用户",
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight:
                                                  FontWeight.w700,
                                              color: Color(0xFF1A1A1A),
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              _buildLevelIcon(user?.level ?? 1),
                                              const SizedBox(width: 8),
                                              Text(
                                                "Lv.${user?.level ?? 1}",
                                                style: const TextStyle(
                                                  color: Color(0xFFFF9500),
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
                                              Flexible(
                                                child: Text(
                                                  user?.signature ??
                                                      "这个人很懒，什么都没留下",
                                                  style: const TextStyle(
                                                    fontSize: 13,
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
                                                    0xFF8A8A8E),
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
                                      .withOpacity(0.1),
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
                      ),
                    ),
                  ],
                ),
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
                  child: Column(
                    children: [
                      _buildMenuItem("bookmark", "收藏",
                          const Color(0xFFFFCC00)),
                      _buildDivider(),
                      _buildMenuItem("folder", "文件",
                          const Color(0xFF007AFF)),
                    ],
                  ),
                ),

                SizedBox(height: bottom + 100),
              ],
            ),
          ),
          bottomNavigationBar: _buildBottomBar(context, bottom, isDarkMode, appState.toggleDarkMode),
        );
      },
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

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 56),
      child: Divider(
        thickness: 0.3,
        height: 1,
        color: Colors.grey.withOpacity(0.15),
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
                color: Color(0xFF1A1A1A),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (trailing != null)
            Text(
              trailing,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF8A8A8E),
              ),
            ),
          const SizedBox(width: 6),
          SvgPicture.asset(
            "assets/svg/chevronright.svg",
            height: 18,
            color: const Color(0xFFBBBBBB),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, double bottom, bool isDarkMode, VoidCallback toggleDarkMode) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, bottom + 12),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBottomItem("setting", "设置", onTap: () {
            Get.to(() => const SettingsPage());
          }),
          _buildBottomItem("mobile", "等级", onTap: () {
            Get.to(() => const UserInformationPage());
          }),
          _buildBottomItem(
            isDarkMode ? "On" : "dark mode",
            isDarkMode ? "白天" : "夜间",
            onTap: () {
              toggleDarkMode();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomItem(String svg, String str, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            "assets/svg/$svg.svg",
            width: 24,
            color: const Color(0xFF666666),
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
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
