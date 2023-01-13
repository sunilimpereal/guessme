import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:guessme/game/homescreen/bloc/game_bloc.dart';
import 'package:guessme/game/homescreen/repository/game_repository.dart';
import 'package:guessme/game/homescreen/screens/game_chat.dart';
import 'package:guessme/game/homescreen/screens/homescreen.dart';
import 'package:guessme/game/homescreen/screens/widgets/button.dart';
import 'package:guessme/main.dart';
import 'package:guessme/messaging/screen/chat_screen.dart';

class StartGameScreen extends StatefulWidget {
  const StartGameScreen({super.key});

  @override
  State<StartGameScreen> createState() => _StartGameScreenState();
}

class _StartGameScreenState extends State<StartGameScreen> {
  _createGame() async {
    String id = await GameRepository().createNewGame(sharedPref.udid);
    setState(() {
      gameId = id;
    });
    GameProvider.of(context).getMembersList(gameId: gameId);
  }

  String gameId = "";

  @override
  void initState() {
    _createGame();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  text(),
                  code(),
                  link(),
                  startGameButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget text() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          logotext(context),
          const SizedBox(
            height: 8,
          ),
          const Text("Invite People"),
        ],
      ),
    );
  }

  Widget link() {
    Widget icon({
      required String image,
      required Function onPressed,
    }) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Material(
          borderRadius: BorderRadius.circular(100),
          elevation: 10,
          clipBehavior: Clip.hardEdge,
          child: Ink(
            child: InkWell(
              onTap: () {
                onPressed();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      image: DecorationImage(image: AssetImage(image))),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Invite Friends",
            style: TextStyle(),
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Row(
              children: [
                icon(image: "assets/images/whatsapplogo.png", onPressed: () {}),
                icon(image: "assets/images/snapchatlogo.png", onPressed: () {}),
                icon(image: "assets/images/instagramlogo.png", onPressed: () {})
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget code() {
    Widget codeBox() {
      return Material(
          borderRadius: BorderRadius.circular(8),
          child: Ink(
            child: InkWell(
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(8)),
                width: MediaQuery.of(context).size.width * 0.5,
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      flex: 7,
                      child: Text(
                        gameId,
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.copy),
                    ),
                  ],
                ),
              ),
            ),
          ));
    }

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Game Code"),
          const SizedBox(
            height: 16,
          ),
          codeBox()
        ],
      ),
    );
  }

  Widget startGameButton() {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AsyncButton(
              onPressed: () async {
                return;
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text("Start Game"),
              ),
            )
          ],
        ));
  }
}
