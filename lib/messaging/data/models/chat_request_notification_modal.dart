// To parse this JSON data, do
//
//     final requestNotificationModal = requestNotificationModalFromJson(jsonString);

import 'dart:convert';

RequestNotificationModal requestNotificationModalFromJson(String str) =>
    RequestNotificationModal.fromJson(json.decode(str));

String requestNotificationModalToJson(RequestNotificationModal data) =>
    json.encode(data.toJson());

class RequestNotificationModal {
  RequestNotificationModal({
    required this.to,
    required this.notification,
    required this.data,
  });

  String to;
  Notification notification;
  NotificationData data;

  factory RequestNotificationModal.fromJson(Map<String, dynamic> json) =>
      RequestNotificationModal(
        to: json["to"],
        notification: Notification.fromJson(json["notification"]),
        data: NotificationData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "to": to,
        "notification": notification.toJson(),
        "data": data.toJson(),
      };
}

class NotificationData {
  NotificationData({
    required this.type,
    required this.id,
  });

  String type;
  String id;

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      NotificationData(
        type: json["type"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "id": id,
      };
}

class Notification {
  Notification({
    required this.title,
    required this.body,
  });

  String title;
  String body;

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
        title: json["title"],
        body: json["body"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "body": body,
        "android_channel_id": "default_notification_channel_id"
      };
}
