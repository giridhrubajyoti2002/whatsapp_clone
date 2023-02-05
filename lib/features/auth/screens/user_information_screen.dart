import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';

class UserInformationScreen extends ConsumerStatefulWidget {
  static const routeName = '/user-information';

  const UserInformationScreen({super.key});

  @override
  ConsumerState<UserInformationScreen> createState() =>
      _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
  final nameController = TextEditingController();
  File? image;
  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void selectImage() async {
    image = await pickImageFromGalary(context);
    setState(() {});
  }

  void saveUserData() async {
    String name = nameController.text.trim();
    if (name.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .saveUserDataToFirebse(context, name, image);
    } else {
      showSnackBar(context: context, content: "Username cannot be empty");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 60,
              ),
              Stack(
                children: [
                  image == null
                      ? const CircleAvatar(
                          backgroundImage: AssetImage(defaultProfilePicPath),
                          radius: 72,
                        )
                      : CircleAvatar(
                          backgroundImage: FileImage(image!),
                          radius: 72,
                        ),
                  Positioned(
                    bottom: -12,
                    left: 90,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(
                        Icons.add_a_photo,
                        size: 32,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Container(
                    width: size.width * 0.82,
                    padding: const EdgeInsets.only(left: 20),
                    child: TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        hintText: "Enter your name",
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                    ),
                  ),
                  IconButton(
                      padding: const EdgeInsets.only(top: 20, left: 10),
                      onPressed: () => saveUserData(),
                      icon: const Icon(
                        Icons.done,
                        size: 28,
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
