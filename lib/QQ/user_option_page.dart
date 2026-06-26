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
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: StudyAppBar.MyAppBar("", context,
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          leadingWidth: 100,
          leading: MyMeun(
              context: context,
              child: TextButton.icon(
                onPressed: () {},
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 10),
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
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.to(const UserInformationPage(),
                                transition: Transition.downToUp);
                          },
                          child: Hero(
                            tag: "assets/images/bit7.jpg",
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
                                child: Image.asset(
                                  "assets/images/bit7.jpg",
                                  alignment: Alignment.topCenter,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Shimmer.fromColors(
                                baseColor: const Color(0xFF1A1A1A),
                                highlightColor: const Color(0xFFFF3B30),
                                child: const Text(
                                  "7_bit",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                "👑🌙✨✨",
                                style: TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Flexible(
                                    child: Text(
                                      "sex robot",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF8A8A8E),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  SvgPicture.asset(
                                    "assets/svg/edit.svg",
                                    height: 14,
                                    color: const Color(0xFFC7C7CC),
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
                      color: const Color(0xFF12B7F5).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
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
            const SizedBox(height: 20),
            Expanded(
                child: Container(
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
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 4),
                children: [
                  getItem("folder", "文件", const Color(0xFF007AFF)),
                  _divider(),
                  getItem("upload 1", "微云", const Color(0xFFFF9500)),
                  _divider(),
                  getItem("picture", "相册", const Color(0xFFFF2D55)),
                  _divider(),
                  getItem("bookmark", "收藏", const Color(0xFFFFCC00)),
                  _divider(),
                  getItem("tethering 1", "王卡", const Color(0xFF34C759)),
                  _divider(),
                  getItem("desktop 1", "我的电脑", const Color(0xFF5856D6)),
                  _divider(),
                  getItem("controller 1", "游戏中心", const Color(0xFFFF3B30)),
                ],
              ),
            )),
            const SizedBox(height: 20),
            Container(
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MyMeun(
                      child: getItem1("setting", "设置"),
                      context: context,
                      isup: false,
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
                  getItem1("mobile", "等级"),
                  MyMeun(
                      child: getItem1("dark mode", "夜间"),
                      context: context,
                      isup: false,
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
                  getItem1("On", "天气"),
                ],
              ),
            ),
            const SizedBox(
              height: 24,
            )
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.only(left: 56),
      child: Divider(
        thickness: 0.3,
        height: 1,
        color: Colors.grey.withOpacity(0.2),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

Widget getItem(String svg, String str, Color color) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    child: Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
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
        SvgPicture.asset(
          "assets/svg/chevronright.svg",
          height: 18,
          color: const Color(0xFFC7C7CC),
        ),
      ],
    ),
  );
}

Widget getItem1(String svg, String str) {
  return Column(
    children: [
      SvgPicture.asset(
        "assets/svg/$svg.svg",
        width: 24,
        color: const Color(0xFF1A1A1A),
      ),
      const SizedBox(height: 6),
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

Widget a(BuildContext context) {
  return Listener(
    onPointerUp: (event) {
      BitMeunshowDialog(
        context: context,
        event: event,
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
        ],
      );
    },
    child: AbsorbPointer(
      child: TextButton.icon(
        onPressed: () {
          showDialog(
              builder: (BuildContext context) {
                return const DetailPage("assets/images/dao.jpg");
              },
              context: context);
        },
        style: const ButtonStyle(
            padding: MaterialStatePropertyAll(EdgeInsets.zero),
            overlayColor: MaterialStatePropertyAll(Colors.transparent)),
        icon: SvgPicture.asset(
          "assets/svg/Checkbox_Check.svg",
          color: Colors.black,
        ),
        label: const Text("打卡",
            style: TextStyle(color: Colors.black, fontSize: 16)),
      ),
    ),
  );
}
