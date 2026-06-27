import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rech/ReCh/model/msg_model.dart';
import 'package:rech/ReCh/user_information_page.dart';
import 'package:rech/ReCh/widget/serach_field.dart';
import 'package:rech/models/user_model.dart';
import 'package:rech/services/api_service.dart';
import 'package:rech/services/tcp_service.dart';
import 'package:rech/states/app_state.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class MessageDetailsPage extends StatefulWidget {
  const MessageDetailsPage({
    super.key,
    required this.msgModel,
    this.sessionType = sessionTypePrivate,
    this.sessionId = 0,
  });
  final MsgModel msgModel;
  final int sessionType;
  final int sessionId;

  @override
  State<MessageDetailsPage> createState() => _MessageDetailsPageState();
}

class _MessageDetailsPageState extends State<MessageDetailsPage> {
  late TextEditingController textEditingController = TextEditingController();
  late bool displaySend = false;
  late List<MessageModel> messages = [];
  late bool isLoading = false;
  late int currentUserId = 0;

  bool isdisplay = false;
  double height = 0;
  late ScrollController scrollController = ScrollController();
  FocusNode focusNode = FocusNode();

  bool showEmoji = false;
  double emojiHeight = 0;

  int? longPressMsgId;
  bool showMenu = false;
  double menuDy = 0;
  double menuDx = 0;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _loadMessages();
    _listenTcpMessages();

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        displaySend = true;
        if (isdisplay) {
          height = 0;
          isdisplay = false;
        }
        if (showEmoji) {
          showEmoji = false;
          emojiHeight = 0;
        }
        setState(() {});
      }
    });
  }

  void _loadCurrentUser() {
    final appState = Provider.of<AppState>(context, listen: false);
    currentUserId = appState.currentUser?.id ?? 0;
  }

  Future<void> _loadMessages() async {
    if (widget.sessionId == 0) {
      _loadMockMessages();
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      final response = await ApiService().getMessageList(
        sessionType: widget.sessionType,
        sessionId: widget.sessionId,
      );
      if (response.isSuccess && response.data != null) {
        final list = response.data!['list'] as List? ?? [];
        messages = list
            .map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      _loadMockMessages();
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _loadMockMessages() {
    messages = [];
  }

  void _listenTcpMessages() {
    TcpService().messageStream.listen((data) {
      final type = data['type'];
      if (type == 'new_message') {
        final content = data['content'];
        if (content != null && content is Map<String, dynamic>) {
          final msg = MessageModel.fromJson(content);
          if (msg.sessionId == widget.sessionId &&
              msg.sessionType == widget.sessionType) {
            setState(() {
              messages.insert(0, msg);
            });
            _scrollToBottom();
          }
        }
      } else if (type == 'recall_message') {
        final content = data['content'];
        if (content != null && content is Map<String, dynamic>) {
          final msgId = content['msg_id'];
          final sessionId = content['session_id'];
          final sessionType = content['session_type'];
          if (sessionId == widget.sessionId &&
              sessionType == widget.sessionType) {
            setState(() {
              final index = messages.indexWhere((m) => m.id == msgId);
              if (index != -1) {
                messages[index] = MessageModel(
                  id: messages[index].id,
                  sessionType: messages[index].sessionType,
                  sessionId: messages[index].sessionId,
                  senderId: messages[index].senderId,
                  senderName: messages[index].senderName,
                  senderAvatar: messages[index].senderAvatar,
                  msgType: msgTypeRecall,
                  content: '消息已撤回',
                  mediaUrl: '',
                  mediaSize: 0,
                  mediaDuration: 0,
                  thumbUrl: '',
                  width: 0,
                  height: 0,
                  fileName: '',
                  isRecalled: true,
                  sendTime: messages[index].sendTime,
                );
              }
            });
          }
        }
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = textEditingController.text.trim();
    if (text.isEmpty) return;

    final appState = Provider.of<AppState>(context, listen: false);
    final user = appState.currentUser;

    final tempMsg = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch,
      sessionType: widget.sessionType,
      sessionId: widget.sessionId,
      senderId: currentUserId,
      senderName: user?.nickname ?? '我',
      senderAvatar: user?.avatar ?? '',
      msgType: msgTypeText,
      content: text,
      mediaUrl: '',
      mediaSize: 0,
      mediaDuration: 0,
      thumbUrl: '',
      width: 0,
      height: 0,
      fileName: '',
      isRecalled: false,
      sendTime: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    );

    setState(() {
      messages.insert(0, tempMsg);
      textEditingController.clear();
      displaySend = false;
    });

    _scrollToBottom();

    if (widget.sessionId > 0) {
      try {
        await ApiService().sendMessage(
          sessionType: widget.sessionType,
          sessionId: widget.sessionId,
          msgType: msgTypeText,
          content: text,
        );
      } catch (e) {
        // Handle error
      }
    }
  }

  Future<void> _recallMessage(int msgId) async {
    try {
      await ApiService().recallMessage(msgId);
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _addFavorite(int msgId) async {
    try {
      await ApiService().addFavorite(msgId);
      Get.snackbar('收藏', '已添加到收藏',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.black.withOpacity(0.7),
          colorText: Colors.white,
          duration: const Duration(seconds: 2));
    } catch (e) {
      Get.snackbar('收藏失败', e.toString(),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.7),
          colorText: Colors.white);
    }
  }

  void _copyMessage(String content) {
    Clipboard.setData(ClipboardData(text: content));
    Get.snackbar('复制', '已复制到剪贴板',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.black.withOpacity(0.7),
        colorText: Colors.white,
        duration: const Duration(seconds: 2));
  }

  void _showMessageMenu(
      BuildContext context, MessageModel msg, LongPressStartDetails details) {
    if (msg.isRecalled) return;
    setState(() {
      longPressMsgId = msg.id;
      showMenu = true;
      menuDx = details.globalPosition.dx;
      menuDy = details.globalPosition.dy;
    });
  }

  void _hideMenu() {
    setState(() {
      showMenu = false;
      longPressMsgId = null;
    });
  }

  void _handleAvatarTap(int userId) {
    Get.to(
      UserInformationPage(userId: userId),
      transition: Transition.downToUp,
    );
  }

  void _handleAvatarLongPress(String nickname) {
    final text = textEditingController.text;
    if (!text.endsWith('@$nickname ')) {
      textEditingController.text = '$text@$nickname ';
      textEditingController.selection = TextSelection.fromPosition(
        TextPosition(offset: textEditingController.text.length),
      );
      focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _hideMenu,
      child: Stack(
        children: [
          Scaffold(
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
                          const Row(
                            children: [
                              Text(
                                "在线",
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
                        if (showEmoji) {
                          showEmoji = false;
                          emojiHeight = 0;
                        }
                        displaySend = textEditingController.text.isNotEmpty;
                        if (mounted) setState(() {});
                      },
                      child: ListView.separated(
                        padding: EdgeInsets.fromLTRB(
                            12,
                            MediaQuery.of(context).padding.bottom + 12,
                            12,
                            12),
                        reverse: true,
                        controller: scrollController,
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          return _buildMessageItem(messages[index]);
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
                                  _sendMessage();
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
                            GestureDetector(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                showEmoji = !showEmoji;
                                if (showEmoji) {
                                  isdisplay = false;
                                  height = 0;
                                  emojiHeight = 280;
                                } else {
                                  emojiHeight = 0;
                                }
                                setState(() {});
                              },
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: showEmoji
                                      ? const Color(0xFF12B7F5)
                                          .withOpacity(0.1)
                                      : Colors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.insert_emoticon,
                                    color: showEmoji
                                        ? const Color(0xFF12B7F5)
                                        : const Color(0xFF1A1A1A),
                                    size: 22,
                                  ),
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
                                        showEmoji = false;
                                        emojiHeight = 0;
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
                                        borderRadius:
                                            BorderRadius.circular(12),
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
                                      onPressed: _sendMessage,
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
                                              const MaterialStatePropertyAll(
                                                  Color(0xFF12B7F5))),
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
                    height: isdisplay ? height : (showEmoji ? emojiHeight : 0),
                    color: Colors.white.withOpacity(0.9),
                    padding: const EdgeInsets.only(top: 24),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    child: isdisplay
                        ? _buildMorePanel()
                        : showEmoji
                            ? _buildEmojiPanel()
                            : const SizedBox.shrink(),
                  )
                ],
              ),
            ),
          ),
          if (showMenu) _buildMessageMenu(),
        ],
      ),
    );
  }

  Widget _buildMessageItem(MessageModel msg) {
    final isMe = msg.senderId == currentUserId;
    double width = MediaQuery.sizeOf(context).width * 0.72;

    if (msg.msgType == msgTypeRecall || msg.isRecalled) {
      return _buildSystemMessage('${msg.senderName} 撤回了一条消息');
    }

    final nameRow = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          msg.senderName,
          style: const TextStyle(fontSize: 11, color: Color(0xFF8A8A8E)),
        ),
        const SizedBox(width: 4),
        Text(
          "Lv.${msg.senderLevel}",
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFFFF9500),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );

    return GestureDetector(
      onLongPressStart: (details) {
        _showMessageMenu(context, msg, details);
      },
      child: isMe
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    nameRow,
                    const SizedBox(height: 2),
                    _buildMessageBubble(msg, width, isMe),
                  ],
                ),
                const SizedBox(width: 10),
                _buildAvatar(msg, isMe),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAvatar(msg, isMe),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    nameRow,
                    const SizedBox(height: 2),
                    _buildMessageBubble(msg, width, isMe),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _buildAvatar(MessageModel msg, bool isMe) {
    return GestureDetector(
      onTap: () => _handleAvatarTap(msg.senderId),
      onLongPress: () => _handleAvatarLongPress(msg.senderName),
      child: Container(
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
          child: msg.senderAvatar.isNotEmpty
              ? ExtendedImage.network(
                  msg.senderAvatar,
                  cache: true,
                  width: 38,
                  height: 38,
                  fit: BoxFit.cover,
                )
              : Image.asset(
                  "assets/images/bit7.jpg",
                  width: 38,
                  height: 38,
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(MessageModel msg, double width, bool isMe) {
    switch (msg.msgType) {
      case msgTypeText:
        return _buildTextMessage(msg, width, isMe);
      case msgTypeImage:
        return _buildImageMessage(msg, width, isMe);
      case msgTypeVideo:
        return _buildVideoMessage(msg, width, isMe);
      case msgTypeVoice:
        return _buildVoiceMessage(msg, width, isMe);
      case msgTypeFile:
        return _buildFileMessage(msg, width, isMe);
      default:
        return _buildTextMessage(msg, width, isMe);
    }
  }

  Widget _buildTextMessage(MessageModel msg, double width, bool isMe) {
    final content = _parseMessageContent(msg.content);
    return Container(
      constraints: BoxConstraints(maxWidth: width),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isMe ? const Color(0xFF12B7F5) : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isMe ? 18 : 6),
          topRight: Radius.circular(isMe ? 6 : 18),
          bottomLeft: const Radius.circular(18),
          bottomRight: const Radius.circular(18),
        ),
        boxShadow: [
          BoxShadow(
            color: isMe
                ? const Color(0xFF12B7F5).withOpacity(0.15)
                : Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            color: isMe ? Colors.white : const Color(0xFF1A1A1A),
            fontSize: 15,
            height: 1.4,
          ),
          children: content,
        ),
      ),
    );
  }

  List<InlineSpan> _parseMessageContent(String content) {
    final List<InlineSpan> spans = [];
    final atRegex = RegExp(r'@(\S+)');
    final urlRegex = RegExp(
        r'https?://[^\s]+',
        caseSensitive: false);

    int lastIndex = 0;
    final combinedMatches = [
      ...atRegex.allMatches(content),
      ...urlRegex.allMatches(content),
    ]..sort((a, b) => a.start.compareTo(b.start));

    for (final match in combinedMatches) {
      if (match.start > lastIndex) {
        spans.add(TextSpan(
          text: content.substring(lastIndex, match.start),
        ));
      }
      final matchText = content.substring(match.start, match.end);
      if (matchText.startsWith('@')) {
        spans.add(TextSpan(
          text: matchText,
          style: const TextStyle(
            color: Color(0xFF12B7F5),
            fontWeight: FontWeight.w500,
          ),
        ));
      } else {
        spans.add(TextSpan(
          text: matchText,
          style: const TextStyle(
            color: Color(0xFF007AFF),
            decoration: TextDecoration.underline,
          ),
        ));
      }
      lastIndex = match.end;
    }

    if (lastIndex < content.length) {
      spans.add(TextSpan(
        text: content.substring(lastIndex),
      ));
    }

    if (spans.isEmpty) {
      spans.add(TextSpan(text: content));
    }

    return spans;
  }

  Widget _buildImageMessage(MessageModel msg, double width, bool isMe) {
    return GestureDetector(
      onTap: () {
        Get.dialog(
          Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.zero,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Center(
                child: ExtendedImage.network(
                  msg.mediaUrl.isNotEmpty ? msg.mediaUrl : msg.content,
                  cache: true,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        );
      },
      child: Container(
        constraints: BoxConstraints(maxWidth: width * 0.7, maxHeight: 200),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: ExtendedImage.network(
            msg.mediaUrl.isNotEmpty ? msg.mediaUrl : msg.content,
            cache: true,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildVideoMessage(MessageModel msg, double width, bool isMe) {
    return GestureDetector(
      onTap: () {
        // TODO: Play video
      },
      child: Container(
        constraints: BoxConstraints(maxWidth: width * 0.7, maxHeight: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: msg.thumbUrl.isNotEmpty
                  ? ExtendedImage.network(
                      msg.thumbUrl,
                      cache: true,
                      fit: BoxFit.cover,
                      width: 200,
                      height: 150,
                    )
                  : Container(
                      width: 200,
                      height: 150,
                      color: Colors.black26,
                      child: const Icon(Icons.play_circle_fill,
                          size: 48, color: Colors.white),
                    ),
            ),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.black45,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceMessage(MessageModel msg, double width, bool isMe) {
    final duration = msg.mediaDuration > 0 ? msg.mediaDuration : 3.0;
    final barWidth = (duration / 60) * width * 0.5 + 40;
    return Container(
      width: barWidth.clamp(80, width * 0.6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isMe ? const Color(0xFF12B7F5) : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isMe ? 18 : 6),
          topRight: Radius.circular(isMe ? 6 : 18),
          bottomLeft: const Radius.circular(18),
          bottomRight: const Radius.circular(18),
        ),
        boxShadow: [
          BoxShadow(
            color: isMe
                ? const Color(0xFF12B7F5).withOpacity(0.15)
                : Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.graphic_eq,
            color: isMe ? Colors.white : const Color(0xFF12B7F5),
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            '${duration.toInt()}"',
            style: TextStyle(
              color: isMe ? Colors.white : const Color(0xFF1A1A1A),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileMessage(MessageModel msg, double width, bool isMe) {
    return Container(
      constraints: BoxConstraints(maxWidth: width * 0.8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isMe ? const Color(0xFF12B7F5) : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isMe ? 18 : 6),
          topRight: Radius.circular(isMe ? 6 : 18),
          bottomLeft: const Radius.circular(18),
          bottomRight: const Radius.circular(18),
        ),
        boxShadow: [
          BoxShadow(
            color: isMe
                ? const Color(0xFF12B7F5).withOpacity(0.15)
                : Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isMe
                  ? Colors.white.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.insert_drive_file,
              color: isMe ? Colors.white : const Color(0xFF8A8A8E),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  msg.fileName.isNotEmpty ? msg.fileName : '文件',
                  style: TextStyle(
                    color: isMe ? Colors.white : const Color(0xFF1A1A1A),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  _formatFileSize(msg.mediaSize),
                  style: TextStyle(
                    color: isMe
                        ? Colors.white.withOpacity(0.7)
                        : const Color(0xFF8A8A8E),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatFileSize(int size) {
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    if (size < 1024 * 1024 * 1024) {
      return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(size / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  Widget _buildSystemMessage(String text) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF8A8A8E),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageMenu() {
    final screenWidth = MediaQuery.of(context).size.width;
    double left = menuDx - 100;
    if (left < 10) left = 10;
    if (left + 280 > screenWidth) left = screenWidth - 290;

    return Positioned(
      left: left,
      top: menuDy - 60,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF2C2C2E),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMenuItem(Icons.copy, '复制', () {
                final msg =
                    messages.firstWhere((m) => m.id == longPressMsgId);
                _copyMessage(msg.content);
                _hideMenu();
              }),
              _buildMenuItem(Icons.bookmark_border, '收藏', () {
                if (longPressMsgId != null) {
                  _addFavorite(longPressMsgId!);
                }
                _hideMenu();
              }),
              if (messages
                      .firstWhere((m) => m.id == longPressMsgId,
                          orElse: () => MessageModel(
                              id: 0,
                              sessionType: 0,
                              sessionId: 0,
                              senderId: 0,
                              senderName: '',
                              senderAvatar: '',
                              msgType: 0,
                              content: '',
                              mediaUrl: '',
                              mediaSize: 0,
                              mediaDuration: 0,
                              thumbUrl: '',
                              width: 0,
                              height: 0,
                              fileName: '',
                              isRecalled: false,
                              sendTime: 0))
                      .senderId ==
                  currentUserId)
                _buildMenuItem(Icons.undo, '撤回', () {
                  if (longPressMsgId != null) {
                    _recallMessage(longPressMsgId!);
                  }
                  _hideMenu();
                }),
              _buildMenuItem(Icons.reply, '引用', () {
                _hideMenu();
              }),
              _buildMenuItem(Icons.forward, '转发', () {
                _hideMenu();
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(height: 4),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMorePanel() {
    return GridView.count(
      crossAxisCount: 4,
      mainAxisSpacing: 24,
      crossAxisSpacing: 4,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildPanelItem('picture', '相册', () {}),
        _buildPanelItem('camera', '拍摄', () {}),
        _buildPanelItem('folder', '文件', () {}),
        _buildPanelItem('mic', '语音', () {}),
        _buildPanelItem('location', '位置', () {}),
        _buildPanelItem('card', '名片', () {}),
      ],
    );
  }

  Widget _buildPanelItem(String icon, String name, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
              child: Icon(
                _getIconData(icon),
                size: 24,
                color: const Color(0xFF1A1A1A),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF8A8A8E),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconData(String name) {
    switch (name) {
      case 'picture':
        return Icons.photo_library_outlined;
      case 'camera':
        return Icons.camera_alt_outlined;
      case 'folder':
        return Icons.folder_outlined;
      case 'mic':
        return Icons.mic_none_outlined;
      case 'location':
        return Icons.location_on_outlined;
      case 'card':
        return Icons.contact_page_outlined;
      default:
        return Icons.more_horiz;
    }
  }

  Widget _buildEmojiPanel() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: const Center(
        child: Text(
          '暂无收藏表情',
          style: TextStyle(
            color: Color(0xFF8A8A8E),
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
