import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/common/widgets/custom_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = "/login-screen";
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final phoneController = TextEditingController();
  Country? country;

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  void pickCountry() {
    showCountryPicker(
      context: context,
      showPhoneCode: false,
      onSelect: (Country _country) {
        setState(() {
          country = _country;
        });
      },
    );
  }

  void sendPhoneNumber() {
    String phoneNumber = phoneController.text.trim();
    if (country != null && phoneNumber.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .signInWithPhone(context, "+${country!.phoneCode}$phoneNumber");
      // Provider rEF -> Interact provider with provider
      // Widget ref -> makes widget interact with provider
    } else {
      showSnackBar(context: context, content: "Fill out all the fields");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter your phone number"),
        centerTitle: true,
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("WhatsApp needs to verify your phone number"),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => pickCountry(),
                    child: const Text("Pick Country"),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      if (country != null)
                        Text(
                          "+${country!.phoneCode}",
                          style: const TextStyle(fontSize: 16),
                        ),
                      const SizedBox(width: 5),
                      SizedBox(
                        width: size.width * 0.7,
                        child: TextField(
                          controller: phoneController,
                          decoration: const InputDecoration(
                            hintText: "phone number",
                            contentPadding: EdgeInsets.symmetric(horizontal: 8),
                          ),
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                width: 100,
                child: CustomButton(
                  text: "NEXT",
                  onPressed: () => sendPhoneNumber(),
                ),
              )
            ]),
      ),
    );
  }
}
