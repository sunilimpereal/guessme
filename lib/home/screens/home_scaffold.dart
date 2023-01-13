import 'dart:async';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as flutterLocalNotificationsPlugin;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:guessme/authentication/data/models/user_model.dart';
import 'package:guessme/authentication/data/repository/authrepository.dart';
import 'package:guessme/bottombar/data/bottom_bar_bloc.dart';
import 'package:guessme/bottombar/widget/bottomBar.dart';
import 'package:guessme/explore/explore_screen.dart';
import 'package:guessme/friends/screens/friends_screen.dart';

import 'package:guessme/home/data/repository/friends_repository.dart';
import 'package:guessme/home/screens/home_screen.dart';
import 'package:guessme/home/screens/widgets/drawer.dart';
import 'package:guessme/friends/screens/widgets/friend_card.dart';
import 'package:guessme/home/screens/widgets/friend_request_card.dart';
import 'package:guessme/main.dart';
import 'package:guessme/messaging/data/repository/message_repository.dart';
import 'package:guessme/messaging/screen/chat_request_section.dart';
import 'package:guessme/messaging/screen/chat_screen.dart';
import 'package:guessme/profile/screens/widgets/profile_picture.dart';
import 'package:guessme/utils/notification_manager.dart';

import '../../messaging/data/bloc/messaging_bloc.dart';
import '../../profile/screens/my_profile_screen.dart';
import '../data/bloc/friends_bloc.dart';
import '../data/models/notification_data_modal.dart';

class HomeScaffold extends StatefulWidget {
  const HomeScaffold({super.key});

  @override
  State<HomeScaffold> createState() => _HomeScaffoldState();
}

class _HomeScaffoldState extends State<HomeScaffold> {
  late FirebaseMessaging messaging;
  @override
  void initState() {
    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) {
      log("fcm" + value.toString());
      AuthRepository().updatefcmToken(sharedPref.udid, value.toString());
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
      showhighpriorityNotification(event);
      handleNotification(
          data: NotificationDataModal(
              type: event.data["type"], id: event.data["id"]),
          context: context);
    });
    FirebaseMessaging.onBackgroundMessage((message) async {
      RemoteNotification notification = message.notification!;
      showhighpriorityNotification(message);
      handleNotification(
          data: NotificationDataModal(
              type: message.data["type"], id: message.data["id"]),
          context: context);
      return;
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      RemoteNotification notification = message.notification!;
      showhighpriorityNotification(message);
      handleNotification(
          data: NotificationDataModal(
              type: message.data["type"], id: message.data["id"]),
          context: context);
    });

    super.initState();
  }

  String profileUrl = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const HomeDrawer(),
      backgroundColor: Colors.blueGrey.shade50,
      body: Stack(
        children: [
          StreamBuilder<BottomBarItem>(
              stream: BottomBarProvider.of(context).currentBottombarItem,
              builder: (context, snapshot) {
                BottomBarItem selectedBottombarItem =
                    snapshot.data ?? BottomBarItem.chat;
                return SafeArea(
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                "Hi, ${sharedPref.name}",
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Material(
                                elevation: 5,
                                shadowColor: Colors.white,
                                borderRadius: BorderRadius.circular(1000),
                                clipBehavior: Clip.hardEdge,
                                child: Ink(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const MyProfileWidget()));
                                    },
                                    child: FutureBuilder<String>(
                                        future: getProfileImageUrl(
                                            udid: sharedPref.udid),
                                        builder: (context, snapshot) {
                                          return Container(
                                            padding: EdgeInsets.all(3),
                                            child: Material(
                                              borderRadius:
                                                  BorderRadius.circular(1000),
                                              elevation: 3,
                                              shadowColor: Colors.white,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          1000),
                                                ),
                                                height: 40,
                                                width: 40,
                                                child: CachedNetworkImage(
                                                  imageUrl: snapshot.data ?? '',
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) =>
                                                      const CircularProgressIndicator(),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Container(),
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                          height: MediaQuery.of(context).size.height - 180,
                          child: getScreen(selectedBottombarItem)),
                    ],
                  ),
                );
              }),
        ],
      ),
      bottomNavigationBar: BottomBar(),
    );
  }

  Widget getScreen(BottomBarItem bottomBarItem) {
    if (bottomBarItem == BottomBarItem.chat) {
      return HomeScreen();
    }
    if (bottomBarItem == BottomBarItem.friends) {
      return FriendsScreen();
    }
    if (bottomBarItem == BottomBarItem.explore) {
      return ExploreScreen();
    }
    return Container();
  }

  Future<void> _pullRefresh() async {
    FriendsProvider.of(context).updateFriends();
    MessagingProvider.of(context).getChatRequests();
  }
}

showhighpriorityNotification(RemoteMessage event) async {
  AndroidNotification? android = event.notification?.android;
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'default_notification_channel_id', // id
    'High Importance Notifications', // title
    importance: Importance.max,
  );
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  flutterLocalNotificationsPlugin.initialize(initializationSettings);
  print("message recieved" + event.data["id"]);
  flutterLocalNotificationsPlugin.show(
      event.notification.hashCode,
      event.notification!.title,
      event.notification!.body,
      NotificationDetails(
        android: AndroidNotificationDetails(channel.id, channel.name),
      ));
}
