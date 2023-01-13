import 'package:flutter/material.dart';
import 'package:guessme/authentication/data/models/user_model.dart';
import 'package:guessme/friends/screens/widgets/friend_card.dart';
import 'package:guessme/home/data/bloc/friends_bloc.dart';

class OnlineFriendsSection extends StatefulWidget {
  const OnlineFriendsSection({Key? key}) : super(key: key);

  @override
  State<OnlineFriendsSection> createState() => _OnlineFriendsSectionState();
}

class _OnlineFriendsSectionState extends State<OnlineFriendsSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title(text: "Available"),
                StreamBuilder<List<UserModel>>(
                    stream: FriendsProvider.of(context).onlineFriendsStream,
                    builder: (context, snapshot) {
                      List<UserModel> onlineFrineds = snapshot.data ?? [];
                      return Container(
                        child: Column(
                          children: onlineFrineds
                              .map((e) => FriendCard(userModel: e))
                              .toList(),
                        ),
                      );
                    })
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget title({required String text}) {
    return Container(
      padding: EdgeInsets.all(12),
      width: MediaQuery.of(context).size.width,
      child: Text(
        text,
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontStyle: FontStyle.italic),
      ),
    );
  }
}
