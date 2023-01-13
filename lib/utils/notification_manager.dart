import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guessme/authentication/data/models/user_model.dart';
import 'package:guessme/authentication/data/repository/authrepository.dart';
import 'package:guessme/bottombar/data/bottom_bar_bloc.dart';
import 'package:guessme/home/data/bloc/friends_bloc.dart';
import 'package:guessme/home/data/models/notification_data_modal.dart';
import 'package:guessme/main.dart';
import 'package:guessme/messaging/data/bloc/chat_bloc.dart';
import 'package:guessme/messaging/data/bloc/messaging_bloc.dart';
import 'package:guessme/messaging/data/repository/chat_repository.dart';
import 'package:guessme/messaging/screen/chat_screen.dart';

import '../authentication/screen/new_user_screen.dart';

handleNotification(
    {required NotificationDataModal data,
    required BuildContext context}) async {
  if (data.type == "accepted_chat_request") {
    UserModel user =
        (await chatRepository().getMembersinChat(chatId: data.id))[0];
    UserModel currentUser =
        await AuthRepository().getUserFromId(sharedPref.udid);
    // ignore: use_build_context_synchronously
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatScreen(
                  chatId: data.id,
                  currentuser: currentUser,
                  userModel: user,
                )));
  }
  if (data.type == "received_chat_request") {
    UserModel user =
        (await chatRepository().getMembersinChat(chatId: data.id))[0];
    UserModel currentUser =
        await AuthRepository().getUserFromId(sharedPref.udid);
    log("received chat request");
    // ignore: use_build_context_synchronously
    BottomBarProvider.of(context)
        .updateCurrentBottombarItem(BottomBarItem.friends);
    MessagingProvider.of(context).getChatRequests();
  }
  if (data.type == "received_friend_request") {
    BottomBarProvider.of(context)
        .updateCurrentBottombarItem(BottomBarItem.chat);

    FriendsProvider.of(context).getfrinedsReceivedRequestList();
    // ignore: use_build_context_synchronously

  }
  if (data.type == "accepted_friend_request") {
    // changeProvider to friends and get frineds request list
    BottomBarProvider.of(context)
        .updateCurrentBottombarItem(BottomBarItem.chat);
    FriendsProvider.of(context).getfrinedsReceivedRequestList();
  }
  if (data.type == "message_received") {
    ChattingProvider.of(context).getChatMessages(chatId: data.id);
  }
}
