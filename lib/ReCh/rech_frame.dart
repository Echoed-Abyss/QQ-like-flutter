// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rech/ReCh/bodys/user_contacts_list_page.dart';
import 'package:rech/ReCh/bodys/user_message_list_page.dart';
import 'package:rech/ReCh/user_option_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ReChFrame extends StatefulWidget {
  const ReChFrame({super.key});

  @override
  State<ReChFrame> createState() => _ReChFrameState();
}

class _ReChFrameState extends State<ReChFrame> with AutomaticKeepAliveClientMixin {
  int index = 0;
  List<Widget> pages = const [
    UserMessageListPage(),
    UserContactsListPage(),
  ];

  double _dragStartX = 0;
  bool _isEdgeSwipe = false;

  void _onDragStart(DragStartDetails details) {
    _dragStartX = details.globalPosition.dx;
    _isEdgeSwipe = _dragStartX < 30;
  }

  void _onDragEnd(DragEndDetails details) {
    if (_isEdgeSwipe && details.primaryVelocity != null && details.primaryVelocity! > 500) {
      Get.to(const UserOptionPage(), transition: Transition.leftToRight);
    }
    _isEdgeSwipe = false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      extendBody: true,
      body: GestureDetector(
        onHorizontalDragStart: _onDragStart,
        onHorizontalDragEnd: _onDragEnd,
        behavior: HitTestBehavior.translucent,
        child: IndexedStack(
          index: index,
          children: pages,
        ),
      ),
      bottomNavigationBar: RepaintBoundary(
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.withOpacity(0.1),
                    width: 0.5,
                  ),
                ),
              ),
              child: BottomNavigationBar(
                elevation: 0,
                selectedItemColor: const Color(0xFF12B7F5),
                unselectedItemColor: const Color(0xFF8A8A8E),
                backgroundColor: Colors.transparent,
                currentIndex: index,
                type: BottomNavigationBarType.fixed,
                selectedLabelStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                onTap: (value) {
                  if (value != index) {
                    setState(() {
                      index = value;
                    });
                  }
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: SvgPicture.asset(
                        "assets/svg/Chat.svg",
                        color: index == 0
                            ? const Color(0xFF12B7F5)
                            : const Color(0xFF8A8A8E),
                        height: 24,
                      ),
                    ),
                    label: "消息",
                  ),
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: SvgPicture.asset(
                        "assets/svg/User_01.svg",
                        color: index == 1
                            ? const Color(0xFF12B7F5)
                            : const Color(0xFF8A8A8E),
                        height: 24,
                      ),
                    ),
                    label: "联系人",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
