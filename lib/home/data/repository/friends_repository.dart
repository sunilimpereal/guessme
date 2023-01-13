import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guessme/authentication/data/repository/authrepository.dart';
import 'package:guessme/home/data/models/friend_request_model.dart';
import 'package:guessme/main.dart';
import 'package:guessme/utils/sharedprefs.dart';

import '../../../authentication/data/models/user_model.dart';
import '../../../messaging/data/models/chat_request_notification_modal.dart';
import '../../../messaging/data/repository/chat_repository.dart';

class FriendsRepository {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference receivedfrinedsRequestsCollection =
      FirebaseFirestore.instance
          .collection('users')
          .doc(sharedPref.udid)
          .collection('receivedfrinedsRequests');
  final CollectionReference sentfrinedsRequestsCollection = FirebaseFirestore
      .instance
      .collection('users')
      .doc(sharedPref.udid)
      .collection('sentfrinedsRequests');
  final CollectionReference friendsCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(sharedPref.udid)
      .collection('friends');

  sendFriendRequest(UserModel user) {
    userCollection
        .doc(user.udid)
        .collection('receivedfrinedsRequests')
        .doc(sharedPref.udid)
        .set(FriendsModel(accepted: false, createdAt: DateTime.now().toString())
            .toJson());
    userCollection
        .doc(sharedPref.udid)
        .collection('sentfrinedsRequests')
        .doc(user.udid)
        .set(FriendsModel(accepted: false, createdAt: DateTime.now().toString())
            .toJson());
    sendNotificationtoUser(
      requestNotificationModal: RequestNotificationModal(
        to: user.fcmtoken,
        notification: Notification(
            body: "what do you say ?",
            title: '${sharedPref.name} wants to be your frined'),
        data: NotificationData(
          type: "received_friend_request",
          id: "",
        ),
      ),
      successMsg: "Accepted friend request",
    );
  }

  acceptFriendRequest(UserModel user) async {
    userCollection
        .doc(user.udid)
        .collection('friends')
        .doc(sharedPref.udid)
        .set(FriendsModel(accepted: true, createdAt: DateTime.now().toString())
            .toJson());
    userCollection
        .doc(sharedPref.udid)
        .collection('friends')
        .doc(user.udid)
        .set(FriendsModel(accepted: true, createdAt: DateTime.now().toString())
            .toJson());
    userCollection
        .doc(sharedPref.udid)
        .collection('receivedfrinedsRequests')
        .doc(user.udid)
        .delete();

    userCollection
        .doc(user.udid)
        .collection('sentfrinedsRequests')
        .doc(sharedPref.udid)
        .delete();
    UserModel currentUserModal =
        await AuthRepository().getUserFromId(sharedPref.udid);
    sendNotificationtoUser(
      requestNotificationModal: RequestNotificationModal(
        to: user.fcmtoken,
        notification: Notification(
            body: "You are now friends with ${sharedPref.name}",
            title: 'New Friend!'),
        data: NotificationData(
          type: "accepted_friend_request",
          id: "",
        ),
      ),
      successMsg: "Accepted friend request",
    );
  }

  removeFriend(UserModel user) async {
    userCollection
        .doc(user.udid)
        .collection('friends')
        .doc(sharedPref.udid)
        .delete();
    userCollection
        .doc(sharedPref.udid)
        .collection('friends')
        .doc(user.udid)
        .delete();
    userCollection
        .doc(sharedPref.udid)
        .collection('receivedfrinedsRequests')
        .doc(user.udid)
        .delete();

    userCollection
        .doc(user.udid)
        .collection('sentfrinedsRequests')
        .doc(sharedPref.udid)
        .delete();

    sendNotificationtoUser(
      requestNotificationModal: RequestNotificationModal(
        to: user.fcmtoken,
        notification: Notification(
            body: ":(", title: '${sharedPref.name} unfriended you'),
        data: NotificationData(
          type: "received_chat_request",
          id: "",
        ),
      ),
      successMsg: "Accepted friend request",
    );
  }

  declineFriendRequest(UserModel user) async {
    userCollection
        .doc(sharedPref.udid)
        .collection('receivedfrinedsRequests')
        .doc(user.udid)
        .delete();

    userCollection
        .doc(user.udid)
        .collection('sentfrinedsRequests')
        .doc(sharedPref.udid)
        .delete();
  }

  Future<List<UserModel>> getFriendRequests() async {
    QuerySnapshot snapshot = await receivedfrinedsRequestsCollection.get();
    List<UserModel> _friendList = [];

    for (String id in snapshot.docs.map((e) => e.id).toList()) {
      UserModel user = await AuthRepository().getUserFromId(id);
      _friendList.add(user);
    }
    return _friendList;
  }

  Future<List<UserModel>> getsentFriendRequests() async {
    QuerySnapshot snapshot = await sentfrinedsRequestsCollection.get();
    List<UserModel> _friendList = [];

    for (String id in snapshot.docs.map((e) => e.id).toList()) {
      UserModel user = await AuthRepository().getUserFromId(id);
      _friendList.add(user);
    }
    return _friendList;
  }

  Future<List<UserModel>> getFriends() async {
    QuerySnapshot snapshot = await friendsCollection.get();
    List<UserModel> _friendList = [];

    for (String id in snapshot.docs.map((e) => e.id).toList()) {
      UserModel user = await AuthRepository().getUserFromId(id);
      _friendList.add(user);
    }
    return _friendList;
  }

  Future<List<UserModel>> getFriendsfromId({required String udid}) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(udid)
        .collection('friends')
        .get();
    List<UserModel> _friendList = [];

    for (String id in snapshot.docs.map((e) => e.id).toList()) {
      UserModel user = await AuthRepository().getUserFromId(id);
      _friendList.add(user);
    }
    return _friendList;
  }

  Future<List<UserModel>> getExploreFriends() async {
    List<UserModel> allUsers = await AuthRepository().getAllUsers();
    List<UserModel> friends = await getFriends();
    allUsers.removeWhere((element) =>
        friends.map((e) => e.udid).toList().contains(element.udid));
    return allUsers;
  }

  Future<List<UserModel>> getOnlineFriends() async {
    QuerySnapshot snapshot = await friendsCollection.get();
    List<UserModel> _onlineFriendList = [];

    for (String id in snapshot.docs.map((e) => e.id).toList()) {
      UserModel user = await AuthRepository().getUserFromId(id);
      if (DateTime.now().difference(user.lastSeen).inMinutes < 4 ||
          user.openToChat) {
        _onlineFriendList.add(user);
      }
    }
    return _onlineFriendList;
  }
}
