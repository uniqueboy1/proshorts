import 'dart:math';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

String otpPassword = '';
bool isMailSend = false;
Future sendEmail(String to) async {
  String username = 'information11993@gmail.com';
  String password = 'rrnyuwyftyigzttb';
  String recipient = to;
  final smtpServer = gmail(username, password);

  final message = Message()
    ..from = Address(username, 'ProShorts')
    ..recipients.add(recipient)
    ..subject = 'OTP Verfication'
    ..text = 'Please enter this otp to verify : ${generateOTP()}';

  try {
    final sendReport = await send(message, smtpServer);
    print('Email sent: ${sendReport}');
    isMailSend = true;
  } catch (e) {
    print('Email sending failed: $e');
  }
}

String generateOTP() {
  otpPassword = "";
  for (int i = 0; i < 6; i++) {
    otpPassword += Random().nextInt(10).toString();
  }
  print("otpPassword : $otpPassword");
  return otpPassword;
}
