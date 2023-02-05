import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/features/auth/screens/otp_screen.dart';
import 'package:whatsapp_clone/features/auth/screens/user_information_screen.dart';
import 'package:whatsapp_clone/common/repository/firebase_storage_repository.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/screens/mobile_screen_layout.dart';

final authRepositoryProvider = Provider(
  (ref) {
    return AuthRepository(
      auth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
    );
  },
);

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository({
    required this.auth,
    required this.firestore,
  });

  Future<UserModel?> getCurrentUserData() async {
    var userData =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();
    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      showCircularProgressIndicator(context);
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential).then((value) =>
              Navigator.of(context).pushNamedAndRemoveUntil(
                  MobileScreenLayout.routeName, (route) => false));
        },
        verificationFailed: (e) {
          throw e;
        },
        codeSent: (String verificationId, int? resendToken) async {
          hideCircularProgressIndicator(context);
          Navigator.pushNamed(context, OTPScreen.routeName,
              arguments: verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  void verifyOTP({
    required BuildContext context,
    required String verificationId,
    required String userOTP,
  }) async {
    try {
      showCircularProgressIndicator(context);
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOTP);
      await auth.signInWithCredential(credential);
      hideCircularProgressIndicator(context);
      Navigator.of(context).pushNamedAndRemoveUntil(
          UserInformationScreen.routeName, (route) => false);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  void saveUserDataToFirebse({
    required String name,
    required File? selectedProfilePic,
    required ProviderRef ref,
    required BuildContext context,
  }) async {
    try {
      showCircularProgressIndicator(context);
      String uid = auth.currentUser!.uid;
      File profilePic = File(defaultProfilePicPath);
      if (selectedProfilePic != null) {
        profilePic = selectedProfilePic;
      }
      String profilePicUrl = await ref
          .read(firebaseStorageRepositoryProvider)
          .storeFileToFirebase("profilePic/$uid", profilePic);

      var user = UserModel(
        name: name,
        uid: uid,
        profilePicUrl: profilePicUrl,
        lastSeen: 'online',
        phoneNumber: auth.currentUser!.phoneNumber.toString(),
        groupId: [],
      );
      await firestore.collection('users').doc(uid).set(user.toMap());
      hideCircularProgressIndicator(context);
      Navigator.of(context).pushNamedAndRemoveUntil(
          MobileScreenLayout.routeName, (route) => false);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Stream<UserModel> getUserDataById(String userId) {
    return firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((event) => UserModel.fromMap(event.data()!));
  }

  updateCurrentUserActiveStatus(String lastSeen) {
    String userId = auth.currentUser!.uid;
    firestore.collection('users').doc(userId).update({
      'lastSeen': lastSeen,
    });
  }
}
