// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rech/ReCh/widget/appbar.dart';
import 'package:rech/ReCh/widget/serach_field.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SearchMessageListPage extends StatefulWidget {
  const SearchMessageListPage({super.key});

  @override
  State<SearchMessageListPage> createState() => _SearchMessageListPageState();
}

class _SearchMessageListPageState extends State<SearchMessageListPage>
    with AutomaticKeepAliveClientMixin {
  final List<Map<String, String>> _searchCategories = const [
    {'icon': 'User-plus', 'label': '找人/群', 'color': '0xFFFF9500'},
    {'icon': 'Group 151', 'label': '表情', 'color': '0xFF5856D6'},
    {'icon': 'ReCh', 'label': '小程序', 'color': '0xFF34C759'},
    {'icon': 'Expand', 'label': '扫一扫', 'color': '0xFF007AFF'},
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double top = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: StudyAppBar.MyAppBar(
        "",
        context,
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leading: const SizedBox(),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(
          children: [
            SizedBox(height: top + 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Hero(
                tag: "Search",
                child: Row(
                  children: [
                    Expanded(
                      child: BLMSerachField(
                        "搜索",
                        "colse",
                        TextEditingController(),
                        autofocus: true,
                        icon: const Icon(Icons.search, color: Color(0xFF8A8A8E)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: const Text(
                        "取消",
                        style: TextStyle(
                          color: Color(0xFF12B7F5),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
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
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "搜索指定内容",
                          style: TextStyle(
                            color: Color(0xFF8A8A8E),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),
                        GridView.builder(
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 12,
                          ),
                          itemCount: _searchCategories.length,
                          itemBuilder: (context, index) {
                            final item = _searchCategories[index];
                            return _buildGridItem(
                              item['icon']!,
                              item['label']!,
                              Color(int.parse(item['color']!)),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(String svg, String text, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: SvgPicture.asset(
              "assets/svg/$svg.svg",
              color: color,
              width: 24,
              height: 24,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
