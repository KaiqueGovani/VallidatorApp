import 'package:flutter/material.dart';
import 'package:vallidator/models/Template.dart';
import 'package:vallidator/screens/TemplatesScreen/widgets/send_template_dialog.dart';
import 'package:vallidator/themes/main_colors.dart';

class UseButton extends StatelessWidget {
  final Template template;
  const UseButton({super.key, required this.template});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: MainColors.useButton,
      onPressed: () async {
        showSendFileDialog(context, template).then((value) {
          if (value == false) return;
        });

        // showDialog(
        //     context: context,
        //     builder: (context) {
        //       return const LoadingDialog();
        //     });

        
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Text('Use Template'),
          ),
          Icon(
            Icons.folder,
            color: Colors.black.withOpacity(0.6),
          ),
        ],
      ),
    );
  }
}
