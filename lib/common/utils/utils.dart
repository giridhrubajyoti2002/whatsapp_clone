import 'dart:io';
import 'package:flutter/material.dart';
import 'package:giphy_picker/giphy_picker.dart';
import 'package:image_picker/image_picker.dart';

final focusNode = FocusNode();

const String defaultProfilePicPath = 'assets/images/avatar.png';

void showSnackBar({required BuildContext context, required String content}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}

void hideSnackBar({required BuildContext context}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
}

void showCircularProgressIndicator(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      );
    },
  );
}

void hideCircularProgressIndicator(BuildContext context) {
  Navigator.of(context).pop();
}

Future<File?> pickImageFromGalary(BuildContext context) async {
  File? image;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    showSnackBar(context: context, content: e.toString());
  }
  return image;
}

Future<File?> pickVideoFromGalary(BuildContext context) async {
  File? video;
  try {
    final pickedVideo =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedVideo != null) {
      video = File(pickedVideo.path);
    }
  } catch (e) {
    showSnackBar(context: context, content: e.toString());
  }
  return video;
}

Future<GiphyGif?> pickGIF(BuildContext context) async {
  GiphyGif? gif;
  try {
    gif = await GiphyPicker.pickGif(
        context: context, apiKey: '7DIDdVHBr2hHiooWb11uauU2QiZOXo89');
  } catch (e) {
    showSnackBar(context: context, content: e.toString());
  }
  return gif;
}
