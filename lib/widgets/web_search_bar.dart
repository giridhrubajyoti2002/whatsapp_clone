import 'package:flutter/material.dart';
import 'package:whatsapp_clone/colors.dart';

class WebSearchBar extends StatelessWidget {
  const WebSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.06,
      width: size.width * 0.25,
      padding: const EdgeInsets.all(5),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: dividerColor)),
      ),
      child: TextField(
        decoration: InputDecoration(
          fillColor: searchBarColor,
          filled: true,
          prefixIcon: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Icon(Icons.search, size: 20),
          ),
          hintText: "Search or start a new chat",
          hintStyle: const TextStyle(fontSize: 14),
          contentPadding: const EdgeInsets.all(5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(width: 2, style: BorderStyle.none),
          ),
        ),
      ),
    );
  }
}
