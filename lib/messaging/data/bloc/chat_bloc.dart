import 'package:flutter/material.dart';
import 'package:guessme/messaging/data/models/chat_message_modal.dart';
import 'package:guessme/messaging/data/repository/chat_repository.dart';
import 'package:guessme/messaging/screen/chat_request_card.dart';
import 'package:rxdart/rxdart.dart';

import '../../../utils/bloc.dart';

class ChattingBloc extends Bloc {
  ChattingBloc();

  final _chatMeesagesListController = BehaviorSubject<List<MessageModal>>();

  Stream<List<MessageModal>> get chatMessages =>
      _chatMeesagesListController.stream.asBroadcastStream();

  void getChatMessages({required String chatId}) async {
    List<MessageModal> messages =
        await chatRepository().getMessagesinChat(chatId: chatId);
    _chatMeesagesListController.sink.add(messages);
  }
    void clearChatMessages() async {
    _chatMeesagesListController.sink.add([]);
  }

  @override
  void dispose() {
    _chatMeesagesListController.close();
  }
}

class ChattingProvider extends InheritedWidget {
  late ChattingBloc bloc;
  BuildContext context;
  ChattingProvider({Key? key, required Widget child, required this.context})
      : super(key: key, child: child) {
    bloc = ChattingBloc();
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static ChattingBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ChattingProvider>()
            as ChattingProvider)
        .bloc;
  }
}
