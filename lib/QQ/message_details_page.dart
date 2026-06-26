// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qq/QQ/model/msg_model.dart';
import 'package:flutter_qq/QQ/model/user_send_user_msg_model.dart';
import 'package:flutter_qq/QQ/widget/serach_field.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class MessageDetailsPage extends StatefulWidget {
  const MessageDetailsPage({super.key, required this.msgModel});
  final MsgModel msgModel;

  @override
  State<MessageDetailsPage> createState() => _MessageDetailsPageState();
}

class _MessageDetailsPageState extends State<MessageDetailsPage> {
  late TextEditingController textEditingController = TextEditingController();
  late bool displaySend = false;
  late String me =
      "https://foruda.gitee.com/avatar/1677180609201628769/9580418_zhangnull_1639032531.png";
  late List<UserSendUserMsgModel> msgs = [];

  void addData() {
    msgs.add(UserSendUserMsgModel(
      imageurl: widget.msgModel.imageurl,
      role: "you",
      msg: '可以把',
    ));
    msgs.add(UserSendUserMsgModel(
        imageurl: widget.msgModel.imageurl,
        msg: 'https://w.wallhaven.cc/full/zy/wallhaven-zyvg1j.png',
        role: "you",
        type: "image"));

    msgs.add(UserSendUserMsgModel(
        imageurl: widget.msgModel.imageurl,
        msg: 'https://w.wallhaven.cc/full/d6/wallhaven-d6vp7m.jpg',
        role: "you",
        type: "image"));
    msgs.add(UserSendUserMsgModel(
      imageurl: me,
      msg: '来点摄图',
    ));
    msgs.add(UserSendUserMsgModel(
      imageurl: me,
      msg: '你配个机霸',
    ));
    msgs.add(UserSendUserMsgModel(
        imageurl: me,
        msg: 'https://w.wallhaven.cc/full/7p/wallhaven-7pxx99.png',
        type: "image"));

    msgs.add(UserSendUserMsgModel(
        imageurl: widget.msgModel.imageurl,
        msg: '感觉我这种臭鱼烂虾进去要坐大牢',
        role: "you"));
    msgs.add(UserSendUserMsgModel(
        imageurl: widget.msgModel.imageurl, msg: '这里的invoke没有啊', role: "you"));
    msgs.add(UserSendUserMsgModel(
        imageurl: widget.msgModel.imageurl,
        msg:
            '我的识别码:364819064使用向日葵即可对我发起远程协助向日葵下载地址:http://url.oray.com/tGJdas/',
        role: "you"));
    msgs.add(UserSendUserMsgModel(
        imageurl: widget.msgModel.imageurl, msg: '谢谢你，大屌侠', role: "you"));

    msgs.add(UserSendUserMsgModel(
      imageurl: me,
      msg: '所以说，点不出来就等于没有吗',
    ));
    msgs.add(UserSendUserMsgModel(
      imageurl: me,
      msg: '眼睛不要可以捐了',
    ));
    msgs.add(UserSendUserMsgModel(
        imageurl: widget.msgModel.imageurl, msg: '唉，我是傻逼！', role: "you"));
    msgs.add(UserSendUserMsgModel(
        imageurl: widget.msgModel.imageurl, msg: '我感觉这些东西我不太配', role: "you"));
    msgs.add(UserSendUserMsgModel(
        imageurl: widget.msgModel.imageurl,
        msg: '我真的他妈的开始找的时候有点心虚了',
        role: "you"));
    msgs.add(UserSendUserMsgModel(
        imageurl: widget.msgModel.imageurl, msg: '我感觉我不配', role: "you"));
    msgs.add(UserSendUserMsgModel(
      imageurl: me,
      msg: '你行个机霸',
    ));
    msgs.add(UserSendUserMsgModel(
        imageurl: widget.msgModel.imageurl, msg: '我得问问啥情况', role: "you"));
    msgs.add(UserSendUserMsgModel(
        imageurl: widget.msgModel.imageurl, msg: '我感觉我真不太行', role: "you"));
  }

