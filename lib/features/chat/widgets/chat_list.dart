// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/common/widgets/loader.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/features/auth/repository/auth_repository.dart';

import 'package:whatsapp_clone/features/chat/controller/chat_controller.dart';

import 'package:whatsapp_clone/models/message.dart';
import 'package:whatsapp_clone/features/chat/widgets/message_card.dart';
import 'package:whatsapp_clone/models/user_model.dart';

class ChatList extends ConsumerStatefulWidget {
  final String receiverId;
  const ChatList({
    super.key,
    required this.receiverId,
  });

  @override
  ConsumerState<ChatList> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String currentUserId = ref.read(authRepositoryProvider).auth.currentUser!.uid;
    return StreamBuilder<List<Message>>(
        stream:
            ref.read(chatControllerProvider).getChatMessages(widget.receiverId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          SchedulerBinding.instance.addPostFrameCallback((_) {
            _scrollController
                .jumpTo(_scrollController.position.maxScrollExtent);
          });

          return ListView.builder(
            controller: _scrollController,
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: ((context, index) {
              Message message = snapshot.data![index];
              return MessageCard(
                message: message,
                currentUserId: currentUserId,
              );
            }),
          );
        });
  }
}
