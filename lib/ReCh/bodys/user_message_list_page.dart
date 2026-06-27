import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rech/ReCh/message_details_page.dart';
import 'package:rech/ReCh/model/msg_model.dart';
import 'package:rech/ReCh/search_message_list_page.dart';
import 'package:rech/ReCh/user_option_page.dart';
import 'package:rech/ReCh/create_group_page.dart';
import 'package:rech/ReCh/scan_page.dart';
import 'package:rech/ReCh/widget/appbar.dart';
import 'package:rech/ReCh/widget/bitmeun.dart';
import 'package:rech/models/user_model.dart';
import 'package:rech/states/app_state.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
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
    // TODO: 从服务端获取真实消息列表数据
    setState(() {
      loading = true;
    });
  }

  void _showStatusMenu() {
    final appState = Provider.of<AppState>(context, listen: false);
    final currentStatus = appState.currentUser?.onlineStatus ?? onlineStatusOnline;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Text(
                        "我的状态",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _buildStatusItem(onlineStatusOnline, "在线", "我在线上",
                    Icons.circle, const Color(0xFF22C55E), currentStatus),
                _buildStatusItem(onlineStatusAway, "离开", "暂时不在",
                    Icons.schedule, const Color(0xFFFF9500), currentStatus),
                _buildStatusItem(onlineStatusBusy, "忙碌", "正在忙",
                    Icons.work_outline, const Color(0xFFFF3B30), currentStatus),
                _buildStatusItem(
                    onlineStatusDoNotDisturb,
                    "勿扰",
                    "消息免打扰",
                    Icons.do_not_disturb_on_outlined,
                    const Color(0xFF8E8E93),
                    currentStatus),
                _buildStatusItem(onlineStatusInvisible, "隐身", "对所有人隐身",
                    Icons.visibility_off_outlined, const Color(0xFF5856D6), currentStatus),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusItem(int status, String title, String subtitle,
      IconData icon, Color color, int currentStatus) {
    final isSelected = status == currentStatus;
    return GestureDetector(
      onTap: () async {
        Navigator.pop(context);
        final appState = Provider.of<AppState>(context, listen: false);
        await appState.updateOnlineStatus(status);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF8A8A8E),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF22C55E),
                size: 22,
              ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(int status) {
    switch (status) {
      case onlineStatusOnline:
        return const Color(0xFF22C55E);
      case onlineStatusAway:
        return const Color(0xFFFF9500);
      case onlineStatusBusy:
        return const Color(0xFFFF3B30);
      case onlineStatusDoNotDisturb:
        return const Color(0xFF8E8E93);
      case onlineStatusInvisible:
        return const Color(0xFF5856D6);
      default:
        return const Color(0xFF8E8E93);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double top = MediaQuery.of(context).padding.top;

    return Consumer<AppState>(
      builder: (context, appState, child) {
        final user = appState.currentUser;
        final onlineStatus = user?.onlineStatus ?? onlineStatusOnline;
        final statusText = getOnlineStatusText(onlineStatus);
        final statusColor = _getStatusColor(onlineStatus);
        final devices = appState.devices.where((d) => d.isOnline).toList();

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
                        child: user?.avatar != null && user!.avatar.isNotEmpty
                            ? ExtendedImage.network(
                                user.avatar,
                                alignment: Alignment.topCenter,
                                fit: BoxFit.cover,
                                width: 44,
                                height: 44,
                              )
                            : Image.asset(
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
                      Text(
                        user?.nickname ?? "7_bit",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      GestureDetector(
                        onTap: _showStatusMenu,
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: statusColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: statusColor.withOpacity(0.5),
                                    blurRadius: 4,
                                    spreadRadius: 1,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "$statusText-WIFI",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF8A8A8E),
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.keyboard_arrow_down,
                              size: 14,
                              color: Color(0xFF8A8A8E),
                            ),
                          ],
                        ),
                      ),
                      if (devices.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            SvgPicture.asset(
                              "assets/svg/Monitor.svg",
                              height: 10,
                              color: const Color(0xFF8A8A8E),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              devices.first.deviceName.isNotEmpty
                                  ? devices.first.deviceName
                                  : getDeviceTypeName(devices.first.deviceType),
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF8A8A8E),
                              ),
                            ),
                            if (devices.length > 1)
                              Text(
                                " 等${devices.length}台设备",
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF8A8A8E),
                                ),
                              ),
                          ],
                        ),
                      ],
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
                child: loading
                    ? Column(
                        children: [

                          ...List.generate(data.length, (index) {
                            return Column(
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      Get.to(
                                          MessageDetailsPage(
                                              msgModel: data[index]),
                                          transition:
                                              Transition.rightToLeft);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 10),
                                      child: msgItem1(data[index]),
                                    )),
                                if (index != data.length - 1)
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(left: 78),
                                    child: Divider(
                                      thickness: 0.3,
                                      color: Colors.grey.withOpacity(0.2),
                                      height: 1,
                                    ),
                                  ),
                              ],
                            );
                          }),
                        ],
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
              ),
            ],
          ),
        );
      },
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
