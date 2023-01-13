import 'dart:async';

class ValidationMixin {
  final validatorNumber = StreamTransformer<String, String>.fromHandlers(
      handleData: (number, sink1) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);
    if (number.length > 10) {
      sink1.addError('Please enter mobile number');
    } else if (!regExp.hasMatch(number)) {
      sink1.addError('Please enter valid mobile number');
    } else {
      sink1.add(number);
    }
    // if (number.length > 10) {
    //   sink1.addError('Please Enter Valid number');
    // } else if (!number.contains(RegExp(r'[0-9]'))) {
    //   sink1.addError('Please Enter Valid number');
    // } else {
    //   sink1.add(number);
    // }
  });
  final validatorOtp = StreamTransformer<String, String>.fromHandlers(
      handleData: (number, sink1) {
    if (!number.contains(RegExp(r'[0-9]'))) {
      sink1.addError('Please Enter Valid OTP');
    } else {
      if (number.length > 6) {
        sink1.addError('Please Enter Valid OTP');
      } else {
        sink1.add(number);
      }
    }
  });
  final validatorUsername = StreamTransformer<String, String>.fromHandlers(
      handleData: (number, sink1) {
    if (number.isEmpty) {
      sink1.addError('Please Enter Valid username');
    } else {
      sink1.add(number);
    }
  });
}
