import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class GameChatScreen extends StatefulWidget {
  final String gameId;
  const GameChatScreen({super.key, required this.gameId});

  @override
  State<GameChatScreen> createState() => _GameChatScreenState();
}

class _GameChatScreenState extends State<GameChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
