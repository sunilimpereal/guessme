import 'package:flutter/material.dart';
import 'package:guessme/authentication/bloc/validation_mixin.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with ValidationMixin {
  final _mobileNo = BehaviorSubject<String>();
  final _otp = BehaviorSubject<String>();
  final _username = BehaviorSubject<String>();

  //gettters
  Function(String) get changeMobNo => _mobileNo.sink.add;
  Function(String) get changeOtp => _otp.sink.add;
  Function(String) get changeUsername => _username.sink.add;

  //streams
  Stream<String> get mobileNo => _mobileNo.stream.transform(validatorNumber);
  Stream<String> get otp => _otp.stream.transform(validatorOtp);
  Stream<String> get username => _username.stream.transform(validatorUsername);

  Stream<List<String>> get validateFormMobStream => Rx.combineLatestList(
        [
          mobileNo,
        ],
      );
  dispose() {
    _mobileNo.close();
    _otp.close();
    _username.close();
  }
}

class LoginProvider extends InheritedWidget {
  final bloc = LoginBloc();
  LoginProvider({Key? key, required Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static LoginBloc? of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<LoginProvider>())!.bloc;
  }
}
