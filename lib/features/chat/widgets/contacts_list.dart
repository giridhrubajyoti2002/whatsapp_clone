import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/widgets/loader.dart';
import 'package:whatsapp_clone/features/chat/controller/chat_controller.dart';

import 'package:whatsapp_clone/features/chat/screens/mobile_chat_screen.dart';
import 'package:whatsapp_clone/models/chat_contact.dart';

class ContactsList extends ConsumerWidget {
  const ContactsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<List<ChatContact>>(
        stream: ref.watch(chatControllerProvider).getChatContacts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (context, index) {
              var chatContact = snapshot.data![index];
              return Column(
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(MobileChatScreen.routeName, arguments: {
                        'name': chatContact.name,
                        'uid': chatContact.userId,
                      });
                    },
                    title: Text(
                      chatContact.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: SizedBox(
                        height: 22,
                        child: Text(
                          chatContact.lastMessage,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                    leading: CircleAvatar(
                      radius: 28,
                      backgroundImage:
                          CachedNetworkImageProvider(chatContact.profilePic),
                    ),
                    trailing: Text(
                      DateFormat('h:mm a')
                          .format(chatContact.timeSent)
                          .toLowerCase(),
                      style: const TextStyle(color: greyColor, fontSize: 12),
                    ),
                  ),
                  const Divider(
                    height: 2,
                    thickness: 1,
                    color: dividerColor,
                  )
                ],
              );
            },
          );
        });
  }
}
