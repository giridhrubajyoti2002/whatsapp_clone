import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/features/chat/widgets/bottom_chat_field.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/features/chat/widgets/chat_list.dart';

class MobileChatScreen extends ConsumerWidget {
  static const routeName = '/mobile-chat-screen';
  final String name;
  final String uid;
  const MobileChatScreen({super.key, required this.name, required this.uid});

  // UserModel getReceiverUser(String receiverId)async{
  //   return  await ref.read(authControllerProvider).getUserDataById(uid);
  // }

  String getLastSeen(String lastSeen) {
    if (lastSeen == 'online') {
      return lastSeen;
    }
    DateTime lastDate = DateFormat('yyyy-MM-dd hh:mm:ss').parse(lastSeen);
    String day;
    switch ((DateTime.now().weekday - lastDate.weekday + 7) % 7) {
      case 0:
        day = 'today';
        break;
      case 1:
        day = 'yesterday';
        break;
      default:
        day = DateFormat('EEE').format(lastDate);
    }
    String time = DateFormat('h:mm a').format(lastDate).toLowerCase();
    return 'last seen $day at $time';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        leadingWidth: 100,
        titleSpacing: 5,
        leading: Row(
          children: [
            IconButton(
              padding: const EdgeInsets.all(0),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                // size: 15,
              ),
            ),
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/avatar.png'),
              radius: 24,
            ),
          ],
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 18),
            ),
            StreamBuilder<UserModel>(
              stream: ref.read(authControllerProvider).getUserDataById(uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container();
                }
                return Text(
                  getLastSeen(snapshot.data!.lastSeen),
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.normal),
                );
              },
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.video_call)),
          IconButton(onPressed: () {}, icon: Icon(Icons.call)),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
        ],
      ),
      body: Column(children: [
        Expanded(
          child: ChatList(
            receiverId: uid,
          ),
        ),
        Container(
          // margin: const EdgeInsets.fromLTRB(5, 5, 20, 5),
          child: BottomChatField(receiverUserId: uid),
        ),
      ]),
    );
  }
}
