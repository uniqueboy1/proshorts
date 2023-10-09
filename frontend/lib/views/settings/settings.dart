import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro_shorts/constants.dart';
import 'package:pro_shorts/controllers/users.dart';
import 'package:pro_shorts/methods/show_snack_bar.dart';
import 'package:pro_shorts/views/settings/watch_later_history.dart';
import 'package:pro_shorts/views/settings/account_information.dart';
import 'package:pro_shorts/views/settings/change_password.dart';
import 'package:pro_shorts/views/settings/watch_history.dart';
import 'package:pro_shorts/views/signup/login_screen.dart';
import 'package:pro_shorts/views/signup/signup_screen.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final List<bool> _isExpandedList = [false];
  Future logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) => LoginScreen(),
        ),
        (route) => false,
      );
    } catch (e) {
      print(e);
    }
  }

  Future deleteAccount() async {
    User user = FirebaseAuth.instance.currentUser!;
    try {
      // deleting from firebase account
      await user.delete();
      await UserMethods().deleteUserById(MYPROFILE['_id']);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) => SignupScreen(),
        ),
        (route) => false,
      );
      // Account deletion successful
      showSnackBar("Account", "Account deleted successfully");
    } catch (e) {
      // Account deletion failed
      showSnackBar("Account", "Failed to delete account: $e");
    }
  }

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
                _isExpandedList[index] = isExpanded;
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
                          title: const Text("Account Information"),
                          trailing: const Icon(Icons.person_3),
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
                          title: const Text("Change Password"),
                          trailing: const Icon(Icons.lock),
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
                                    title: const Text(
                                        "Are you sure want to delete your account ?"),
                                    content: const Text(
                                        "Your account will be permanently deleted"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Cancel")),
                                      TextButton(
                                          onPressed: () async {
                                            await deleteAccount();
                                          },
                                          child: const Text("OK")),
                                    ],
                                  );
                                });
                          },
                          title: const Text("Delete Accoount"),
                          trailing: const Icon(Icons.delete_forever),
                        ),
                      ),
                    ],
                  ))
            ],
          )),
          Card(
            child: ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WatchHistory()));
              },
              title: const Text("Watch History"),
              trailing: const Icon(Icons.history),
            ),
          ),
          Card(
            child: ListTile(
              onTap: () {
                Get.to(() => const WatchLaterHistory());
              },
              title: const Text("Watch Later"),
              trailing: const Icon(Icons.watch_later),
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
                        title: const Text("Are you sure want to logout ?"),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel")),
                          TextButton(
                              onPressed: () {
                                logout();
                              },
                              child: const Text("Logout")),
                        ],
                      );
                    });
              },
              title: const Text("Logout"),
              trailing: const Icon(Icons.logout_outlined),
            ),
          ),
        ],
      ),
    );
  }
}
