import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vallidator/helpers/reroute_with_permission.dart';
import 'package:vallidator/helpers/show_snackbar_in_scaffold.dart';
import 'package:vallidator/models/User.dart';
import 'package:vallidator/screens/common/confirmation_dialog.dart';
import 'package:vallidator/services/user_service.dart';
import 'package:vallidator/themes/main_colors.dart';

class DeleteUserButton extends StatelessWidget {
  final User user;
  DeleteUserButton({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: MainColors.dangerButton.copyWith(
        minimumSize: MaterialStateProperty.all<Size>(const Size(50, 50)),
      ),
      onPressed: () {
        showConfirmationDialog(
          context,
          title: 'Delete User',
          content:
              'Are you sure you want to delete\nUser #${user.id}:  ${user.nome} ${user.sobrenome}?',
          affirmativeOption: "DELETE",
        ).then((value) {
          if (value == false) return;
          UserService().deleteUser(user).then((bool result) {
            if (result) {
              showSnackbarInScaffold(context, 'User deleted successfully');
              rerouteWithPermission(context, route: 'users');
            } else {
              showSnackbarInScaffold(context, 'Error deleting User');
            }
          }).catchError((error) {
            showSnackbarInScaffold(context,
                'Error deleting User: ${(error as HttpException).message}');
          }, test: (error) => error is HttpException);
        });
      },
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.delete_forever,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
