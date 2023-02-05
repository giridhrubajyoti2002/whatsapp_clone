import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:giphy_picker/giphy_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/enums/message_enum.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/features/chat/controller/chat_controller.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String receiverUserId;
  const BottomChatField({
    required this.receiverUserId,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  bool isShowSendButton = false;
  final TextEditingController _messageController = TextEditingController();
  FlutterSoundRecorder? _soundRecorder;
  bool isRecording = false;
  bool isMicInit = false;
  bool isShowEmojiContainer = false;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _soundRecorder = FlutterSoundRecorder();
  }

  Future<bool> openRecorder() async {
    if (!await Permission.microphone.isGranted) {
      final requestStatus = await Permission.microphone.request();
      if (requestStatus != PermissionStatus.granted) {
        showSnackBar(
            context: context, content: "Microphone permission required");
        return false;
        ;
      }
    }
    await _soundRecorder!.openRecorder();
    isMicInit = true;
    return true;
  }

  void sendTextMessage() async {
    if (isShowSendButton) {
      ref.read(chatControllerProvider).sendTextMessage(
            context: context,
            text: _messageController.text.trim(),
            receiverUserId: widget.receiverUserId,
          );
      setState(() {
        _messageController.text = '';
        isShowSendButton = false;
      });
    } else {
      if (!await openRecorder()) {
        return;
      }
      var tempDir = await getTemporaryDirectory();
      var path = '${tempDir.path}/recorded_audio.aac';
      if (isRecording) {
        _soundRecorder!.closeRecorder();
        sendFileMessage(File(path), MessageEnum.audio);
      } else {
        _soundRecorder!.startRecorder(
          toFile: path,
        );
      }
      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  void sendFileMessage(File file, MessageEnum messageEnum) {
    ref.read(chatControllerProvider).sendFileMessage(
          context: context,
          file: file,
          receiverUserId: widget.receiverUserId,
          messageEnum: messageEnum,
        );
  }

  void sendGIFMessage(String url, MessageEnum messageEnum) {
    ref
        .read(chatControllerProvider)
        .sendGIFMessage(context, url, widget.receiverUserId);
  }

  void selectImage() async {
    File? image = await pickImageFromGalary(context);
    if (image != null) {
      sendFileMessage(image, MessageEnum.image);
    }
  }

  void selectVideo() async {
    File? video = await pickVideoFromGalary(context);
    if (video != null) {
      sendFileMessage(video, MessageEnum.video);
    }
  }

  void selectGIF() async {
    GiphyGif? gif = await pickGIF(context);
    if (gif != null) {
      sendGIFMessage(gif.url!, MessageEnum.gif);
    }
  }

  void showEmojiContainer() {
    setState(() {
      isShowEmojiContainer = true;
    });
  }

  void hideEmojiContainer() {
    setState(() {
      isShowEmojiContainer = false;
    });
  }

  void showKeyboard() => focusNode.requestFocus();
  void hideKeyboard() => focusNode.unfocus();
  void toggleEmojiKeyboardContainer() {
    if (isShowEmojiContainer) {
      showKeyboard();
      hideEmojiContainer();
    } else {
      hideKeyboard();
      showEmojiContainer();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
    if (isMicInit) {
      _soundRecorder!.closeRecorder();
      isMicInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 5, 5, 7),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _messageController,
                  focusNode: focusNode,
                  onTap: () {
                    if (isShowEmojiContainer) {
                      hideKeyboard();
                    }
                  },
                  onChanged: (val) {
                    if (val.isNotEmpty) {
                      setState(() {
                        isShowSendButton = true;
                      });
                    } else {
                      setState(() {
                        isShowSendButton = false;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    fillColor: mobileChatBoxColor,
                    filled: true,
                    prefixIcon: SizedBox(
                      width: 100,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          children: [
                            IconButton(
                              constraints: const BoxConstraints(minWidth: 40),
                              icon: const Icon(Icons.emoji_emotions,
                                  color: greyColor),
                              onPressed: toggleEmojiKeyboardContainer,
                            ),
                            IconButton(
                              padding: const EdgeInsets.all(0),
                              icon: const Icon(
                                Icons.gif,
                                color: greyColor,
                                size: 35,
                              ),
                              onPressed: selectGIF,
                            ),
                          ],
                        ),
                      ),
                    ),
                    suffixIcon: SizedBox(
                      width: 90,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              constraints: const BoxConstraints(minWidth: 40),
                              onPressed: selectImage,
                              icon: const Icon(Icons.camera_alt,
                                  color: greyColor),
                            ),
                            IconButton(
                              constraints: const BoxConstraints(minWidth: 40),
                              onPressed: selectVideo,
                              icon: const Icon(Icons.attach_file,
                                  color: greyColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(26),
                      borderSide:
                          const BorderSide(width: 0, style: BorderStyle.none),
                    ),
                    hintText: "Message",
                    hintStyle: const TextStyle(color: greyColor),
                    contentPadding: const EdgeInsets.all(0),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 7),
                child: CircleAvatar(
                  backgroundColor: buttonColor,
                  radius: 24,
                  child: GestureDetector(
                    onTap: sendTextMessage,
                    onLongPress: () =>
                        showSnackBar(context: context, content: 'recording'),
                    child: Icon(
                      isShowSendButton
                          ? Icons.send
                          : isRecording
                              ? Icons.close
                              : Icons.mic,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: isShowEmojiContainer ? 300 : 0,
            child: EmojiPicker(
              onEmojiSelected: (category, emoji) {
                setState(() {
                  _messageController.text =
                      _messageController.text + emoji.emoji;
                });
                if (!isShowSendButton) {
                  setState(() {
                    isShowSendButton = true;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
