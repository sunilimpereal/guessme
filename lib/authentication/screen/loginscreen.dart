import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:guessme/authentication/bloc/login_bloc.dart';
import 'package:guessme/authentication/data/repository/authrepository.dart';
import 'package:guessme/authentication/screen/new_user_screen.dart';
import 'package:guessme/authentication/screen/widgets/textfield.dart';
import 'package:guessme/home/data/bloc/friends_bloc.dart';
import 'package:guessme/home/screens/home_scaffold.dart';
import 'package:guessme/main.dart';

import '../../theme/main_theme.dart';

enum MobileVerificationState {
  showMobileNumberState,
  showOtpState,
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController mobileNoController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  MobileVerificationState currentState =
      MobileVerificationState.showMobileNumberState;
  late String verificationId;
  bool showLoading = false;
  bool showloadingOtp = false;
  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    try {
      final authCredentail =
          await _auth.signInWithCredential(phoneAuthCredential);
      setState(() {
        showloadingOtp = false;
      });
      if (authCredentail.user != null) {
        sharedPref.setLoggedIn();
        sharedPref.setUserDetails(
          udid: authCredentail.user!.uid,
          mobile: authCredentail.user!.phoneNumber!,
          name: authCredentail.user!.displayName ?? '',
        );
        if (authCredentail.additionalUserInfo!.isNewUser) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const NewUserScreen()));
        } else {
          FriendsProvider.of(context).updateFriends();
          FirebaseMessaging messaging = FirebaseMessaging.instance;
          String token = await messaging.getToken() ?? '';
          AuthRepository().updatefcmToken(authCredentail.user!.uid, token);
          FriendsProvider.of(context).updateFriends();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomeScaffold()));
        }
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        showloadingOtp = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    LoginBloc? loginBloc = LoginProvider.of(context);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment(0.8, 1),
                colors: <Color>[
                  Color(0xffA29EF1),
                  Color(0xffC3C1EA),
                ],
                tileMode: TileMode.mirror,
              ),
            ),
          ),
          Center(
            child: currentState == MobileVerificationState.showMobileNumberState
                ? loginWidget(loginBloc!)
                : otpWidget(loginBloc!),
          ),
        ],
      ),
    );
  }

  Widget loginWidget(LoginBloc loginBloc) {
    return Material(
      color: Colors.white,
      elevation: 50,
      borderRadius: borderRadius16,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: 250,
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Lets set you up!",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 21,
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Textfield(
              label: 'Mobile No.',
              controller: mobileNoController,
              onChanged: loginBloc.changeMobNo,
              stream: loginBloc.mobileNo,
              inputType: TextInputType.phone,
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                    onPressed: () async {
                      setState(() {
                        showLoading = true;
                      });
                      await _auth.verifyPhoneNumber(
                        phoneNumber: "+91" + mobileNoController.text,
                        verificationCompleted: (phoneAuthCredential) async {
                          setState(() {
                            showLoading = false;
                          });
                        },
                        verificationFailed: (phoneVerificationFailed) async {},
                        codeSent: (verificationIdt, resendingToken) {
                          setState(() {
                            showLoading = false;

                            currentState = MobileVerificationState.showOtpState;
                            verificationId = verificationIdt;
                          });
                        },
                        codeAutoRetrievalTimeout: (verificationId) async {},
                      );
                    },
                    child: Container(
                        width: 150,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 8,
                        ),
                        child:
                            showLoading ? loadingWidget() : Text("Send OTP"))),
              ],
            ),
            const SizedBox(
              height: 0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "New to Guess me? ",
                  style: TextStyle(),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.all(0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget otpWidget(LoginBloc loginBloc) {
    return Material(
      color: Colors.white,
      elevation: 50,
      borderRadius: borderRadius16,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: 250,
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Enter OTP",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Textfield(
              label: "otp",
              controller: otpController,
              onChanged: loginBloc.changeOtp,
              stream: loginBloc.otp,
              inputType: TextInputType.number,
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                    onPressed: () async {
                      setState(() {
                        showloadingOtp = true;
                      });
                      final phoneAuthCredential = PhoneAuthProvider.credential(
                          verificationId: verificationId,
                          smsCode: otpController.text);
                      signInWithPhoneAuthCredential(phoneAuthCredential);
                    },
                    child: Container(
                        width: 150,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 8,
                        ),
                        child: showloadingOtp
                            ? loadingWidget()
                            : const Text("Login"))),
              ],
            ),
            const SizedBox(
              height: 0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "New to Guess me? ",
                  style: TextStyle(),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.all(0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class loadingWidget extends StatelessWidget {
  const loadingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 16,
      width: 16,
      child: CircularProgressIndicator(
        color: Colors.white,
        strokeWidth: 3,
      ),
    );
  }
}
