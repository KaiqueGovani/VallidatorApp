import 'package:flutter/material.dart';
import 'package:vallidator/helpers/show_snackbar_in_scaffold.dart';
import 'package:vallidator/models/Template.dart';
import 'package:vallidator/services/templates_service.dart';
import 'package:vallidator/themes/main_colors.dart';

class DownloadButton extends StatelessWidget {
  final Template template;
  const DownloadButton({super.key, required this.template});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: MainColors.downloadButton,
      onPressed: () {
        TemplateService().downloadTemplate(template).then((value) {
          if (value) {
            showSnackbarInScaffold(context, 'Template downloaded successfully');
          } else {
            showSnackbarInScaffold(context, 'Error downloading template');
          }
        }).catchError((error) {
          showSnackbarInScaffold(context, 'Error downloading template ${error.toString()}');
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Text('Download'),
          ),
          Icon(
            Icons.download,
            color: Colors.black.withOpacity(0.6),
          ),
        ],
      ),
    );
  }
}
