import 'package:flutter/material.dart';
import 'package:guessme/authentication/data/models/user_model.dart';
import 'package:guessme/authentication/data/repository/authrepository.dart';
import 'package:guessme/home/screens/home_scaffold.dart';
import 'package:guessme/main.dart';
import 'package:guessme/profile/screens/friends_list.dart';
import 'package:guessme/profile/screens/widgets/profile_picture.dart';
import 'package:guessme/settings/settings_screen.dart';
import 'package:guessme/utils/widgets/back_button.dart';

import '../../home/data/repository/friends_repository.dart';
import '../../home/screens/widgets/drawer.dart';

class MyProfileWidget extends StatefulWidget {
  const MyProfileWidget({super.key});

  @override
  State<MyProfileWidget> createState() => _MyProfileWidgetState();
}

class _MyProfileWidgetState extends State<MyProfileWidget> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.blueGrey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppBackButton(onPressed: () {
                    Navigator.pop(context);
                  }),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SettingsScreen()));
                      },
                      icon: const Icon(
                        Icons.settings,
                        size: 28,
                      ))
                ],
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SafeArea(
                    child: Container(
                      child: Column(
                        children: [
                          profileSection(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget profileSection() {
    return FutureBuilder<UserModel>(
        future: AuthRepository().getUserFromId(sharedPref.udid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          UserModel user = snapshot.data!;
          return Container(
            child: Column(
              children: [
                ProfilePicture(
                  userModel: user,
                ),
                const SizedBox(
                  height: 18,
                ),
                Text(
                  user.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    followerCount(),
                  ],
                )
              ],
            ),
          );
        });
  }

  Widget profileImage() {
    return Material(
      elevation: 10,
      color: Colors.white,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        width: 100,
        height: 100,
      ),
    );
  }

  Widget followerCount() {
    return FutureBuilder<List<UserModel>>(
        future: FriendsRepository().getFriends(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          List<UserModel> friends = snapshot.data!;
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FriendsListScreen(
                            friends: friends,
                          )));
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Text(
                    friends.length.toString(),
                    style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Friends",
                    style: TextStyle(color: Colors.grey.shade700),
                  )
                ],
              ),
            ),
          );
        });
  }
}
