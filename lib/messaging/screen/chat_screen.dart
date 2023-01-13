import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:guessme/authentication/data/models/user_model.dart';
import 'package:guessme/authentication/data/repository/authrepository.dart';
import 'package:guessme/home/screens/widgets/user_card_home.dart';
import 'package:guessme/main.dart';
import 'package:guessme/messaging/data/bloc/chat_bloc.dart';
import 'package:guessme/messaging/data/models/chat_message_modal.dart';
import 'package:guessme/messaging/data/repository/chat_repository.dart';
import 'package:guessme/utils/widgets/top_bar.dart';

import '../../utils/widgets/back_button.dart';

class ChatScreen extends StatefulWidget {
  final UserModel userModel;
  final UserModel currentuser;
  final String chatId;
  const ChatScreen(
      {super.key,
      required this.userModel,
      required this.chatId,
      required this.currentuser});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageTextController = TextEditingController();
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MessageModal>>(
        stream: ChattingProvider.of(context).chatMessages,
        builder: (context, snapshot) {
          List<MessageModal> messages = snapshot.data ?? [];
          log(messages.toString());
          messages
              .sort((a, b) => a.chatMessage.time.compareTo(b.chatMessage.time));
          return Scaffold(
            body: SafeArea(
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    padding: EdgeInsets.only(top: 70, bottom: 80),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Container(
                        child: Column(
                          children: messages.map((e) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                mainAxisAlignment:
                                    sharedPref.udid == e.chatMessage.udid
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.start,
                                children: [
                                  MessageChip(
                                      dateTime: e.chatMessage.time,
                                      message: e.chatMessage.message)
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    // chat Column
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    child: Stack(
                      children: [
                        Positioned(top: 0, child: topBar()),
                        Positioned(bottom: 0, child: bottomBar()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget topBar() {
    return Material(
      elevation: 5,
      shadowColor: Colors.white,
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
      child: Container(
        height: 70,
        padding: const EdgeInsets.all(4),
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 8,
                ),
                //backbutton
                AppBackButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ChattingProvider.of(context).clearChatMessages();
                  },
                ),
                const SizedBox(
                  width: 8,
                ),
                nameAndStatus(),

                //profile pic
                // name & online
                //
              ],
            ),
            leave()
          ],
        ),
      ),
    );
  }

  Widget profilePictire() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          100000,
        ),
      ),
    );
  }

  Widget nameAndStatus() {
    String status = getOnlineStatus(lastSeen: widget.userModel.lastSeen);
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            widget.userModel.name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              status == "Online"
                  ? Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(1000),
                      ),
                    )
                  : Container(),
              SizedBox(
                width: 4,
              ),
              Text(
                status,
                style: TextStyle(
                  fontSize: 14,
                  // fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget leave() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              elevation: 0, backgroundColor: Colors.grey.shade200),
          onPressed: () {},
          child: const Text(
            "Leave",
            style: TextStyle(
              color: Colors.red,
            ),
          )),
    );
  }

  Widget bottomBar() {
    return Material(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      elevation: 20,
      clipBehavior: Clip.hardEdge,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 80,
        color: Colors.white,
        child: Row(
          children: [
            textField(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(),
              onPressed: () {
                if (messageTextController.text.isNotEmpty) {
                  chatRepository()
                      .sendMessage(
                          currentuserModel: widget.currentuser,
                          chatId: widget.chatId,
                          message: messageTextController.text)
                      .then((value) {
                    ChattingProvider.of(context)
                        .getChatMessages(chatId: widget.chatId);
                    setState(() {
                      messageTextController.clear();
                      scrollController.animateTo(
                          scrollController.position.maxScrollExtent,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeIn);
                    });
                  });
                }
              },
              child: Container(height: 50, child: Icon(Icons.send)),
            )
          ],
        ),
      ),
    );
  }

  Widget textField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          height: 50,
          width: MediaQuery.of(context).size.width * 0.75,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey.shade200,
          ),
          padding: const EdgeInsets.all(8),
          child: Center(
            child: TextField(
              controller: messageTextController,
              decoration: InputDecoration.collapsed(hintText: 'Message...'),
            ),
          )),
    );
  }
}

class MessageChip extends StatelessWidget {
  final String message;
  final DateTime dateTime;
  const MessageChip({super.key, required this.dateTime, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.red.shade100,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(16),
            topLeft: Radius.circular(16),
          ),
        ),
        child: Text(
          message,
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
