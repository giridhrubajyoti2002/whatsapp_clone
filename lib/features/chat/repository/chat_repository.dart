import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/common/enums/message_enum.dart';
import 'package:whatsapp_clone/common/repository/firebase_storage_repository.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/models/chat_contact.dart';
import 'package:whatsapp_clone/models/message.dart';
import 'package:whatsapp_clone/models/user_model.dart';

final chatRepositoryProvider = Provider(
  (ref) => ChatRepository(
      firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance),
);

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRepository({required this.firestore, required this.auth});

  Stream<List<ChatContact>> getChatContacts() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .orderBy('timeSent')
        .snapshots()
        .map(
      (event) {
        List<ChatContact> contacts = [];
        for (var document in event.docs) {
          var chatContact = ChatContact.fromMap(document.data());
          contacts.add(chatContact);
        }
        return contacts;
      },
    );
  }

  Stream<List<Message>> getChatMessages(String receiverId) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .asyncMap((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }
      return messages;
    });
  }

  void _saveDataToContactsSubCollection({
    required UserModel senderUser,
    required UserModel receiverUser,
    required String text,
    required DateTime timeSent,
  }) async {
    var receiverChatContact = ChatContact(
      name: senderUser.name,
      profilePic: senderUser.profilePicUrl,
      userId: senderUser.uid,
      lastMessage: text,
      timeSent: timeSent,
    );
    await firestore
        .collection('users')
        .doc(receiverUser.uid)
        .collection('chats')
        .doc(senderUser.uid)
        .set(
          receiverChatContact.toMap(),
        );
    var senderChatContact = ChatContact(
      name: receiverUser.name,
      profilePic: receiverUser.profilePicUrl,
      userId: receiverUser.uid,
      lastMessage: text,
      timeSent: timeSent,
    );
    await firestore
        .collection('users')
        .doc(senderUser.uid)
        .collection('chats')
        .doc(receiverUser.uid)
        .set(
          senderChatContact.toMap(),
        );
  }

  void _saveMessageToMessageSubCollection({
    required UserModel senderUser,
    required UserModel receiverUser,
    required String text,
    required DateTime timeSent,
    required MessageEnum messageEnum,
    required String messageId,
  }) async {
    final message = Message(
      senderId: senderUser.uid,
      receiverId: receiverUser.uid,
      text: text,
      messageEnum: messageEnum,
      timeSent: timeSent,
      messageId: messageId,
      isSeen: false,
    );
    await firestore
        .collection('users')
        .doc(senderUser.uid)
        .collection('chats')
        .doc(receiverUser.uid)
        .collection('messages')
        .doc(messageId)
        .set(
          message.toMap(),
        );
    await firestore
        .collection('users')
        .doc(receiverUser.uid)
        .collection('chats')
        .doc(senderUser.uid)
        .collection('messages')
        .doc(messageId)
        .set(
          message.toMap(),
        );
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String receiverUserId,
    required UserModel senderUser,
  }) async {
    try {
      var timeSent = DateTime.now();
      var userDataMap =
          await firestore.collection('users').doc(receiverUserId).get();
      UserModel receiverUser = UserModel.fromMap(userDataMap.data()!);
      var messageId = const Uuid().v1();

      _saveDataToContactsSubCollection(
        senderUser: senderUser,
        receiverUser: receiverUser,
        text: text,
        timeSent: timeSent,
      );
      _saveMessageToMessageSubCollection(
        senderUser: senderUser,
        receiverUser: receiverUser,
        text: text,
        timeSent: timeSent,
        messageId: messageId,
        messageEnum: MessageEnum.text,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String receiverUserId,
    required UserModel senderUser,
    required ProviderRef ref,
    required MessageEnum messageEnum,
  }) async {
    try {
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();
      String downloadUrl =
          await ref.read(firebaseStorageRepositoryProvider).storeFileToFirebase(
                'chat/${messageEnum.type}/${senderUser.uid}/$receiverUserId/$messageId',
                file,
              );
      var userDataMap =
          await firestore.collection('users').doc(receiverUserId).get();
      UserModel receiverUser = UserModel.fromMap(userDataMap.data()!);
      String messageType;
      switch (messageEnum) {
        case MessageEnum.image:
          messageType = '📷 image';
          break;
        case MessageEnum.video:
          messageType = '📸 video';
          break;
        case MessageEnum.audio:
          messageType = '🎙️ audio';
          break;
        case MessageEnum.music:
          messageType = '📷 image';
          break;
        case MessageEnum.gif:
          messageType = 'GIF';
          break;
        default:
          messageType = 'GIF';
      }

      _saveDataToContactsSubCollection(
        senderUser: senderUser,
        receiverUser: receiverUser,
        text: messageType,
        timeSent: timeSent,
      );
      _saveMessageToMessageSubCollection(
        senderUser: senderUser,
        receiverUser: receiverUser,
        text: downloadUrl,
        timeSent: timeSent,
        messageEnum: messageEnum,
        messageId: messageId,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendGIFMessage({
    required BuildContext context,
    required String gifUrl,
    required String receiverUserId,
    required UserModel senderUser,
  }) async {
    try {
      var timeSent = DateTime.now();
      var userDataMap =
          await firestore.collection('users').doc(receiverUserId).get();
      UserModel receiverUser = UserModel.fromMap(userDataMap.data()!);
      var messageId = const Uuid().v1();

      _saveDataToContactsSubCollection(
        senderUser: senderUser,
        receiverUser: receiverUser,
        text: 'GIF',
        timeSent: timeSent,
      );
      _saveMessageToMessageSubCollection(
        senderUser: senderUser,
        receiverUser: receiverUser,
        text: gifUrl,
        timeSent: timeSent,
        messageId: messageId,
        messageEnum: MessageEnum.gif,
      );
      print(gifUrl);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
