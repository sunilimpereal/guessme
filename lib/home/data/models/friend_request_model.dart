// To parse this JSON data, do
//
//     final friendsModel = friendsModelFromJson(jsonString);

import 'dart:convert';

FriendsModel friendsModelFromJson(String str) =>
    FriendsModel.fromJson(json.decode(str));

String friendsModelToJson(FriendsModel data) => json.encode(data.toJson());

class FriendsModel {
  FriendsModel({
    required this.accepted,
    required this.createdAt,
  });

  bool accepted;
  String createdAt;

  factory FriendsModel.fromJson(Map<String, dynamic> json) => FriendsModel(
        accepted: json["accepted"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "accepted": accepted,
        "created_at": createdAt,
      };
}
