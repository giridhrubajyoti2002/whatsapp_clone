import 'package:flutter/material.dart';
import 'package:whatsapp_clone/colors.dart';

class WebProfileBar extends StatelessWidget {
  const WebProfileBar({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * .077,
      width: size.width * 0.25,
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        border: Border(right: BorderSide(color: dividerColor, width: 5)),
        color: webAppBarColor,
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(
            'https://images.unsplash.com/photo-1619194617062-5a61b9c6a049?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTB8fHJhbmRvbSUyMHBlb3BsZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60',
          ),
        ),
        Row(children: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.groups,
                color: greyColor,
              )),
          // IconButton(onPressed: () {}, icon: Icon(Icons.s)),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.comment,
                color: greyColor,
              )),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert,
                color: greyColor,
              )),
        ]),
      ]),
    );
  }
}
