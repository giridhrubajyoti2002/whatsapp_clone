import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/features/select_contacts/screens/select_contact_screen.dart';
import 'package:whatsapp_clone/features/chat/widgets/contacts_list.dart';

class MobileScreenLayout extends ConsumerStatefulWidget {
  static const routeName = '/home';
  const MobileScreenLayout({super.key});

  @override
  ConsumerState<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends ConsumerState<MobileScreenLayout> with WidgetsBindingObserver {
    @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    bool active;
    switch (state) {
      case AppLifecycleState.resumed:
        active = true;
        break;
      default:
        active = false;
    }

    updateCurrentUserActiveStatus(
      active
          ? 'online'
          : DateFormat("yyyy-MM-dd hh:mm:ss a").format(DateTime.now()),
    );
  }

  updateCurrentUserActiveStatus(String lastSeen) {
    ref.read(authControllerProvider).updateCurrentUserActiveStatus(lastSeen);
  }

  @override
  Widget build(BuildContext context) {
        updateCurrentUserActiveStatus('online');
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: appBarColor,
            // elevation: 0,
            title: const Text("WhatsApp",
                style: TextStyle(
                    color: greyColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            centerTitle: false,
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search, color: greyColor)),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_vert, color: greyColor)),
            ],
            bottom: const TabBar(
              labelColor: tabColor,
              unselectedLabelColor: greyColor,
              indicatorColor: tabColor,
              indicatorWeight: 3,
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              tabs: [
                Tab(text: "CHATS"),
                Tab(text: "STATUS"),
                Tab(text: "CALLS")
              ],
            ),
          ),
          body: ContactsList(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).pushNamed(SelectContactScreen.routeName);
            },
            backgroundColor: tabColor,
            child: const Icon(
              Icons.comment,
              color: Colors.white,
            ),
          ),
        ));
  }
}
