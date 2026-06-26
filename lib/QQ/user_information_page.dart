// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qq/QQ/widget/appbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

class UserInformationPage extends StatefulWidget {
  const UserInformationPage({super.key});

  @override
  State<UserInformationPage> createState() => _UserInformationPageState();
}

class _UserInformationPageState extends State<UserInformationPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  double imageheight = 200;

  double extrapicHeight = 0;

  double dy = 0;

  late AnimationController animatedContainer;

  late Animation<double> animation;

  List<String> imageurl = [];

  late int count = 1024;

  late Animation<double> countAnimation;

  late double counticon = 18;

  late AnimationController countanimatedContainer;

  void updateHeight(double position) {
    if (dy == 0) {
      dy = position;
    }
    var extrapicHeight1 = extrapicHeight + position - dy;
    if (extrapicHeight1 <= -150 || extrapicHeight1 >= 200) {
      return;
    }
    extrapicHeight += position - dy;
    setState(() {
      dy = position;
      extrapicHeight = extrapicHeight;
    });
  }

  void runAnimate() {
    setState(() {
      animation =
          Tween(begin: extrapicHeight, end: .0).animate(animatedContainer)
            ..addListener(() {
              setState(() {
                extrapicHeight = animation.value;
              });
            });
      dy = 0;
    });
  }

  @override
  void initState() {
    super.initState();
    animatedContainer = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    countanimatedContainer = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    animation = Tween(begin: 0.0, end: 0.0).animate(animatedContainer);
    List.generate(13, (index) {
      imageurl.add("assets/images/${index + 1}.png");
    });
    countAnimation =
        Tween(begin: 1.0, end: 1.2).animate(countanimatedContainer);
  }

  @override
  void dispose() {
    if (mounted) {
      animatedContainer.dispose();
      countanimatedContainer.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
          updateHeight(event.position.dy / 2);
        },
        onPointerUp: (value) {
          runAnimate();
          animatedContainer.forward(from: .0);
        },
        child: Stack(
          children: [
            GestureDetector(
                onTap: () {
                  showDialog(
                      builder: (BuildContext context) {
                        return const DetailPage("assets/images/dao.jpg");
                      },
                      context: context);
                },
                child: ExtendedImage.asset(
                  "assets/images/dao.jpg",
                  height: imageheight + extrapicHeight,
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
                      return Shimmer.fromColors(
                          baseColor: const Color.fromARGB(255, 240, 240, 240),
                          highlightColor: Colors.white,
                          child: Container(
                            height: imageheight,
                            width: double.infinity,
                            color: Colors.white,
                          ));
                    }
                    return null;
                  },
                )
                //  Image.asset(
                //   "assets/images/dao.jpg",
                //   height: imageheight + extrapicHeight,
                //   fit: BoxFit.cover,
                //   width: double.infinity,
                // )
                //  Shimmer.fromColors(
                //   baseColor: Colors.red.withOpacity(.1),
                //   highlightColor: Colors.yellow,
                //   child: Image.asset(
                //     "assets/images/dao.jpg",
                //     height: imageheight + extrapicHeight,
                //     fit: BoxFit.cover,
                //     width: double.infinity,
                //   )),
                ),
            ListView(
              padding: EdgeInsets.zero,
              children: [
                SizedBox(
                  height: imageheight - 30 + extrapicHeight,
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
                      Column(
                        children: [
                          const SizedBox(height: 16),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                    builder:
                                                        (BuildContext context) {
                                                      return const DetailPage(
                                                          "assets/images/bit7.jpg");
                                                    },
                                                    context: context);
                                              },
                                              child: Hero(
                                                tag: "assets/images/bit7.jpg",
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.1),
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
                                                      width: 72,
                                                      height: 72,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 14),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Shimmer.fromColors(
                                                  baseColor:
                                                      const Color(0xFF1A1A1A),
                                                  highlightColor:
                                                      const Color(0xFFFF3B30),
                                                  child: const Text(
                                                    "7_bit",
                                                    style: TextStyle(
                                                      fontSize: 19,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Color(0xFF1A1A1A),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                const Text.rich(
                                                  TextSpan(children: [
                                                    TextSpan(
                                                      text: "QQ号：210014468",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFF8A8A8E)),
                                                    ),
                                                    TextSpan(
                                                        text: " (ID：BitSeven)",
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFF8A8A8E))),
                                                  ]),
                                                  style: TextStyle(fontSize: 12),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                countanimatedContainer.repeat(
                                                    reverse: true);
                                              },
                                              child: ScaleTransition(
                                                scale: countAnimation,
                                                child: Container(
                                                  width: 36,
                                                  height: 36,
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFFFF3B30)
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Center(
                                                    child: SvgPicture.asset(
                                                      "assets/svg/favorite.svg",
                                                      width: 20,
                                                      color: const Color(
                                                          0xFFFF3B30),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              "$count",
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF8A8A8E),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Divider(
                                      thickness: 0.3,
                                      height: 1,
                                      color: Colors.grey.withOpacity(0.2),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 52,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 28,
                                            height: 28,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF007AFF)
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: const Icon(
                                              Icons.male,
                                              color: Color(0xFF007AFF),
                                              size: 16,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          const Expanded(
                                            child: Text.rich(
                                              TextSpan(children: [
                                                TextSpan(
                                                    text: "男",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFF1A1A1A))),
                                                TextSpan(
                                                    text: " | ",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFFC7C7CC))),
                                                TextSpan(
                                                    text: "1024岁",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFF1A1A1A))),
                                                TextSpan(
                                                    text: " | ",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFFC7C7CC))),
                                                TextSpan(
                                                    text: "巨蟹座",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFF1A1A1A))),
                                                TextSpan(
                                                    text: " | ",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFFC7C7CC))),
                                                TextSpan(
                                                    text: "来自中国",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFF1A1A1A))),
                                                TextSpan(
                                                    text: " | ",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFFC7C7CC))),
                                                TextSpan(
                                                    text: "IT",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFF1A1A1A))),
                                              ]),
                                              style: TextStyle(fontSize: 14),
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
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Divider(
                                      thickness: 0.3,
                                      height: 1,
                                      color: Colors.grey.withOpacity(0.2),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 52,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Row(
                                        children: [
                                          const Expanded(
                                            child: Text(
                                              "sex robot",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFF1A1A1A),
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          SvgPicture.asset(
                                            "assets/svg/edit.svg",
                                            height: 14,
                                            color: const Color(0xFFC7C7CC),
                                          ),
                                          const SizedBox(width: 4),
                                          SvgPicture.asset(
                                            "assets/svg/chevronright.svg",
                                            height: 18,
                                            color: const Color(0xFFC7C7CC),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              height: 52,
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 28,
                                          height: 28,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFF9500)
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Center(
                                            child: SvgPicture.asset(
                                              "assets/svg/document 1.svg",
                                              width: 16,
                                              color:
                                                  const Color(0xFFFF9500),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        const Expanded(
                                          child: Text(
                                            "资料完成度80%",
                                            style: TextStyle(
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
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 16),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 28,
                                              height: 28,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFFFCC00)
                                                    .withOpacity(0.15),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Center(
                                                child: SvgPicture.asset(
                                                  "assets/svg/Star.svg",
                                                  width: 16,
                                                  color:
                                                      const Color(0xFFFFB800),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            const Expanded(
                                              child: Text(
                                                "QQ空间",
                                                style: TextStyle(
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
                                          const Text(
                                            "分享新鲜事",
                                            style: TextStyle(
                                              color: Color(0xFF12B7F5),
                                              fontSize: 14,
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
                                  ),
                                  const SizedBox(height: 14),
                                  SizedBox(
                                    height: 100,
                                    width: double.infinity,
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (c, i) {
                                        return GestureDetector(
                                          onTap: () {
                                            showDialog(
                                                builder:
                                                    (BuildContext context) {
                                                  return DetailPage(
                                                      imageurl[i]);
                                                },
                                                context: context);
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: ExtendedImage.asset(
                                              imageurl[i],
                                              height: 100,
                                              width: 100,
                                              fit: BoxFit.cover,
                                              loadStateChanged: (state) {
                                                if (state
                                                        .extendedImageLoadState ==
                                                    LoadState.loading) {
                                                  return Container(
                                                      color: Colors.white,
                                                      height: 100,
                                                      width: 100);
                                                } else if (state
                                                        .extendedImageLoadState ==
                                                    LoadState.failed) {
                                                  return Container(
                                                      color: Colors.white,
                                                      height: 100,
                                                      width: 100);
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: imageurl.length,
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return const SizedBox(
                                          width: 8,
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 28,
                                              height: 28,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF5856D6)
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Center(
                                                child: SvgPicture.asset(
                                                  "assets/svg/More_Grid_Big.svg",
                                                  width: 16,
                                                  color:
                                                      const Color(0xFF5856D6),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            const Expanded(
                                              child: Text(
                                                "精选照片",
                                                style: TextStyle(
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
                                          const Text(
                                            "添加精美照片、展示个性的你",
                                            style: TextStyle(
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
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 100),
                                  const SizedBox(height: 30),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
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
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

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
}

class DetailPage extends StatefulWidget {
  const DetailPage(this.url, {super.key});
  final String url;
  @override
  State<DetailPage> createState() => _NewDetailPageState();
}

class _NewDetailPageState extends State<DetailPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: ExtendedImageSlidePage(
        slideAxis: SlideAxis.both,
        slideType: SlideType.onlyImage,
        slidePageBackgroundHandler: (offset, pageSize) {
          return Colors.transparent;
        },
        resetPageDuration: const Duration(milliseconds: 200),
        child: ExtendedImageGesturePageView(
          children: [
            ExtendedImage.asset(
              widget.url,
              fit: BoxFit.contain,
              enableSlideOutPage: true,
              heroBuilderForSlidingPage: (image) => Hero(
                tag: widget.url,
                flightShuttleBuilder: (
                  flightContext,
                  animation,
                  flightDirection,
                  fromHeroContext,
                  toHeroContext,
                ) {
                  final hero = (flightDirection == HeroFlightDirection.pop
                      ? fromHeroContext.widget
                      : toHeroContext.widget) as Hero;
                  return hero.child;
                },
                child: image,
              ),
              mode: ExtendedImageMode.gesture,
              initGestureConfigHandler: (s) {
                return GestureConfig(
                    minScale: 0.9,
                    animationMinScale: 0.7,
                    maxScale: 5.0,
                    animationMaxScale: 5.5,
                    speed: 1.0,
                    inertialSpeed: 100.0,
                    initialScale: 1.0,
                    inPageView: false);
              },
              loadStateChanged: (state) {
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
