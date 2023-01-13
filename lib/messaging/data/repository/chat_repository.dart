import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:guessme/authentication/data/models/user_model.dart';
import 'package:guessme/messaging/data/models/chat_message_modal.dart';
import 'package:guessme/messaging/data/models/create_chat_modal.dart';

import '../../../authentication/data/repository/authrepository.dart';
import '../../../main.dart';
import '../../../utils/config.dart';
import '../models/chat_request_notification_modal.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:http/http.dart' as http;

class chatRepository {
  final CollectionReference chatCollection =
      FirebaseFirestore.instance.collection('chat');
  Future<String> createChat(
      {required UserModel userModel, required UserModel currentUser}) async {
    //created the new chat document
    DocumentReference chat = await chatCollection
        .add(CreateChatModal(startTime: DateTime.now()).toJson());
    await addMemberToChat(userModel: userModel, chatId: chat.id);
    await addMemberToChat(userModel: currentUser, chatId: chat.id);
    //TODO: send notification to requested user

    sendNotificationtoUser(
        requestNotificationModal: RequestNotificationModal(
            to: userModel.fcmtoken,
            notification: Notification(
                body: "${currentUser.name} accepted your request",
                title: '${currentUser.name} connected'),
            data: NotificationData(
                type: "accepted_chat_request", id: "${chat.id}")),
        successMsg: "Accepted Chat Request");
    return chat.id;
  }

  Future<bool> addMemberToChat(
      {required UserModel userModel, required String chatId}) async {
    await chatCollection
        .doc(chatId)
        .collection("users")
        .doc(userModel.udid)
        .set(ChatUserModal(joinedTime: DateTime.now(), name: userModel.name)
            .toJson());

    return true;
  }

  Future<List<UserModel>> getMembersinChat({required String chatId}) async {
    QuerySnapshot snapshot =
        await chatCollection.doc(chatId).collection('users').get();
    List<UserModel> _userList = [];
    List<String> idList = snapshot.docs.map((e) {
      return e.id;
    }).toList();
    for (String id in idList) {
      UserModel user = await AuthRepository().getUserFromId(id);
      _userList.add(user);
    }
    _userList.removeWhere((element) => element.udid == sharedPref.udid);
    return _userList;
  }

  Future<bool> sendMessage(
      {required UserModel currentuserModel,
      required String chatId,
      required String message}) async {
    await chatCollection
        .doc(chatId)
        .collection("users")
        .doc(currentuserModel.udid)
        .collection("messages")
        .add(ChatMessageModal(
                udid: sharedPref.udid, time: DateTime.now(), message: message)
            .toJson());
    List<UserModel> _userList = await getMembersinChat(chatId: chatId);
    _userList.removeWhere((element) => element.udid == sharedPref.udid);
    for (UserModel userModel in _userList) {
      await sendNotificationtoUser(
          requestNotificationModal: RequestNotificationModal(
              to: userModel.fcmtoken,
              notification: Notification(
                  body: '${message}', title: "${currentuserModel.name}"),
              data:
                  NotificationData(type: "message_received", id: "${chatId}")),
          successMsg: "Accepted Chat Request");
    }

    return true;
  }

  Future<List<MessageModal>> getMessagesinChat({required String chatId}) async {
    List<MessageModal> messagesList = [];
    QuerySnapshot snapshot =
        await chatCollection.doc(chatId).collection('users').get();
    List<String> userIdList = snapshot.docs.map((e) => e.id).toList();
    for (String userId in userIdList) {
      UserModel userModel = await AuthRepository().getUserFromId(userId);
      final ref = firebase_storage.FirebaseStorage.instance
          .ref('files/profile_photos')
          .child(userModel.udid);
      String profileUrl = "";
      try {
        String profileUrl = await ref.getDownloadURL();
      } catch (e) {
        profileUrl = "";
      }
      QuerySnapshot messageSnapshot = await chatCollection
          .doc(chatId)
          .collection('users')
          .doc(userId)
          .collection("messages")
          .get();
      List<ChatMessageModal> userChatList = messageSnapshot.docs
          .map((e) => chatMessageModalFromJson(jsonEncode(e.data())))
          .toList();
      for (ChatMessageModal chatMessageModal in userChatList) {
        log(chatMessageModal.message);
        messagesList.add(MessageModal(
            chatMessage: chatMessageModal,
            imageUrl: profileUrl,
            userModel: userModel));
      }
    }
    return messagesList;
  }
}

Future<Null> sendNotificationtoUser(
    {required RequestNotificationModal requestNotificationModal,
    required String successMsg}) async {
  final uri = Uri.parse('https://fcm.googleapis.com/fcm/send');
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $fcmkey',
  };
  UserModel currentUser = await AuthRepository().getUserFromId(sharedPref.udid);
  log("notification body : " +
      requestNotificationModalToJson(requestNotificationModal));
  var response = await http.post(
    uri,
    headers: headers,
    body: requestNotificationModalToJson(requestNotificationModal),
  );
  log(response.body.toString());
  Fluttertoast.showToast(
    msg: successMsg + "  ${response.statusCode}", // message
    toastLength: Toast.LENGTH_SHORT, // length
    gravity: ToastGravity.BOTTOM, // location
  );
  if (response.statusCode == 200) {
    return null;
  } else {
    return null;
  }
}
