import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guessme/home/data/bloc/friends_bloc.dart';
import 'package:guessme/home/screens/widgets/online_friends_section.dart';

import '../../messaging/data/bloc/messaging_bloc.dart';
import '../../messaging/screen/chat_request_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  getOnlineFriends() {
    // FriendsProvider.of(context).getOnlineFrineds();
  }

  @override
  void initState() {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    super.initState();
  }

  Future<void> _pullRefresh() async {
    FriendsProvider.of(context).updateFriends();
    MessagingProvider.of(context).getChatRequests();
    FriendsProvider.of(context).getOnlineFrineds();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: RefreshIndicator(
          onRefresh: _pullRefresh,
          child: Stack(
            children: [
              ListView(),
              SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: [
                      ChatRequestSection(),
                      SizedBox(
                        height: 16,
                      ),
                      OnlineFriendsSection()
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
