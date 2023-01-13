// To parse this JSON data, do
//
//     final createChatModal = createChatModalFromJson(jsonString);

import 'dart:convert';

CreateChatModal createChatModalFromJson(String str) =>
    CreateChatModal.fromJson(json.decode(str));

String createChatModalToJson(CreateChatModal data) =>
    json.encode(data.toJson());

class CreateChatModal {
  CreateChatModal({
    required this.startTime,
  });

  DateTime startTime;

  factory CreateChatModal.fromJson(Map<String, dynamic> json) =>
      CreateChatModal(
        startTime: DateTime.parse(json["start_time"]),
      );

  Map<String, dynamic> toJson() => {
        "start_time": startTime.toString(),
      };
}

// To parse this JSON data, do
//
//     final chatUserModal = chatUserModalFromJson(jsonString);

ChatUserModal chatUserModalFromJson(String str) =>
    ChatUserModal.fromJson(json.decode(str));

String chatUserModalToJson(ChatUserModal data) => json.encode(data.toJson());

class ChatUserModal {
  ChatUserModal({
    required this.joinedTime,
    required this.name,
  });

  DateTime joinedTime;
  String name;

  factory ChatUserModal.fromJson(Map<String, dynamic> json) => ChatUserModal(
        joinedTime: DateTime.parse(json["joined_time"]),
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "joined_time": joinedTime.toString(),
        "name": name,
      };
}
