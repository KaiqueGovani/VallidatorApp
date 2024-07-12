import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vallidator/helpers/reroute_with_permission.dart';
import 'package:vallidator/helpers/show_snackbar_in_scaffold.dart';
import 'package:vallidator/models/Template.dart';
import 'package:vallidator/screens/common/confirmation_dialog.dart';
import 'package:vallidator/services/templates_service.dart';
import 'package:vallidator/themes/main_colors.dart';

class DeleteButton extends StatelessWidget {
  final Template template;
  DeleteButton({super.key, required this.template});

  final TemplateService templateService = TemplateService();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: MainColors.dangerButton.copyWith(
        minimumSize: MaterialStateProperty.all<Size>(const Size(50, 50)),
      ),
      onPressed: () {
        showConfirmationDialog(
          context,
          title: 'Delete Template',
          content: 'Are you sure you want to delete this template?',
          affirmativeOption: 'DELETE'
        ).then((value) async {
          if (value == false) return;
          await templateService.deleteTemplate(template.id).then((bool result) {
            if (result) {
              showSnackbarInScaffold(context, 'Template deleted successfully');
              rerouteWithPermission(context, route: 'templates');
            } else {
              showSnackbarInScaffold(context, 'Error deleting template');
            }
          }).onError((error, stackTrace) {
            showSnackbarInScaffold(context,
                'Error deleting template: ${(error as HttpException).message}');
          });
        });
      },
      child: const Row(
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
