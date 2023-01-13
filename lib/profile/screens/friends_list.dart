import 'package:flutter/material.dart';
import 'package:guessme/authentication/data/models/user_model.dart';
import 'package:guessme/profile/screens/widgets/friends_card.dart';

class FriendsListScreen extends StatefulWidget {
  final List<UserModel> friends;
  const FriendsListScreen({super.key, required this.friends});

  @override
  State<FriendsListScreen> createState() => _FriendsListScreenState();
}

class _FriendsListScreenState extends State<FriendsListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Container(
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                        )),
                    const SizedBox(
                      width: 8,
                    ),
                    const Text(
                      "Friends",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Expanded(
                child: Column(
                    children: widget.friends
                        .map((e) => ProfileFriendCard(userModel: e))
                        .toList()),
              )
            ],
          ),
        ),
      ),
    );
  }
}
