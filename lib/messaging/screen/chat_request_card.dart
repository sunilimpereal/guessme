import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:guessme/authentication/data/models/user_model.dart';
import 'package:guessme/authentication/data/repository/authrepository.dart';
import 'package:guessme/main.dart';
import 'package:guessme/messaging/data/bloc/messaging_bloc.dart';
import 'package:guessme/messaging/data/models/create_chat_modal.dart';
import 'package:guessme/messaging/data/repository/chat_repository.dart';
import 'package:guessme/messaging/data/repository/message_repository.dart';
import 'package:guessme/messaging/screen/chat_screen.dart';
import 'package:rxdart/rxdart.dart';

class ChatRequestCard extends StatefulWidget {
  final UserModel userModel;
  const ChatRequestCard({Key? key, required this.userModel}) : super(key: key);

  @override
  State<ChatRequestCard> createState() => _ChatRequestCardState();
}

class _ChatRequestCardState extends State<ChatRequestCard> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 100,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: [
            Color(0xff28C69C),
            Color(0xff0DCB72),
          ],
        )),
        child: Column(
          children: [name(), function()],
        ),
      ),
    );
  }

  Widget name() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                widget.userModel.name,
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                " is waving at you",
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget function() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.red.shade200,
                backgroundColor: Colors.white,
                elevation: 10),
            onPressed: () async {
              await MessageRespoitory().rejectRequestChat(widget.userModel);
              MessagingProvider.of(context).getChatRequests();
            },
            child: Row(
              children: const [
                Icon(
                  Icons.crop_square_sharp,
                  color: Colors.red,
                ),
              ],
            )),
        const SizedBox(
          width: 8,
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.green.shade200,
                backgroundColor: Colors.white,
                elevation: 10),
            onPressed: () async {
              UserModel currentUser =
                  await AuthRepository().getUserFromId(sharedPref.udid);
              chatRepository()
                  .createChat(
                      userModel: widget.userModel, currentUser: currentUser)
                  .then((chatId) {
                log("chatId : " + chatId);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChatScreen(
                              userModel: widget.userModel,
                              currentuser: currentUser,
                              chatId: chatId,
                            )));
              });
            },
            child: Row(
              children: const [
                Icon(
                  Icons.check,
                  color: Colors.green,
                ),
                Text(
                  "Accept",
                  style: TextStyle(color: Colors.green),
                ),
              ],
            )),
        const SizedBox(
          width: 8,
        ),
      ],
    );
  }
}
