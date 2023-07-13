import 'package:flutter/material.dart';

class AccountInformation extends StatelessWidget {
  const AccountInformation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account Information"),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          SizedBox(
            height: 20,
          ),
          Card(
              child: ListTile(
            title: Text("E-mail : example@gmail.com"),
          )),
          SizedBox(
            height: 20,
          ),
          Card(
              child: ListTile(
            title: Text("Username : proshorts"),
          )),
        
        ],
      ),
    );
  }
}
