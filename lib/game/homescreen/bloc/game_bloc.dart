import 'package:flutter/material.dart';
import 'package:guessme/authentication/data/models/user_model.dart';
import 'package:guessme/game/homescreen/repository/game_repository.dart';
import 'package:rxdart/rxdart.dart';

import '../../../utils/bloc.dart';

class GameBloc extends Bloc {
  GameBloc(BuildContext context);
  final _membersListController = BehaviorSubject<List<UserModel>>();
  Stream<List<UserModel>> get membersListStream =>
      _membersListController.stream.asBroadcastStream();

  void getMembersList({required String gameId}) async {
    List<UserModel> members =
        await GameRepository().getMembersinGame(gameId: gameId);
    _membersListController.sink.add(members);
  }

  @override
  void dispose() {
    _membersListController.close();
  }
}

class GameProvider extends InheritedWidget {
  late GameBloc bloc;
  BuildContext context;
  GameProvider({Key? key, required Widget child, required this.context})
      : super(key: key, child: child) {
    bloc = GameBloc(context);
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static GameBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<GameProvider>()
            as GameProvider)
        .bloc;
  }
}
