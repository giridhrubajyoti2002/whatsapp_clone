import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/features/chat/widgets/display_text_image_gif.dart';
import 'package:whatsapp_clone/models/message.dart';

class MessageCard extends StatelessWidget {
  final Message message;
  final String currentUserId;
  const MessageCard({
    Key? key,
    required this.message,
    required this.currentUserId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Align(
      alignment: message.senderId == currentUserId
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: size.width * 0.9,
          minWidth: 150,
          // minHeight: 50,
        ),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          color: message.senderId == currentUserId
              ? messageColor
              : mobileChatBoxColor,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
          child: Stack(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 22),
              child: DisplayTextImageGIF(message: message),
            ),
            Positioned(
              bottom: 5,
              right: 15,
              // left: 10,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    DateFormat('h:mm a').format(message.timeSent).toLowerCase(),
                    style: const TextStyle(fontSize: 13, color: Colors.white60),
                  ),
                  const SizedBox(width: 5),
                  message.senderId == currentUserId
                      ? Icon(
                          Icons.done_all,
                          size: 18,
                          color: message.isSeen
                              ? Colors.lightBlue
                              : Colors.white54,
                        )
                      : const SizedBox(),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
