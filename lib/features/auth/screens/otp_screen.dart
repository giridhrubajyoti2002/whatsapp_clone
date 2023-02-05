import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/colors.dart';

class OTPScreen extends ConsumerWidget {
  static const String routeName = '/otp-screen';
  final String verificationId;
  const OTPScreen({super.key, required this.verificationId});

  void verifyOTP(WidgetRef ref, BuildContext context, String userOTP) {
    ref.read(authControllerProvider).vrifyOTP(context, verificationId, userOTP);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifying your number'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: Center(
        child: Column(children: [
          const SizedBox(
            height: 40,
          ),
          const Text("We have sent SMS with a code"),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: size.width * 0.5,
            child: TextField(
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                hintText: '- - - - - -',
                hintStyle: TextStyle(
                  fontSize: 30,
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                if (value.length == 6) {
                  verifyOTP(ref, context, value.trim());
                }
              },
              onSubmitted: (value) {
                if (value.length == 6) {
                  verifyOTP(ref, context, value.trim());
                } else {
                  showSnackBar(
                      context: context, content: "OTP must be of length 6");
                }
              },
            ),
          )
        ]),
      ),
    );
  }
}
