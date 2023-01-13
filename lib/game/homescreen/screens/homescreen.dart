import 'package:flutter/material.dart';
import 'package:guessme/game/homescreen/screens/join_game.dart';
import 'package:guessme/game/homescreen/screens/start_game.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({Key? key}) : super(key: key);

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            logotext(context),
            startGame(),
            joinGame(),
          ],
        ),
      ),
    );
  }

  Widget startGame() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const StartGameScreen(),
          ),
        );
      },
      child: const Text("Start Game"),
    );
  }

  Widget joinGame() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const JoinGameScreen(),
          ),
        );
      },
      child: const Text("join Game"),
    );
  }
}

Widget logotext(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    padding: const EdgeInsets.all(8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text(
          "Not really Strangers",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    ),
  );
}
