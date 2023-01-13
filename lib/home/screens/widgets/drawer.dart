import 'package:flutter/material.dart';
import 'package:guessme/explore/explore_screen.dart';
import 'package:guessme/friends/screens/friends_screen.dart';
import 'package:guessme/home/screens/home_scaffold.dart';
import 'package:guessme/friends/screens/widgets/friend_card.dart';
import 'package:guessme/home/screens/home_screen.dart';
import 'package:guessme/profile/screens/my_profile_screen.dart';
import 'package:guessme/profile/screens/profile_screen.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Drawer(
        backgroundColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Material(
              borderRadius: BorderRadius.circular(16),
              child: ListView(
                children: [
                  drawerItem(
                    iconData: Icons.people_alt,
                    text: "Home",
                    onpressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()));
                    },
                  ),
                  drawerItem(
                    iconData: Icons.handshake,
                    text: "Friends",
                    onpressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FriendsScreen()));
                    },
                  ),
                  drawerItem(
                    iconData: Icons.yard,
                    text: "Explore",
                    onpressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ExploreScreen()));
                    },
                  ),
                  drawerItem(
                    iconData: Icons.person,
                    text: "Profile",
                    onpressed: () {},
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget drawerItem(
      {required IconData iconData,
      required String text,
      required Function onpressed}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.hardEdge,
        child: Ink(
          child: InkWell(
            splashColor: Colors.red.shade100,
            highlightColor: Colors.red.shade50,
            onTap: () {
              onpressed();
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Icon(
                    iconData,
                    size: 32,
                    color: Colors.red.shade700,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    text,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
