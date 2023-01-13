// To parse this JSON data, do
//
//     final chatMessageModal = chatMessageModalFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:guessme/authentication/data/models/user_model.dart';

ChatMessageModal chatMessageModalFromJson(String str) =>
    ChatMessageModal.fromJson(json.decode(str));

String chatMessageModalToJson(ChatMessageModal data) =>
    json.encode(data.toJson());

class ChatMessageModal {
  ChatMessageModal(
      {required this.time, required this.message, required this.udid});

  String message;
  DateTime time;
  String udid;

  factory ChatMessageModal.fromJson(Map<String, dynamic> json) =>
      ChatMessageModal(
        message: json["message"],
        udid: json["udid"],
        time: DateTime.parse(json["time"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "udid": udid,
        "time": time.toString(),
      };
}

class MessageModal {
  ChatMessageModal chatMessage;
  UserModel userModel;
  String imageUrl;
  MessageModal({
    required this.chatMessage,
    required this.imageUrl,
    required this.userModel,
  });
}
