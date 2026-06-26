// ignore_for_file: deprecated_member_use

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_qq/QQ/message_details_page.dart';
import 'package:flutter_qq/QQ/model/msg_model.dart';
import 'package:flutter_qq/QQ/search_message_list_page.dart';
import 'package:flutter_qq/QQ/user_device_page.dart';
import 'package:flutter_qq/QQ/user_option_page.dart';
import 'package:flutter_qq/QQ/widget/appbar.dart';
import 'package:flutter_qq/QQ/widget/bitmeun.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class UserMessageListPage extends StatefulWidget {
  const UserMessageListPage({super.key});

  @override
  State<UserMessageListPage> createState() => _UserMessageListPageState();
}

class _UserMessageListPageState extends State<UserMessageListPage>
    with AutomaticKeepAliveClientMixin {
  late List<MsgModel> data = [];
  late bool loading = false;
  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() async {
    Future.delayed(const Duration(seconds: 2), () {
      data.add(MsgModel(
          imageurl: 'https://w.wallhaven.cc/full/jx/wallhaven-jxl31y.png',
          msg: '所以，这也仅仅是无用的令戒：🐮🐎',
          name: '造物主动态桌面Ⅰ群',
          time: '下午4:20',
          count: "+99"));
      data.add(MsgModel(
          imageurl: 'https://w.wallhaven.cc/full/2y/wallhaven-2y6w5y.jpg',
          msg: '花开富贵:(❁´◡`❁)',
          name: 'C# WPF ASP.NET',
          time: '上午9:40',
          count: "1"));
      data.add(MsgModel(
          imageurl: 'https://w.wallhaven.cc/full/we/wallhaven-we3wz6.jpg',
          msg: '你摩托车怎么办呢',
          name: '宋涛',
          time: '下午4:33'));
      data.add(MsgModel(
          imageurl: 'https://w.wallhaven.cc/full/yx/wallhaven-yx2lxl.png',
          msg: '楼下两个人打起来了',
          name: 'temp',
          time: '下午13:16'));
      data.add(MsgModel(
          imageurl: 'https://w.wallhaven.cc/full/yx/wallhaven-yxkw7d.jpg',
          msg: '还没有篮子',
          name: '王怀晨',
          time: '下午16:05'));
      data.add(MsgModel(
          imageurl: 'https://w.wallhaven.cc/full/rr/wallhaven-rreejm.jpg',
          msg: '轩宝：[聊天记录]',
          name: '轩宝',
          time: '星期一11:21',
          count: "1"));
      data.add(MsgModel(
          imageurl: 'https://w.wallhaven.cc/full/7p/wallhaven-7pxx99.png',
          msg: '[图片][图片][图片]',
          name: '小号',
          time: '昨天晚上9:03'));
      data.add(MsgModel(
          imageurl: 'https://w.wallhaven.cc/full/7p/wallhaven-7pxxj9.jpg',
          msg: '八嘎の君：八嘎八嘎八嘎,真是小八嘎呢~~',
          name: '八嘎の君',
          time: '下午12:14',
          count: "5"));
      data.add(MsgModel(
          imageurl: 'https://w.wallhaven.cc/full/m3/wallhaven-m3oyx8.jpg',
          msg: '牛牛超人：[图片]',
          name: '发哥是0群友是1',
          time: '昨天晚上7:30'));
      data.add(MsgModel(
          imageurl: 'https://w.wallhaven.cc/full/5g/wallhaven-5gpwd7.jpg',
          msg: '7_bit：皮肤都没有',
          name: '六号、！、7_bit（3）',
          time: '晚上7:30',
          count: "3"));
      data.add(MsgModel(
          imageurl: 'https://w.wallhaven.cc/full/zy/wallhaven-zyvg1j.png',
          msg: '[聊天记录]',
          name: '胖胖',
          time: '昨天19:10'));
      setState(() {
        loading = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double top = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      extendBodyBehindAppBar: true,
      appBar: StudyAppBar.MyAppBar(
        "",
        context,
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leading: const SizedBox(),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16, top + 12, 16, 100),
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(const UserOptionPage(),
                      transition: Transition.leftToRight);
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      "assets/images/bit7.jpg",
                      alignment: Alignment.topCenter,
                      fit: BoxFit.cover,
                      width: 44,
                      height: 44,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "7_bit",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: const Color(0xFF22C55E),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF22C55E).withOpacity(0.5),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        "在线-WIFI",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF8A8A8E),
                        ),
                      )
                    ],
                  ),
                ],
              )),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: MyMeun(
                    context: context,
                    offsetdy: 56,
                    offsetWidth: 180,
                    child: Center(
                      child: SvgPicture.asset(
                        "assets/svg/plus-sm.svg",
                        color: const Color(0xFF1A1A1A),
                        width: 20,
                      ),
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
              ),
            ],
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              Get.to(const SearchMessageListPage());
            },
            child: Hero(
              tag: "Search",
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search, color: Color(0xFF8A8A8E), size: 20),
                    SizedBox(width: 6),
                    Text(
                      "搜索",
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF8A8A8E),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
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
            child: GestureDetector(
              onTap: () {
                Get.to(const UserDevicePage(),
                    transition: Transition.rightToLeft);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFF12B7F5).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          "assets/svg/Monitor.svg",
                          color: const Color(0xFF12B7F5),
                          height: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "已登录 Windows",
                            style: TextStyle(
                              color: Color(0xFF1A1A1A),
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "ZY-PC",
                            style: TextStyle(
                              color: Color(0xFF8A8A8E),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SvgPicture.asset(
                      "assets/svg/chevronright.svg",
                      height: 20,
                      color: const Color(0xFFC7C7CC),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          loading
              ? Container(
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
                    children: List.generate(data.length, (index) {
                      return Column(
                        children: [
                          GestureDetector(
                              onTap: () {
                                Get.to(
                                    MessageDetailsPage(
                                        msgModel: data[index]),
                                    transition: Transition.rightToLeft);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                child: msgItem1(data[index]),
                              )),
                          if (index != data.length - 1)
                            Padding(
                              padding: const EdgeInsets.only(left: 78),
                              child: Divider(
                                thickness: 0.3,
                                color: Colors.grey.withOpacity(0.2),
                                height: 1,
                              ),
                            ),
                        ],
                      );
                    }),
                  ),
                )
              : Shimmer.fromColors(
                  baseColor: Colors.white,
                  highlightColor:
                      const Color.fromARGB(255, 240, 240, 240),
                  child: Container(
                    height: 400,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16)),
                  )),
        ],
      ),
    );
  }

  Widget msgItem1(MsgModel model) {
    Widget loadingWidget = Shimmer.fromColors(
        baseColor: const Color(0xFFF0F0F0),
        highlightColor: Colors.white,
        child: Container(
          height: 52,
          width: 52,
          decoration: BoxDecoration(
            color: const Color(0xFFF0F0F0),
            borderRadius: BorderRadius.circular(14),
          ),
        ));

    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: ExtendedImage.network(
              model.imageurl,
              cache: true,
              width: 52,
              height: 52,
              fit: BoxFit.cover,
              loadStateChanged: (state) {
                if (state.extendedImageLoadState == LoadState.loading) {
                  return loadingWidget;
                } else if (state.extendedImageLoadState ==
                    LoadState.failed) {
                  return loadingWidget;
                }
                return null;
              },
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      model.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      model.msg,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF8A8A8E),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    model.time,
                    style: const TextStyle(
                      color: Color(0xFF8A8A8E),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Opacity(
                    opacity: model.count != null ? 1 : 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      constraints:
                          const BoxConstraints(minWidth: 20, minHeight: 18),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF3B30),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Text(
                        model.count ?? "0",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
