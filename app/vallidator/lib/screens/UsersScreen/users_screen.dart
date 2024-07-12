import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vallidator/components/admin_scaffold.dart';
import 'package:vallidator/helpers/show_snackbar_in_scaffold.dart';
import 'package:vallidator/models/User.dart';
import 'package:vallidator/screens/UsersScreen/widgets/email_input_dialog.dart';
import 'package:vallidator/screens/UsersScreen/widgets/users_card.dart';
import 'package:vallidator/services/user_service.dart';

class UsersScreen extends StatefulWidget {
  UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  late Future<List<User>> _futureUsers;
  UserService userService = UserService();

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  void _fetchUsers() {
    _futureUsers = userService.getUsers();
  }

  Widget _floatingActionButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return const EmailInputDialog();
              }).then((option) {
            if (option != null && option[0]) {
              String email = option[1];
              showSnackbarInScaffold(context, 'Sending invitation to $email');
              userService.inviteUser(email).then((value) {
                if (value) {
                  showSnackbarInScaffold(
                      context, 'Invitation sent successfully!');
                } else {
                  showSnackbarInScaffold(context, 'Error sending invitation!');
                }
              }).catchError((error) {
                showSnackbarInScaffold(
                    context, "Error: ${(error as HttpException).message}");
              });
            }
          });
        },
        child: const Icon(Icons.group_add),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureUsers,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<User> users = snapshot.data as List<User>;
          return adminScaffold(context,
              body: UsersCard(users: users),
              titleText: 'Users',
              floatingActionButton: _floatingActionButton(context));
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
