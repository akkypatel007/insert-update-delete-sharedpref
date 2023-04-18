import 'package:flutter/material.dart';
import 'package:practical_test2/database_helper.dart';
import 'package:practical_test2/model.dart';
import 'package:practical_test2/registration_page.dart';
import 'package:practical_test2/userform.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  late DatabaseHelper _databaseHelper;
  List<User> _users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    List<User> users = await DatabaseHelper.getUsers();
    setState(() {
      _users = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
      ),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 370,
              height: 180,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 130,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${user.firstName}'),
                            Text('${user.lastName}'),
                            Text(user.email ?? ''),
                            Text(user.city ?? ''),
                            Text(user.pincode ?? ''),
                          ],
                        ),
                      ),
                      Container(
                        height: 130,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundImage: user.profilePicture != null
                                  ? MemoryImage(user.profilePicture!)
                                  : null,
                            ),
                            Text(user.mobile ?? ''),
                            Text(user.state ?? ''),
                            Text(user.gender ?? ''),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _showEditUserDialog(context, user, index);
                        },
                        child: Text("edit"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _deleteUser(index);
                        },
                        child: Text("delete"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegistrationScreen()),
          ).then((value) {
            if (value == true) {
              _loadUsers();
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showEditUserDialog(BuildContext context, User user, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit User'),
          content: UserForm(
            user: user,
            onSubmit: (User user) {
              _updateUser(index, user);
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  void _deleteUser(int index) async {
    await DatabaseHelper.deleteUser(index);
    setState(() {
      _users.removeAt(index);
    });
  }

  void _updateUser(int index, User user) async {
    await DatabaseHelper.updateUser(index, user);
    setState(() {
      _users[index] = user;
    });
  }
}
