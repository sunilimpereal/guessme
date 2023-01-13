// To parse this JSON data, do
//
//     final gameModel = gameModelFromJson(jsonString);

import 'dart:convert';

GameModel gameModelFromJson(String str) => GameModel.fromJson(json.decode(str));

String gameModelToJson(GameModel data) => json.encode(data.toJson());

class GameModel {
  GameModel({
    required this.startTime,
  });

  String startTime;

  factory GameModel.fromJson(Map<String, dynamic> json) => GameModel(
        startTime: json["start_time"],
      );

  Map<String, dynamic> toJson() => {
        "start_time": startTime,
      };
}
