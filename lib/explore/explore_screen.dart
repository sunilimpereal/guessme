import 'package:flutter/material.dart';
import 'package:guessme/home/data/repository/friends_repository.dart';
import 'package:guessme/home/screens/home_scaffold.dart';

import '../authentication/data/models/user_model.dart';
import '../authentication/data/repository/authrepository.dart';
import '../home/screens/widgets/user_card_home.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        explore(),
      ],
    );
  }

  Widget explore() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(12.0),
          child: Text(
            "Explore",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
        Container(
          child: FutureBuilder<List<UserModel>>(
              future: FriendsRepository().getExploreFriends(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                return Container(
                  height: MediaQuery.of(context).size.height - 235,
                  child: SingleChildScrollView(
                    child: Column(
                        children: snapshot.data!
                            .map((e) => UserCardHome(userModel: e))
                            .toList()),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
