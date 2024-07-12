import 'package:flutter/material.dart';
import 'package:vallidator/models/Template.dart';
import 'package:vallidator/themes/main_colors.dart';

class EditButton extends StatelessWidget {
  final Template template;
  const EditButton({super.key, required this.template});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: MainColors.editButton,
      onPressed: () {
        Navigator.pushNamed(context, 'add-template', arguments: template);
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
