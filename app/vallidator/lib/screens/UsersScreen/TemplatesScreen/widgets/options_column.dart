import 'package:flutter/material.dart';
import 'package:vallidator/models/Template.dart';
import 'package:vallidator/screens/TemplatesScreen/widgets/download_button.dart';
import 'package:vallidator/screens/TemplatesScreen/widgets/edit_button.dart';
import 'package:vallidator/screens/TemplatesScreen/widgets/status_switch.dart';
import 'package:vallidator/screens/TemplatesScreen/widgets/use_button.dart';
import 'package:vallidator/screens/TemplatesScreen/widgets/verify_button.dart';

class OptionsColumn extends StatelessWidget {
  final Template template;
  final bool? status;
  final bool isAdmin;
  final int id;
  final String permission;
  const OptionsColumn({
    super.key,
    required this.template,
    required this.status,
    required this.isAdmin,
    required this.permission,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    if (status == null) {
      return Column(
        children: [
          if (isAdmin) ...{
            StatusSwitch(
              status: status,
              id: id,
            ),
            SizedBox(
              height: 12,
            ),
            VerifyButton(template: template),
          }
        ],
      );
    } else {
      return Column(
        children: [
          if (isAdmin) ...{
            StatusSwitch(
              status: status,
              id: id,
            ),
            SizedBox(
              height: 12,
            ),
          },
          DownloadButton(
            template: template,
          ),
          SizedBox(
            height: 12,
          ),
          if (permission.contains('upload') || isAdmin) ...{
            UseButton(
              template: template,
            )
          },
          if (isAdmin) ...{
            SizedBox(
              height: 12,
            ),
            EditButton(
              template: template,
            ),
          },
        ],
      );
    }
  }
}
