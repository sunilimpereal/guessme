// To parse this JSON data, do
//
//     final notificationDataModal = notificationDataModalFromJson(jsonString);

import 'dart:convert';

NotificationDataModal notificationDataModalFromJson(String str) =>
    NotificationDataModal.fromJson(json.decode(str));

String notificationDataModalToJson(NotificationDataModal data) =>
    json.encode(data.toJson());

class NotificationDataModal {
  NotificationDataModal({
    required this.type,
    required this.id,
  });

  String type;
  String id;

  factory NotificationDataModal.fromJson(Map<String, dynamic> json) =>
      NotificationDataModal(
        type: json["type"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "id": id,
      };
}
