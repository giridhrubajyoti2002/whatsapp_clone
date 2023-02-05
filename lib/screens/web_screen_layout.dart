import 'package:flutter/material.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/features/chat/widgets/chat_list.dart';
import 'package:whatsapp_clone/features/chat/widgets/contacts_list.dart';
import 'package:whatsapp_clone/widgets/web_chat_appbar.dart';
import 'package:whatsapp_clone/widgets/web_profile_bar.dart';

import '../widgets/web_search_bar.dart';

class WebScreenLayout extends StatelessWidget {
  const WebScreenLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children:  [
                const WebProfileBar(),
                const WebSearchBar(),
                ContactsList(),
              ],
            ),
          ),
        ),
        Container(
          width: size.width * 0.75,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/backgroundImage.png'),
                fit: BoxFit.cover),
          ),
          child: Column(children: [
            const WebChatAppBar(),
            const Expanded(child: ChatList(receiverId: '',)),
            Container(
              height: size.height * .07,
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: dividerColor)),
                  color: chatBarMessageColor),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.emoji_emotions_outlined,
                      color: greyColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.attach_file,
                      color: greyColor,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 15),
                      child: TextField(
                        decoration: InputDecoration(
                          fillColor: searchBarColor,
                          filled: true,
                          hintText: 'Type Message',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                                width: 2, style: BorderStyle.none),
                          ),
                          contentPadding: const EdgeInsets.only(left: 20),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.mic,
                      color: greyColor,
                    ),
                  ),
                ],
              ),
            ),
          ]),
        )
      ]),
    );
  }
}
