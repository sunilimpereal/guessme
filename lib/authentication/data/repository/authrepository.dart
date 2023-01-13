import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guessme/main.dart';

import '../models/user_model.dart';

class AuthRepository {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> addUser(UserModel user) async {
    await userCollection.doc(user.udid).set(user.toJson());
  }

  Future<List<UserModel>> getAllUsers() async {
    QuerySnapshot snapshot = await userCollection.get();
    List<UserModel> _userList =
        snapshot.docs.map((e) => userFromJson(jsonEncode(e.data()))).toList();
    _userList.removeWhere((element) => element.udid == sharedPref.udid);

    return _userList;
  }

  Future<UserModel> getUserFromId(String id) async {
    DocumentSnapshot snapshot = await userCollection.doc(id).get();
    return userFromJson(jsonEncode(snapshot.data()));
  }

  Future<Null> updateuserlastSeen(String id) async {
    DocumentSnapshot snapshot = await userCollection.doc(id).get();
    UserModel user = userFromJson(jsonEncode(snapshot.data()));
    user.lastSeen = DateTime.now();
    userCollection.doc(id).update(user.toJson());
  }

  Future<Null> updateUserOnileStatus(
      {required String id, required bool isOnline}) async {
    DocumentSnapshot snapshot = await userCollection.doc(id).get();
    UserModel user = userFromJson(jsonEncode(snapshot.data()));
    user.openToChat = isOnline;
    user.lastSeen = DateTime.now();
    userCollection.doc(id).update(user.toJson());
  }

  Future<Null> updatefcmToken(String id, String fcmtoken) async {
    DocumentSnapshot snapshot = await userCollection.doc(id).get();
    UserModel user = userFromJson(jsonEncode(snapshot.data()));
    user.fcmtoken = fcmtoken;
    userCollection.doc(id).update(user.toJson());
  }
}
