import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:guessme/authentication/data/repository/authrepository.dart';
import 'package:guessme/authentication/screen/loginscreen.dart';
import 'package:guessme/bottombar/data/bottom_bar_bloc.dart';
import 'package:guessme/game/homescreen/bloc/game_bloc.dart';
import 'package:guessme/home/data/bloc/friends_bloc.dart';
import 'package:guessme/home/data/models/notification_data_modal.dart';
import 'package:guessme/home/screens/home_scaffold.dart';
import 'package:guessme/messaging/data/bloc/chat_bloc.dart';
import 'package:guessme/messaging/data/bloc/messaging_bloc.dart';
import 'package:guessme/messaging/data/models/chat_request_notification_modal.dart';
import 'package:guessme/theme/main_theme.dart';
import 'package:guessme/utils/notification_manager.dart';
import 'package:guessme/utils/sharedprefs.dart';

import 'authentication/bloc/login_bloc.dart';
import 'game/homescreen/screens/homescreen.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'default_notification_channel_id', // id
  'High Importance Notifications', // title
  importance: Importance.max,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  showhighpriorityNotification(message);

  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  await sharedPref.init();

  runApp(const AppProvoder());
}

SharedPref sharedPref = SharedPref();

class AppProvoder extends StatelessWidget {
  const AppProvoder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoginProvider(
      child: FriendsProvider(
        context: context,
        child: MessagingProvider(
          context: context,
          child: ChattingProvider(
            context: context,
            child: BottomBarProvider(
              context: context,
              child: GameProvider(
                context: context,
                child: const MyApp(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late FirebaseMessaging messaging;
  makeUserOnline() {
    log("made active");
    AuthRepository().updateUserOnileStatus(id: sharedPref.udid, isOnline: true);
  }

  @override
  void initState() {
    sharedPref.loggedIn ? makeUserOnline() : null;
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) {
      log("fcm" + value.toString());
      AuthRepository().updatefcmToken(sharedPref.udid, value.toString());
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive) {
      log("made inactive");
      await AuthRepository()
          .updateUserOnileStatus(id: sharedPref.udid, isOnline: false);
      await AuthRepository().updateuserlastSeen(sharedPref.udid);
    }
    if (state == AppLifecycleState.resumed) {
      log("made active");
      await AuthRepository()
          .updateUserOnileStatus(id: sharedPref.udid, isOnline: true);
      await AuthRepository().updateuserlastSeen(sharedPref.udid);
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guess me',
      theme: theme,
      home: sharedPref.loggedIn ? const HomeScaffold() : const LoginScreen(),
    );
  }
}
