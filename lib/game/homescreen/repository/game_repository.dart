import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guessme/authentication/data/models/user_model.dart';
import 'package:guessme/game/homescreen/models/game_model.dart';

import '../../../authentication/data/repository/authrepository.dart';
import '../../../main.dart';
import '../../../messaging/data/models/chat_request_notification_modal.dart';
import '../../../messaging/data/repository/chat_repository.dart';

class GameRepository {
  final CollectionReference gameGollection =
      FirebaseFirestore.instance.collection('games');

  Future<String> createNewGame(String udid) async {
    String id = generateRandomNum(length: 4);
    gameGollection
        .doc(id)
        .set(GameModel(startTime: DateTime.now().toIso8601String()).toJson());
    gameGollection
        .doc(id)
        .collection("users")
        .doc(udid)
        .set(GameModel(startTime: DateTime.now().toIso8601String()).toJson());

    return id;
  }

  Future<bool> joinGame(UserModel user, String id) async {
    gameGollection
        .doc(id)
        .collection("users")
        .doc(user.udid)
        .set(GameModel(startTime: DateTime.now().toIso8601String()).toJson());
    sendNotificationtoUser(
      requestNotificationModal: RequestNotificationModal(
        to: user.fcmtoken,
        notification:
            Notification(body: "", title: '${sharedPref.name} joined the game'),
        data: NotificationData(
          type: "received_friend_request",
          id: "",
        ),
      ),
      successMsg: "Joined game",
    );
    return true;
  }

  Future<List<UserModel>> getMembersinGame({required String gameId}) async {
    QuerySnapshot snapshot =
        await gameGollection.doc(gameId).collection("users").get();
    List<UserModel> _membersList = [];
    for (String id in snapshot.docs.map((e) => e.id).toList()) {
      UserModel user = await AuthRepository().getUserFromId(id);
      _membersList.add(user);
    }
    return _membersList;
  }

  String generateRandomNum({required int length}) {
    String code = "";
    for (int i = 0; i < length; i++) {
      code = code + Random().nextInt(10).toString();
    }
    return code;
  }
}
