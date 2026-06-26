// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_qq/QQ/search_message_list_page.dart';
import 'package:flutter_qq/QQ/user_option_page.dart';
import 'package:flutter_qq/QQ/widget/appbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class UserContactsListPage extends StatefulWidget {
  const UserContactsListPage({super.key});

  @override
  State<UserContactsListPage> createState() => _UserContactsListPageState();
}

class _UserContactsListPageState extends State<UserContactsListPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 6, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double top = MediaQuery.of(context).padding.top;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF5F6F8),
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
                const Expanded(
                  child: Text(
                    "联系人",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ),
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
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: SvgPicture.asset(
                      "assets/svg/User-plus.svg",
                      color: const Color(0xFF1A1A1A),
                      width: 20,
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    Get.to(const SearchMessageListPage());
                  },
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
                        Icon(Icons.search,
                            color: Color(0xFF8A8A8E), size: 20),
                        SizedBox(width: 6),
                        Text("搜索",
                            style: TextStyle(
                                fontSize: 15, color: Color(0xFF8A8A8E)))
                      ],
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
                  child: Column(
                    children: [
                      SizedBox(
                        height: 52,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFFFF9500).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                child: const Icon(
                                  Icons.person_add_alt_1,
                                  size: 18,
                                  color: Color(0xFFFF9500),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: SizedBox(
                                  child: Text(
                                    "新朋友",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF1A1A1A)),
                                  ),
                                ),
                              ),
                              SvgPicture.asset(
                                  "assets/svg/chevronright.svg",
                                  height: 18,
                                  color: const Color(0xFFC7C7CC)),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 60),
                        child: Divider(
                          thickness: 0.3,
                          height: 1,
                          color: Colors.grey.withOpacity(0.2),
                        ),
                      ),
                      SizedBox(
                        height: 52,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFF34C759).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                child: const Icon(
                                  Icons.group,
                                  size: 18,
                                  color: Color(0xFF34C759),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: SizedBox(
                                  child: Text(
                                    "群通知",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF1A1A1A)),
                                  ),
                                ),
                              ),
                              SvgPicture.asset(
                                  "assets/svg/chevronright.svg",
                                  height: 18,
                                  color: const Color(0xFFC7C7CC)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
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
                  child: TabBar(
                    isScrollable: true,
                    dividerColor: Colors.transparent,
                    labelColor: const Color(0xFF12B7F5),
                    unselectedLabelColor: const Color(0xFF8A8A8E),
                    indicatorColor: const Color(0xFF12B7F5),
                    indicatorWeight: 3,
                    overlayColor:
                        const MaterialStatePropertyAll(Colors.transparent),
                    automaticIndicatorColorAdjustment: false,
                    labelStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorPadding:
                        const EdgeInsets.symmetric(horizontal: 4),
                    tabAlignment: TabAlignment.start,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    tabs: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Tab(text: "好友"),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Tab(text: "分组"),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Tab(text: "群聊"),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Tab(text: "设备"),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Tab(text: "通讯录"),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Tab(text: "订阅号"),
                      ),
                    ],
                    controller: tabController,
                  ),
                ),
                const SizedBox(height: 16),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
