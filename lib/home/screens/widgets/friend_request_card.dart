import 'package:flutter/material.dart';
import 'package:guessme/authentication/data/models/user_model.dart';
import 'package:guessme/home/data/bloc/friends_bloc.dart';
import 'package:guessme/home/data/repository/friends_repository.dart';

import '../../../profile/screens/profile_screen.dart';
import '../../../profile/screens/widgets/card_profile_picture.dart';

class FriendRequestCard extends StatefulWidget {
  final UserModel userModel;
  const FriendRequestCard({super.key, required this.userModel});

  @override
  State<FriendRequestCard> createState() => _FriendRequestCardState();
}

class _FriendRequestCardState extends State<FriendRequestCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
            borderRadius: BorderRadius.circular(16),
            clipBehavior: Clip.hardEdge,
            child: Ink(
              child: InkWell(
                highlightColor: Colors.white,
                splashColor: Colors.red.shade50,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                                userModel: widget.userModel,
                              )));
                },
                child: Container(
                  height: 60,
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CardProfilePicture(udid: widget.userModel.udid),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            widget.userModel.name,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey.shade400),
                              onPressed: () async {},
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.cancel,
                                    size: 20,
                                  ),
                                ],
                              )),
                          const SizedBox(
                            width: 8,
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(),
                              onPressed: () async {
                                FriendsProvider.of(context).updateFriends();
                                await FriendsRepository()
                                    .acceptFriendRequest(widget.userModel);
                              },
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.check,
                                    size: 20,
                                  ),
                                  Text("Accept")
                                ],
                              )),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )));
  }
}
