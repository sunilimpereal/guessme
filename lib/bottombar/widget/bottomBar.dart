import 'dart:developer';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:guessme/authentication/data/repository/authrepository.dart';
import 'package:guessme/bottombar/data/bottom_bar_bloc.dart';
import 'package:guessme/home/data/bloc/friends_bloc.dart';
import 'package:lottie/lottie.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => BottomBarState();
}

class BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BottomBarItem>(
        stream: BottomBarProvider.of(context).currentBottombarItem,
        builder: (context, snapshot) {
          log(snapshot.data.toString());
          BottomBarItem selectedItem = snapshot.data ?? BottomBarItem.chat;
          return CurvedNavigationBar(
              index: getIndex(selectedItem),
              letIndexChange: (i) {
                BottomBarProvider.of(context)
                    .updateCurrentBottombarItem(getBottomBarItem(i));
                return true;
              },
              height: 55,
              backgroundColor: Colors.transparent,
              animationDuration: Duration(milliseconds: 400),
              items: [
                friends(selectedItem),
                chat(selectedItem),
                explore(selectedItem)
              ]);
        });
  }

  getIndex(BottomBarItem bottomBarItem) {
    if (bottomBarItem == BottomBarItem.friends) {
      return 0;
    }
    if (bottomBarItem == BottomBarItem.chat) {
      return 1;
    }
    if (bottomBarItem == BottomBarItem.explore) {
      return 2;
    }
  }

  getBottomBarItem(int index) {
    if (index == 0) {
      FriendsProvider.of(context).getfrinedsList();
      FriendsProvider.of(context).getfrinedsReceivedRequestList();
      return BottomBarItem.friends;
    }
    if (index == 1) {
      FriendsProvider.of(context).getOnlineFrineds();
      return BottomBarItem.chat;
    }
    if (index == 2) {
      AuthRepository().getAllUsers();

      return BottomBarItem.explore;
    }
  }

  Widget friends(BottomBarItem selectedItem) {
    return BottomBatIconWidget(
      lottie: "assets/lottie/friends.json",
      name: "friends",
      selectedItem: selectedItem,
      item: BottomBarItem.friends,
    );
  }

  Widget chat(BottomBarItem selectedItem) {
    return BottomBatIconWidget(
      lottie: "assets/lottie/chat.json",
      name: "friends",
      selectedItem: selectedItem,
      item: BottomBarItem.chat,
    );
  }

  Widget explore(BottomBarItem selectedItem) {
    return BottomBatIconWidget(
      lottie: "assets/lottie/explore.json",
      name: "friends",
      selectedItem: selectedItem,
      item: BottomBarItem.explore,
    );
  }
}

class BottomBatIconWidget extends StatefulWidget {
  final String name;
  final String lottie;
  final BottomBarItem selectedItem;
  final BottomBarItem item;
  const BottomBatIconWidget(
      {super.key,
      required this.lottie,
      required this.name,
      required this.item,
      required this.selectedItem});

  @override
  State<BottomBatIconWidget> createState() => _BottomBatIconWidgetState();
}

class _BottomBatIconWidgetState extends State<BottomBatIconWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(100),
      clipBehavior: Clip.hardEdge,
      child: GestureDetector(
        child: Container(
          color: Colors.white,
          height: widget.selectedItem == widget.item ? 40 : 40,
          width: widget.selectedItem == widget.item ? 40 : 40,
          child: Center(
            child: Lottie.asset(
              widget.lottie,
              repeat: false,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
