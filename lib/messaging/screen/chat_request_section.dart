import 'package:flutter/material.dart';
import 'package:guessme/authentication/data/models/user_model.dart';
import 'package:guessme/messaging/data/bloc/messaging_bloc.dart';
import 'package:guessme/messaging/screen/chat_request_card.dart';

class ChatRequestSection extends StatefulWidget {
  const ChatRequestSection({super.key});

  @override
  State<ChatRequestSection> createState() => _ChatRequestSectionState();
}

class _ChatRequestSectionState extends State<ChatRequestSection> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserModel>>(
        stream: MessagingProvider.of(context).chatReceivedRequest,
        builder: (context, snapshot) {
          List<UserModel> receivedRequests = snapshot.data ?? [];
          if (receivedRequests.isEmpty) {
            return Container();
          }
          return Container(
            child: Column(
              children: receivedRequests.map((e) {
                return ChatRequestCard(userModel: e);
              }).toList(),
            ),
          );
        });
  }
}
