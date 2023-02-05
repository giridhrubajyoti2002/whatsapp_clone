// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

import 'package:whatsapp_clone/common/enums/message_enum.dart';
import 'package:whatsapp_clone/features/chat/widgets/video_player_item.dart';
import 'package:whatsapp_clone/models/message.dart';

class DisplayTextImageGIF extends StatelessWidget {
  final Message message;
  const DisplayTextImageGIF({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (message.messageEnum) {
      case MessageEnum.image:
        return ImageMessage(message: message.text);
      case MessageEnum.gif:
        return ImageMessage(message: message.text);
      case MessageEnum.video:
        return VideoPlayerItem(videoUrl: message.text);
      case MessageEnum.audio:
        return AudioPlayerItem(message: message.text);
      default:
        return Padding(
          padding: const EdgeInsets.fromLTRB(5, 2, 10, 0),
          child: Text(
            message.text,
            style: const TextStyle(fontSize: 16),
          ),
        );
    }
  }
}

class ImageMessage extends StatelessWidget {
  final String message;
  const ImageMessage({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: size.width * 0.75,
        maxHeight: 320,
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: CachedNetworkImage(
          imageUrl: message,
        ),
      ),
    );
  }
}

class AudioPlayerItem extends StatelessWidget {
  final String message;
  const AudioPlayerItem({
    Key? key,
    required this.message,
  }) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    bool isPlaying = false;
    final AudioPlayer audioPlayer = AudioPlayer();
    return StatefulBuilder(builder: (context, setState) {
      
      audioPlayer.onPlayerComplete.listen(
        (event) {
          setState(() {
            isPlaying = false;
          });
        },
      );
      return IconButton(
        constraints: const BoxConstraints(minWidth: 100),
        onPressed: () async {
          if (isPlaying) {
            await audioPlayer.pause();
          } else {
            await audioPlayer.play(
              UrlSource(message),
            );
          }
          setState(() {
            isPlaying = !isPlaying;
          });
        },
        icon: Icon(isPlaying ? Icons.pause_circle : Icons.play_circle),
      );
    });
  }
}
