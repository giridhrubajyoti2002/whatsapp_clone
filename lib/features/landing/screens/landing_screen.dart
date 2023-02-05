import 'package:flutter/material.dart';
import 'package:whatsapp_clone/features/auth/screens/login_screen.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/widgets/custom_button.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  void navigateToLoginScreen(BuildContext context) {
    Navigator.of(context).pushNamed(LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          const Text(
            "Welcome to WhatsApp",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: size.height / 9),
          Image.asset(
            'assets/images/bg.png',
            color: tabColor,
            width: size.width - 40,
            height: size.height / 2.8,
          ),
          SizedBox(height: size.height / 9),
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              "Read our Privacy Policy. Tap \"Agree and continue\" to accept the Terms and Services.",
              style: TextStyle(
                color: greyColor,
                // fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            width: size.width * 0.75,
            child: CustomButton(
              text: "AGREE AND CONTINUE",
              onPressed: () => navigateToLoginScreen(context),
            ),
          ),
        ],
      )),
    );
  }
}
