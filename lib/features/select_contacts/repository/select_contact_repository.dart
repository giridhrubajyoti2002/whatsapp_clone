import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/features/chat/screens/mobile_chat_screen.dart';

final selectContactRepositoryProvider = Provider((ref) {
  final selectContactRepository = SelectContactRepository(
    firestore: FirebaseFirestore.instance,
  );
  return selectContactRepository;
});

class SelectContactRepository {
  final FirebaseFirestore firestore;

  SelectContactRepository({
    required this.firestore,
  });

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  void selectContact(Contact selectedContact, BuildContext context) async {
    try {
      String selectedPhoneNumber =
          selectedContact.phones[0].number.replaceAll(' ', '');
      var userCollection = await firestore.collection('users').get();
      bool isFound = false;
      for (var document in userCollection.docs) {
        var userData = UserModel.fromMap(document.data());
        if (selectedPhoneNumber == userData.phoneNumber) {
          isFound = true;
          hideSnackBar(context: context);
          // ignore: use_build_context_synchronously
          Navigator.pushNamed(context, MobileChatScreen.routeName, arguments: {
            'name': userData.name,
            'uid': userData.uid,
          });
          break;
        }
      }
      // print(selectedContact.toString());
      if (!isFound) {
        showSnackBar(
            context: context,
            content: "This number does not exist in this app");
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
