import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:guessme/authentication/screen/loginscreen.dart';
import 'package:guessme/main.dart';
import 'package:guessme/utils/widgets/top_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              const TopBar(left: "Settings"),
              tile(
                  iconData: Icons.logout,
                  title: "Logout",
                  ontap: () {
                    sharedPref.setLoggedOut();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  })
            ],
          ),
        ),
      ),
    );
  }

  Widget tile(
      {required IconData iconData,
      required String title,
      required Function ontap}) {
    return Material(
      child: Ink(
        child: InkWell(
          onTap: () {
            ontap();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Icon(iconData),
                  const SizedBox(
                    width: 16,
                  ),
                  Text(
                    title,
                    style: TextStyle(fontSize: 18),
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
