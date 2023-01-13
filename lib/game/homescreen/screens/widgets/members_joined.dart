import 'package:flutter/material.dart';
import 'package:guessme/authentication/data/models/user_model.dart';
import 'package:guessme/game/homescreen/bloc/game_bloc.dart';

class GameMembersJoined extends StatefulWidget {
  final String gameId;
  const GameMembersJoined({super.key, required this.gameId});
  @override
  State<GameMembersJoined> createState() => _GameMembersJoinedState();
}

class _GameMembersJoinedState extends State<GameMembersJoined> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserModel>>(
        stream: GameProvider.of(context).membersListStream,
        builder: (context, snapshot) {
          return Container();
        });
  }

  Widget memebrCard() {
    return Material(
      child: Container(
         
      ),
    );
  }
}
