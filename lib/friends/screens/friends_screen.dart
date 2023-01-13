import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guessme/authentication/data/models/user_model.dart';
import 'package:guessme/home/data/bloc/friends_bloc.dart';
import 'package:guessme/home/data/repository/friends_repository.dart';
import 'package:guessme/home/screens/home_scaffold.dart';
import 'package:guessme/friends/screens/widgets/friend_card.dart';
import 'package:guessme/home/screens/widgets/friend_request_card.dart';
import 'package:guessme/messaging/data/bloc/messaging_bloc.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          friendRequests(),
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              "Friends",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          friendsList()
        ],
      ),
    );
  }

  Future<void> _pullRefresh() async {
    FriendsProvider.of(context).updateFriends();
    MessagingProvider.of(context).getChatRequests();
  }

  Widget friendRequests() {
    return StreamBuilder<List<UserModel>>(
        stream: FriendsProvider.of(context).friendsReceivedRequestListStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Container();
          }
          List<UserModel> friendRequestlist = snapshot.data!;
          return Container(
            padding: const EdgeInsets.all(0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Text(
                        "Friend Requests",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          friendRequestlist.length.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
                Column(
                    children: friendRequestlist
                        .map((e) => FriendRequestCard(userModel: e))
                        .toList())
              ],
            ),
          );
        });
  }

  Widget friendsList() {
    return StreamBuilder<List<UserModel>>(
        stream: FriendsProvider.of(context).friendsListStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          return Container(
              height: MediaQuery.of(context).size.height - 200,
              padding: const EdgeInsets.only(bottom: 50),
              child: SingleChildScrollView(
                child: Column(
                    children: snapshot.data!
                        .map((e) => FriendCard(userModel: e))
                        .toList()),
              ));
        });
  }
}
