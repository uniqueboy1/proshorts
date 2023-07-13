import 'package:flutter/material.dart';
import 'package:pro_shorts/views/settings/account_information.dart';
import 'package:pro_shorts/views/settings/change_password.dart';
import 'package:pro_shorts/views/settings/watch_history.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final List<bool> _isExpandedList = [false];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings and Privacy"),
      ),
      body: ListView(
        children: [
          Card(
              child: ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                _isExpandedList[index] = !isExpanded;
              });
            },
            children: [
              ExpansionPanel(
                  isExpanded: _isExpandedList[0],
                  headerBuilder: (context, isExpanded) {
                    return const ListTile(
                      title: Text("Account"),
                    );
                  },
                  body: Column(
                    children: [
                      Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AccountInformation()));
                          },
                          title: Text("Account Information"),
                          trailing: Icon(Icons.person_3),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChangePassword()));
                          },
                          title: Text("Change Password"),
                          trailing: Icon(Icons.lock),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          onTap: () {
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                        "Are you sure want to delete your account ?"),
                                    content: Text("Your account will be permanently deleted"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("Cancel")),
                                      TextButton(
                                          onPressed: () {}, child: Text("OK")),
                                    ],
                                  );
                                });
                          },
                          title: Text("Delete Accoount"),
                          trailing: Icon(Icons.delete_forever),
                        ),
                      ),
                    ],
                  ))
            ],
          )),
           Card(
            child: ListTile(
              onTap: (){
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => WatchHistory())
                  
                  );
              },
              title: Text("Watch History"),
              trailing: Icon(Icons.history),
            ),
          ),
          Card(
            child: ListTile(
              onTap: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Are you sure want to logout ?"),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Cancel")),
                          TextButton(onPressed: () {}, child: Text("Logout")),
                        ],
                      );
                    });
              },
              title: Text("Logout"),
              trailing: Icon(Icons.logout_outlined),
            ),
          ),
        ],
      ),
    );
  }
}
