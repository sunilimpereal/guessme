import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:guessme/authentication/data/models/user_model.dart';
import 'package:guessme/authentication/data/repository/authrepository.dart';

import 'package:guessme/home/data/repository/friends_repository.dart';
import 'package:guessme/home/screens/widgets/drawer.dart';
import 'package:guessme/friends/screens/widgets/friend_card.dart';
import 'package:guessme/home/screens/widgets/friend_request_card.dart';
import 'package:guessme/main.dart';
import 'package:guessme/messaging/data/repository/message_repository.dart';
import 'package:guessme/messaging/screen/chat_request_section.dart';

import '../../messaging/data/bloc/messaging_bloc.dart';
import '../data/bloc/friends_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HomeScaffold(
      scaffoldKey: scaffoldKey,
      child: Column(
        children: [
          ChatRequestSection(),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}

class HomeScaffold extends StatefulWidget {
  final Widget child;
  final GlobalKey<ScaffoldState> scaffoldKey;
  const HomeScaffold(
      {super.key, required this.child, required this.scaffoldKey});

  @override
  State<HomeScaffold> createState() => _HomeScaffoldState();
}

class _HomeScaffoldState extends State<HomeScaffold> {
  @override
  Widget build(BuildContext context) {
    AuthRepository().updateuserlastSeen(sharedPref.udid);
    return Scaffold(
      key: widget.scaffoldKey,
      drawer: const HomeDrawer(),
      backgroundColor: Colors.blueGrey.shade50,
      body: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          widget.scaffoldKey.currentState?.openDrawer();
                        },
                        icon: const Icon(
                          Icons.menu,
                          size: 28,
                        )),
                    IconButton(
                        onPressed: () {
                          FriendsProvider.of(context).updateFriends();
                          MessagingProvider.of(context).getChatReuests();
                        },
                        icon: const Icon(
                          Icons.rotate_90_degrees_ccw,
                          size: 28,
                        ))
                  ],
                ),
                // const ChatRequestCard(),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [widget.child],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pullRefresh() async {
    FriendsProvider.of(context).updateFriends();
    MessagingProvider.of(context).getChatReuests();
  }
}
