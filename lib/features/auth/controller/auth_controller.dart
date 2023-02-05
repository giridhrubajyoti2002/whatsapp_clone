import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/features/auth/repository/auth_repository.dart';
import 'package:whatsapp_clone/models/user_model.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  // Provider.of<AuthRepository>(context);
  return AuthController(authRepository: authRepository, ref: ref);
});

final currentUserProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getCurrentUserData();
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;
  UserModel? currentUser;

  AuthController({required this.ref, required this.authRepository});

  Future<UserModel?> getCurrentUserData() async {
    if (currentUser != null) {
      return currentUser;
    }
    currentUser = await authRepository.getCurrentUserData();
    return currentUser;
  }

  void signInWithPhone(BuildContext context, String phoneNumber) {
    authRepository.signInWithPhone(context, phoneNumber);
  }

  void vrifyOTP(BuildContext context, String verificationId, String userOTP) {
    authRepository.verifyOTP(
      context: context,
      verificationId: verificationId,
      userOTP: userOTP,
    );
  }

  void saveUserDataToFirebse(
      BuildContext context, String name, File? selectedProfilePic) {
    authRepository.saveUserDataToFirebse(
        name: name,
        selectedProfilePic: selectedProfilePic,
        ref: ref,
        context: context);
  }

  Stream<UserModel> getUserDataById(String userId) {
    return authRepository.getUserDataById(userId);
  }

  updateCurrentUserActiveStatus(String lastSeen) {
    authRepository.updateCurrentUserActiveStatus(lastSeen);
  }
}
