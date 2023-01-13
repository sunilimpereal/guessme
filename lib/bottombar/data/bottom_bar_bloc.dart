import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:guessme/utils/bloc.dart';
import 'package:rxdart/rxdart.dart';

enum BottomBarItem {
  friends,
  chat,
  explore,
}

class BottomBarBloc extends Bloc {
  BuildContext context;
  BottomBarBloc(this.context);
  final _indexcontroller = BehaviorSubject<BottomBarItem>();
  Stream<BottomBarItem> get currentBottombarItem =>
      _indexcontroller.stream.asBroadcastStream();

  void updateCurrentBottombarItem(BottomBarItem bottomBarItem) {
    _indexcontroller.sink.add(bottomBarItem);
  }

  @override
  void dispose() {
    _indexcontroller.close();
  }
}

class BottomBarProvider extends InheritedWidget {
  late BottomBarBloc bloc;
  BuildContext context;
  BottomBarProvider({Key? key, required Widget child, required this.context})
      : super(key: key, child: child) {
    bloc = BottomBarBloc(context);
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static BottomBarBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<BottomBarProvider>()
            as BottomBarProvider)
        .bloc;
  }
}
