import 'package:flutter/cupertino.dart';
import 'package:guessme/authentication/data/models/user_model.dart';
import 'package:guessme/messaging/data/repository/message_repository.dart';
import 'package:guessme/utils/bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../home/data/repository/friends_repository.dart';

class MessagingBloc extends Bloc {
  MessagingBloc() {
    getChatRequests();
  }
  final _chatReceivedRequestController = BehaviorSubject<List<UserModel>>();
  final _chatSentRequestController = BehaviorSubject<List<UserModel>>();
  Stream<List<UserModel>> get chatReceivedRequest =>
      _chatReceivedRequestController.stream.asBroadcastStream();
  Stream<List<UserModel>> get chatSentRequest =>
      _chatSentRequestController.stream.asBroadcastStream();

  void getChatRequests() async {
    List<UserModel> receivedRequest =
        await MessageRespoitory().getChatReceivedRequest();
    List<UserModel> sentRequest =
        await MessageRespoitory().getChatSentRequest();
    _chatReceivedRequestController.sink.add(receivedRequest);
    _chatSentRequestController.sink.add(sentRequest);
  }

  @override
  void dispose() {
    _chatReceivedRequestController.close();
    _chatSentRequestController.close();
  }
}

class MessagingProvider extends InheritedWidget {
  late MessagingBloc bloc;
  BuildContext context;
  MessagingProvider({Key? key, required Widget child, required this.context})
      : super(key: key, child: child) {
    bloc = MessagingBloc();
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static MessagingBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<MessagingProvider>()
            as MessagingProvider)
        .bloc;
  }
}
