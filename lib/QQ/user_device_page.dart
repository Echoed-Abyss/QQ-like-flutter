// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_qq/QQ/widget/appbar.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserDevicePage extends StatefulWidget {
  const UserDevicePage({super.key});

  @override
  State<UserDevicePage> createState() => _UserDevicePageState();
}

class _UserDevicePageState extends State<UserDevicePage> {
  late bool checkboxValue = false;
  late bool cupertinoSwitchValue = true;

  @override
  Widget build(BuildContext context) {
    double top = MediaQuery.of(context).padding.top;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: StudyAppBar.MyAppBar(
        "已登录设备",
        context,
        toolbarHeight: top + 20,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        textStyle: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Image.asset(
            "assets/images/Eclipse (1).png",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        "assets/images/bit7.jpg",
                        fit: BoxFit.cover,
                        height: 72,
                        width: 72,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "7_bit",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 0.5,
                          ),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 32),
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: const Color(0xFF12B7F5).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  "assets/svg/airplay.svg",
                                  color: const Color(0xFF12B7F5),
                                  width: 32,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "QQ Windows版",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "ZY-PC",
                              style: TextStyle(
                                color: Color(0xFF8A8A8E),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 32),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  checkboxValue = !checkboxValue;
                                });
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: Checkbox(
                                      value: checkboxValue,
                                      checkColor: Colors.white,
                                      fillColor: const MaterialStatePropertyAll(
                                          Color(0xFF12B7F5)),
                                      overlayColor:
                                          const MaterialStatePropertyAll(
                                              Colors.transparent),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      onChanged: (boo) {},
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    "下次登录无需手机登录",
                                    style: TextStyle(
                                      color: Color(0xFF8A8A8E),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 32),
                            Divider(
                              thickness: 0.3,
                              height: 1,
                              color: Colors.grey.withOpacity(0.2),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      height: 56,
                                      alignment: Alignment.center,
                                      child: const Text(
                                        "传文件",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF12B7F5),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 0.5,
                                  height: 24,
                                  color: Colors.grey.withOpacity(0.2),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      height: 56,
                                      alignment: Alignment.center,
                                      child: const Text(
                                        "退出登录",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFFFF3B30),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 0.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    "手机通知",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1A1A1A),
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    "关闭后，手机上收到消息不提醒",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF8A8A8E),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              activeTrackColor: const Color(0xFF12B7F5),
                              activeColor: Colors.white,
                              value: cupertinoSwitchValue,
                              onChanged: (value) {
                                setState(() {
                                  cupertinoSwitchValue = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
