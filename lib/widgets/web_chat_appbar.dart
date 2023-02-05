import 'package:flutter/material.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/info.dart';

class WebChatAppBar extends StatelessWidget {
  const WebChatAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.077,
      width: size.width * 0.75,
      padding: const EdgeInsets.all(8),
      color: webAppBarColor,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(children: [
          const CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1619194617062-5a61b9c6a049?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTB8fHJhbmRvbSUyMHBlb3BsZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60'),
          ),
          SizedBox(
            width: size.width * 0.01,
          ),
          Text(
            info[0]['name'].toString(),
            style: const TextStyle(fontSize: 18),
          )
        ]),
        Row(
          children: [
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.search, color: greyColor)),
            SizedBox(width: size.width * 0.001),
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert, color: greyColor)),
          ],
        ),
      ]),
    );
  }
}
