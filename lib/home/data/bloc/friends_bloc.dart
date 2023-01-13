import 'package:flutter/material.dart';
import 'package:guessme/authentication/data/models/user_model.dart';
import 'package:guessme/home/data/repository/friends_repository.dart';
import 'package:rxdart/rxdart.dart';

import '../../../utils/bloc.dart';

class FriendsBloc extends Bloc {
  BuildContext context;
  FriendsBloc(this.context) {
    getfrinedsList();
    getfrinedsReceivedRequestList();
    getfrinedsSentRequestList();
    getOnlineFrineds();
  }
  final _frinedsListController = BehaviorSubject<List<UserModel>>();
  final _frinedReceivedRequestController = BehaviorSubject<List<UserModel>>();
  final _frinedSentRequestController = BehaviorSubject<List<UserModel>>();
  final _onlineFriendsController = BehaviorSubject<List<UserModel>>();

  Stream<List<UserModel>> get friendsListStream =>
      _frinedsListController.stream.asBroadcastStream();

  Stream<List<UserModel>> get friendsReceivedRequestListStream =>
      _frinedReceivedRequestController.stream.asBroadcastStream();
  Stream<List<UserModel>> get friendsSentRequestListStream =>
      _frinedSentRequestController.stream.asBroadcastStream();
  Stream<List<UserModel>> get onlineFriendsStream =>
      _onlineFriendsController.stream.asBroadcastStream();
  void getfrinedsList() async {
    List<UserModel> friends = await FriendsRepository().getFriends();
    _frinedsListController.sink.add(friends);
  }

  void getfrinedsReceivedRequestList() async {
    List<UserModel> receivedRequestlist =
        await FriendsRepository().getFriendRequests();
    _frinedReceivedRequestController.sink.add(receivedRequestlist);
  }

  void getfrinedsSentRequestList() async {
    List<UserModel> sentfriendsRequest =
        await FriendsRepository().getsentFriendRequests();
    _frinedSentRequestController.sink.add(sentfriendsRequest);
  }

  getOnlineFrineds() async {
    List<UserModel> onlineFriends =
        await FriendsRepository().getOnlineFriends();
    _onlineFriendsController.sink.add(onlineFriends);
  }

  void updateFriends() {
    getfrinedsList();
    getfrinedsReceivedRequestList();
    getfrinedsSentRequestList();
  }

  @override
  void dispose() {
    _frinedsListController.close();
    _frinedSentRequestController.close();
    _frinedReceivedRequestController.close();
  }
}

class FriendsProvider extends InheritedWidget {
  late FriendsBloc bloc;
  BuildContext context;
  FriendsProvider({Key? key, required Widget child, required this.context})
      : super(key: key, child: child) {
    bloc = FriendsBloc(context);
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static FriendsBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<FriendsProvider>()
            as FriendsProvider)
        .bloc;
  }
}
