import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guessme/authentication/data/models/user_model.dart';
import 'package:guessme/profile/screens/widgets/card_profile_picture.dart';

class ProfileFriendCard extends StatefulWidget {
  final UserModel userModel;
  const ProfileFriendCard({super.key, required this.userModel});

  @override
  State<ProfileFriendCard> createState() => _ProfileFriendCardState();
}

class _ProfileFriendCardState extends State<ProfileFriendCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.hardEdge,
        child: Container(
          height: 60,
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          color: Colors.white,
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
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0, backgroundColor: Colors.grey.shade100),
                  onPressed: () async {},
                  child: Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.solidMessage,
                        color: Colors.red.shade600,
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
