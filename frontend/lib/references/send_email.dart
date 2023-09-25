
// use mailer package
// give app password instead of your account password

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

void sendEmail() async {
    String username = 'information11993@gmail.com';
    String password = 'rrnyuwyftyigzttb';
    String recipient = 'arounder719@gmail.com';

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'Your Name')
      ..recipients.add(recipient)
      ..subject = 'Test Email'
      ..text = 'This is a test email sent from Flutter.';

    try {
      final sendReport = await send(message, smtpServer);
      print('Email sent: ${sendReport}');
    } catch (e) {
      print('Email sending failed: $e');
    }
  }