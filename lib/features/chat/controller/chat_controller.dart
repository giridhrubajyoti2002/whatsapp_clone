// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/enums/message_enum.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';

import 'package:whatsapp_clone/features/chat/repository/chat_repository.dart';
import 'package:whatsapp_clone/models/chat_contact.dart';
import 'package:whatsapp_clone/models/message.dart';

final chatControllerProvider = Provider(
  (ref) {
    final chatRepository = ref.watch(chatRepositoryProvider);
    return ChatController(chatRepository: chatRepository, ref: ref);
  },
);

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  Stream<List<ChatContact>> getChatContacts() {
    return chatRepository.getChatContacts();
  }

  Stream<List<Message>> getChatMessages(String receiverId) {
    return chatRepository.getChatMessages(receiverId);
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String receiverUserId,
  }) async {
    ref.read(currentUserProvider).whenData(
          (currentUser) => chatRepository.sendTextMessage(
              context: context,
              text: text,
              receiverUserId: receiverUserId,
              senderUser: currentUser!),
        );
  }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String receiverUserId,
    required MessageEnum messageEnum,
  }) {
    ref.read(currentUserProvider).whenData(
          (currentUser) => chatRepository.sendFileMessage(
              context: context,
              file: file,
              receiverUserId: receiverUserId,
              senderUser: currentUser!,
              ref: ref,
              messageEnum: messageEnum),
        );
  }

  void sendGIFMessage(
    BuildContext context,
    String url,
    String receiverUserId,
  ) {
    // "https://giphy.com/gifs/wta-sport-celebration-tennis-4Xpj9WrxB4aNqDI5Mv"
    // 'https://i.giphy.com/blSTtZehjAZ8I/200.gif'

    String gifUrl = 'https://i.giphy.com/${url.split('-').last}/200.gif';

    ref.read(currentUserProvider).whenData(
          (currentUser) => chatRepository.sendGIFMessage(
            context: context,
            gifUrl: gifUrl,
            receiverUserId: receiverUserId,
            senderUser: currentUser!,
          ),
        );
  }
}
