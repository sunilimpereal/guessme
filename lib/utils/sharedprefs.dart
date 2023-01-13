import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static SharedPreferences? _sharedPref;
  init() async {
    if (_sharedPref == null) {
      _sharedPref = await SharedPreferences.getInstance();
    }
  }

  //gettter
  bool get loggedIn => _sharedPref!.getBool('loggedIn') ?? false;
  String get udid => _sharedPref!.getString('udid') ?? "";
  String get mobile => _sharedPref!.getString('mobile') ?? "";
  String get name => _sharedPref!.getString('name') ?? "";

  ///Set as logged in
  setLoggedIn() {
    _sharedPref!.setBool('loggedIn', true);
  }

  /// Set as logged out
  setLoggedOut() {
    _sharedPref!.setBool('loggedIn', false);
    _sharedPref!.setString('udid', '');
  }

  /// Set  user details
  setUserDetails(
      {required String udid, required String mobile, required String name}) {
    _sharedPref!.setString('udid', udid);
    _sharedPref!.setString('mobile', mobile);
    _sharedPref!.setString('name', name);
  }

  setName({required String name}) {
    _sharedPref!.setString('name', name);
  }

  setVideoSourceType({required String source}) {
    _sharedPref!.setString('source', source);
  }
}

final sharedPrefs = SharedPref();
