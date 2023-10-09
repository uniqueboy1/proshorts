import 'package:flutter/material.dart';
import 'package:pro_shorts/controllers/users.dart';

class ViewUsers extends StatefulWidget {
  ViewUsers({super.key});

  @override
  State<ViewUsers> createState() => _ViewUsersState();
}

class _ViewUsersState extends State<ViewUsers> {
  List users = [];

  Future fetchAllUsers() async {
    users = await UserMethods().fetchAllUsers();
  }

  Future deleteUser(String userId) async {
    await UserMethods().deleteUserById(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users List"),
      ),
      body: FutureBuilder(
          future: fetchAllUsers(), // The Future<T> that you want to monitor
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Display a loading indicator while waiting for the Future to complete
              return Center(child: const CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // Display an error message if the Future throws an error
              return Text('Error: ${snapshot.error}');
            } else {
              return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Email: ${users[index]['email']}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                users[index].containsKey("profileInformation")
                                    ? Text(
                                        'Username: ${users[index]['profileInformation']['username']}',
                                        style: TextStyle(fontSize: 16),
                                      )
                                    : Text(""),
                                SizedBox(height: 8),
                                users[index].containsKey("profileInformation")
                                    ? Text(
                                        'Followers Count: ${users[index]['followers'].length}',
                                        style: TextStyle(fontSize: 16),
                                      )
                                    : Text("")
                              ],
                            ),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                            "Are you sure want to delete this user ?"),
                                        content: const Text(
                                            "This user will be permanently deleted"),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("Cancel")),
                                          TextButton(
                                              onPressed: () async {
                                                await deleteUser(
                                                    users[index]['_id']);
                                                setState(() {});
                                              },
                                              child: const Text("Delete")),
                                        ],
                                      );
                                    });
                              },
                              icon: const Icon(
                                Icons.delete_forever,
                                color: Colors.red,
                                size: 32,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  });
            }
          }),
    );
  }
}

class UserListItem extends StatelessWidget {
  final String email;
  final String username;
  final int followersCount;

  UserListItem({
    required this.email,
    required this.username,
    required this.followersCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Email: $email',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Username: $username',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Followers Count: $followersCount',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
