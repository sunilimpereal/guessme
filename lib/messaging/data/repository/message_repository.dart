import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:guessme/authentication/data/models/user_model.dart';
import 'package:guessme/authentication/data/repository/authrepository.dart';
import 'package:guessme/messaging/data/models/chat_request_notification_modal.dart';
import 'package:guessme/messaging/data/repository/chat_repository.dart';
import 'package:guessme/messaging/screen/chat_request_card.dart';

import '../../../home/data/models/friend_request_model.dart';
import '../../../main.dart';
import 'package:http/http.dart' as http;

import '../../../utils/config.dart';

class MessageRespoitory {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference receivedMessageRequests = FirebaseFirestore.instance
      .collection('users')
      .doc(sharedPref.udid)
      .collection('receivedChatRequest');

  final CollectionReference sentMessageRequests = FirebaseFirestore.instance
      .collection('users')
      .doc(sharedPref.udid)
      .collection('sentChatRequest');

  Future<Null> requestChat(UserModel userModel) async {
    await userCollection
        .doc(sharedPref.udid)
        .collection('sentChatRequest')
        .doc(userModel.udid)
        .set(FriendsModel(accepted: false, createdAt: DateTime.now().toString())
            .toJson());
    await userCollection
        .doc(userModel.udid)
        .collection('receivedChatRequest')
        .doc(sharedPref.udid)
        .set(FriendsModel(accepted: false, createdAt: DateTime.now().toString())
            .toJson());
    sendNotificationtoUser(
      requestNotificationModal: RequestNotificationModal(
        to: userModel.fcmtoken,
        notification: Notification(
            body: "tap to chat", title: '${sharedPref.name} is waving at you'),
        data: NotificationData(
          type: "received_chat_request",
          id: "",
        ),
      ),
      successMsg: "Accepted friend request",
    );
    return null;
  }

  Future<Null> deleterequestChat(UserModel userModel) async {
    await userCollection
        .doc(sharedPref.udid)
        .collection('sentChatRequest')
        .doc(userModel.udid)
        .delete();
    await userCollection
        .doc(userModel.udid)
        .collection('receivedChatRequest')
        .doc(sharedPref.udid)
        .delete();
    return null;
  }

  Future<Null> rejectRequestChat(UserModel userModel) async {
    await userCollection
        .doc(sharedPref.udid)
        .collection('receivedChatRequest')
        .doc(userModel.udid)
        .delete();
    await userCollection
        .doc(userModel.udid)
        .collection('sentChatRequest')
        .doc(sharedPref.udid)
        .delete();
    return null;
  }

  Future<List<UserModel>> getChatReceivedRequest() async {
    QuerySnapshot snapshot = await receivedMessageRequests.get();
    List<UserModel> _ChatReceivedRequestList = [];
    for (String id in snapshot.docs.map((e) => e.id).toList()) {
      UserModel user = await AuthRepository().getUserFromId(id);
      _ChatReceivedRequestList.add(user);
    }
    return _ChatReceivedRequestList;
  }

  Future<List<UserModel>> getChatSentRequest() async {
    QuerySnapshot snapshot = await sentMessageRequests.get();
    List<UserModel> _ChatSentRequestList = [];
    for (String id in snapshot.docs.map((e) => e.id).toList()) {
      UserModel user = await AuthRepository().getUserFromId(id);
      _ChatSentRequestList.add(user);
    }
    return _ChatSentRequestList;
  }

  // Future<Null> sendNotificationtoUser(UserModel user) async {
  //   final uri = Uri.parse('https://fcm.googleapis.com/fcm/send');
  //   final headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer $fcmkey',
  //   };
  //   UserModel currentUser =
  //       await AuthRepository().getUserFromId(sharedPref.udid);

  //   RequestNotificationModal chatRequestNotificationModal =
  //       RequestNotificationModal(
  //           to: user.fcmtoken,
  //           notification: Notification(
  //               title: '${currentUser.name} is waving', body: 'tap to connect'),
  //           data: NotificationData(type: "new_chat_request", id: ""));

  //   var response = await http.post(
  //     uri,
  //     headers: headers,
  //     body: requestNotificationModalToJson(chatRequestNotificationModal),
  //   );
  //   if (response.statusCode == 200) {
  //     Fluttertoast.showToast(
  //       msg: "Request sent to ${user.name}", // message
  //       toastLength: Toast.LENGTH_SHORT, // length
  //       gravity: ToastGravity.BOTTOM, // location
  //     );
  //     return null;
  //   } else {
  //     return null;
  //   }
  // }
}
