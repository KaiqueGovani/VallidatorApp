import 'package:flutter/material.dart';
import 'package:vallidator/models/User.dart';
import 'package:vallidator/themes/main_colors.dart';

class EditButton extends StatelessWidget {
  final User user;
  const EditButton({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: MainColors.editButton,
      onPressed: () {
        Navigator.pushNamed(context, 'my-account',
            arguments: {'isAdmin': true, 'edittingUser': user});
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Text('Edit'),
          ),
          Icon(
            Icons.edit_document,
            color: Colors.black.withOpacity(0.6),
          ),
        ],
      ),
    );
  }
}