  late bool isdisplay = false;
  late double height = 0;
  late ScrollController scrollController = ScrollController();
  FocusNode focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    addData();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        displaySend = true;
        if (isdisplay) {
          height = 0;
        }
        setState(() {});
      }
    });
    scrollController.addListener(() {
      if (scrollController.offset < -130) {
        FocusScope.of(context).requestFocus(focusNode);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            child: Container(
              color: Colors.white.withOpacity(0.8),
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: IconButton(
                    style: const ButtonStyle(
                      overlayColor:
                          MaterialStatePropertyAll(Colors.transparent),
                    ),
                    icon: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 18,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    onPressed: () => Get.back(),
                  ),
                ),
                leadingWidth: 56,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.msgModel.name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: const Color(0xFF22C55E),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    const Color(0xFF22C55E).withOpacity(0.5),
                                blurRadius: 3,
                                spreadRadius: 0.5,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(3.5),
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          "手机在线 - 4G",
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF8A8A8E),
                          ),
                        )
                      ],
                    )
                  ],
                ),
                actions: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {},
                    icon: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.qr_code_scanner,
                        color: Color(0xFF1A1A1A),
                        size: 18,
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
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.more_horiz,
                        color: Color(0xFF1A1A1A),
                        size: 20,
                      ),
                    ),
                    style: const ButtonStyle(
                        padding: MaterialStatePropertyAll(EdgeInsets.zero)),
                  ),
                  const SizedBox(width: 12),
                ],
              ),
            ),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const SizedBox(height: 60),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (isdisplay) {
                    isdisplay = !isdisplay;
                    height = 0;
                  }
                  displaySend = textEditingController.text.isNotEmpty;
                  if (mounted) setState(() {});
                },
                child: ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  reverse: true,
                  shrinkWrap: true,
                  controller: scrollController,
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  itemCount: msgs.length,
                  itemBuilder: (context, index) {
                    return DefaultTextStyle(
                        style: const TextStyle(
                            fontSize: 15, color: Color(0xFF1A1A1A)),
                        child: item(msgs[index]));
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 16);
                  },
                ),
              ),
            ),
            ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                child: Container(
                  color: Colors.white.withOpacity(0.85),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.mic_none_outlined,
                          size: 20,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: BLMSerachField(
                          "",
                          "colse",
                          textEditingController,
                          autofocus: false,
                          textInputType: TextInputType.text,
                          focusNode: focusNode,
                          onSubmitted: (p0) {
                            if (p0.isEmpty) return;
                            msgs.insert(0,
                                UserSendUserMsgModel(imageurl: me, msg: p0));
                            textEditingController.clear();
                            Future.delayed(const Duration(seconds: 2), () {
                              msgs.insert(
                                  0,
                                  UserSendUserMsgModel(
                                      imageurl: widget.msgModel.imageurl,
                                      role: "you",
                                      msg:
                                          "${widget.msgModel.name}:$p0"));
                              setState(() {});
                            });
                            setState(() {});
                          },
                          onchange: (text) {
                            displaySend =
                                textEditingController.text.isNotEmpty;
                            if (mounted) setState(() {});
                          },
                          backgrund: const Color(0xFFF2F3F5),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            "assets/svg/Star-Struck.svg",
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      !displaySend
                          ? GestureDetector(
                              onTap: () {
                                isdisplay = !isdisplay;
                                if (isdisplay) {
                                  height = 300;
                                  scrollController.animateTo(-20,
                                      curve: Curves.ease,
                                      duration:
                                          const Duration(milliseconds: 500));
                                } else {
                                  height = 0;
                                }
                                setState(() {});
                              },
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: isdisplay
                                      ? const Color(0xFF12B7F5)
                                          .withOpacity(0.1)
                                      : Colors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    "assets/svg/Add_Plus_Circle.svg",
                                    color: isdisplay
                                        ? const Color(0xFF12B7F5)
                                        : const Color(0xFF1A1A1A),
                                    width: 20,
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(
                              width: 64,
                              height: 36,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (textEditingController.text.isEmpty)
                                    return;
                                  msgs.insert(
                                      0,
                                      UserSendUserMsgModel(
                                          imageurl: me,
                                          msg:
                                              textEditingController.text));
                                  String youtext =
                                      textEditingController.text;
                                  textEditingController.clear();

                                  scrollController.animateTo(0,
                                      curve: Curves.ease,
                                      duration: const Duration(
                                          milliseconds: 300));
                                  Future.delayed(
                                      const Duration(seconds: 2), () {
                                    msgs.insert(
                                        0,
                                        UserSendUserMsgModel(
                                            imageurl:
                                                widget.msgModel.imageurl,
                                            role: "you",
                                            msg:
                                                "${widget.msgModel.name}:$youtext"));
                                    setState(() {});
                                  });

                                  setState(() {});
                                },
                                style: ButtonStyle(
                                    padding:
                                        const MaterialStatePropertyAll(
                                            EdgeInsets.zero),
                                    shape: MaterialStatePropertyAll(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10),
                                      ),
                                    ),
                                    backgroundColor:
                                        MaterialStatePropertyAll(
                                            const Color(0xFF12B7F5))),
                                child: const Text(
                                  "发送",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
            AnimatedContainer(
                height: height,
                color: Colors.white.withOpacity(0.9),
                padding: const EdgeInsets.only(top: 24),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                child: StaggeredGrid.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: 24,
                  crossAxisSpacing: 4,
                  children: [
                    myDisplayItem(svg: 'picture', name: '相册'),
                    myDisplayItem(svg: 'folder', name: '文件'),
                    myDisplayItem(svg: 'upload 1', name: '微云'),
                    myDisplayItem(svg: 'bookmark', name: '收藏'),
                    myDisplayItem(svg: 'desktop 1', name: '我的电脑'),
                    myDisplayItem(svg: 'tethering 1', name: '王卡'),
                    myDisplayItem(svg: 'controller 1', name: '游戏中心'),
                    myDisplayItem(svg: 'QQ', name: 'QQ'),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  Widget item(UserSendUserMsgModel userMsgModel) {
    double width = MediaQuery.sizeOf(Get.context!).width * 0.72;
    Widget loadingWidget = Shimmer.fromColors(
        baseColor: const Color(0xFFE8E8E8),
        highlightColor: Colors.white,
        child: Container(
          height: 36,
          width: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFE8E8E8),
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    return userMsgModel.role == "i"
        ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              userMsgModel.type == "text"
                  ? Container(
                      constraints: BoxConstraints(maxWidth: width),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF12B7F5),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(18),
                          topRight: Radius.circular(6),
                          bottomLeft: Radius.circular(18),
                          bottomRight: Radius.circular(18),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF12B7F5)
                                .withOpacity(0.15),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        userMsgModel.msg,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          height: 1.4,
                        ),
                      ))
                  : GestureDetector(
                      onTap: () {
                        showDialog(
                            builder: (BuildContext context) {
                              return DetailPage(userMsgModel.msg);
                            },
                            context: context);
                      },
                      child: Container(
                        constraints: BoxConstraints(maxWidth: width),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: ExtendedImage.network(
                            userMsgModel.msg,
                            cache: true,
                            loadStateChanged: (state) {
                              if (state.extendedImageLoadState ==
                                  LoadState.loading) {
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
                    ),
              const SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: ExtendedImage.network(
                      userMsgModel.imageurl,
                      cache: true,
                      width: 38,
                      height: 38,
                      fit: BoxFit.cover,
                      loadStateChanged: (state) {
                        if (state.extendedImageLoadState ==
                            LoadState.loading) {
                          return loadingWidget;
                        } else if (state.extendedImageLoadState ==
                            LoadState.failed) {
                          return loadingWidget;
                        }
                        return null;
                      },
                    )),
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: ExtendedImage.network(
                      userMsgModel.imageurl,
                      cache: true,
                      width: 38,
                      height: 38,
                      fit: BoxFit.cover,
                      loadStateChanged: (state) {
                        if (state.extendedImageLoadState ==
                            LoadState.loading) {
                          return loadingWidget;
                        } else if (state.extendedImageLoadState ==
                            LoadState.failed) {
                          return loadingWidget;
                        }
                        return null;
                      },
                    )),
              ),
              const SizedBox(width: 10),
              userMsgModel.type == "text"
                  ? Container(
                      constraints: BoxConstraints(maxWidth: width),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(18),
                          bottomLeft: Radius.circular(18),
                          bottomRight: Radius.circular(18),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        userMsgModel.msg,
                        style: const TextStyle(
                          color: Color(0xFF1A1A1A),
                          fontSize: 15,
                          height: 1.4,
                        ),
                      ))
                  : GestureDetector(
                      onTap: () {
                        showDialog(
                            builder: (BuildContext context) {
                              return DetailPage(userMsgModel.msg);
                            },
                            context: context);
                      },
                      child: Container(
                        constraints: BoxConstraints(maxWidth: width),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: ExtendedImage.network(
                            userMsgModel.msg,
                            cache: true,
                            loadStateChanged: (state) {
                              if (state.extendedImageLoadState ==
                                  LoadState.loading) {
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
                    )
            ],
          );
  }
}

Widget myDisplayItem({required String svg, required String name}) {
  return SizedBox(
    child: Column(children: [
      Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: SvgPicture.asset(
            "assets/svg/$svg.svg",
            width: 24,
            color: const Color(0xFF1A1A1A),
          ),
        ),
      ),
      const SizedBox(height: 8),
      Text(name,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF8A8A8E),
          ))
    ]),
  );
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
            ExtendedImage.network(
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
