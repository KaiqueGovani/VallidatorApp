import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vallidator/models/Template.dart';
import 'package:vallidator/screens/TemplatesScreen/widgets/feedback_dialog.dart';
import 'package:vallidator/screens/common/loading_dialog.dart';
import 'package:vallidator/services/file_service.dart';
import 'package:vallidator/themes/main_colors.dart';

Future<dynamic> showSendFileDialog(BuildContext context, Template template) {
  return showDialog(
      context: context,
      builder: (context) {
        return FileDialog(
          template: template,
        );
      });
}

class FileDialog extends StatefulWidget {
  final Template template;
  const FileDialog({super.key, required this.template});

  @override
  State<FileDialog> createState() => _FileDialogState();
}

class _FileDialogState extends State<FileDialog> {
  bool deepSearch = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.white,
      shadowColor: Colors.black,
      surfaceTintColor: Colors.white,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Send a File",
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: MainColors.activeGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 32)),
          const Divider(),
          Text('Using template: ${widget.template.nome}',
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: MainColors.activeGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 12)),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Deep search?'),
              Checkbox(
                value: deepSearch,
                onChanged: (value) {
                  setState(() {
                    deepSearch = value!;
                  });
                },
                activeColor: MainColors.tertiary,
                side:
                    const BorderSide(color: MainColors.activeGreen, width: 1.5),
              ),
            ],
          ),
          ElevatedButton(
            style: MainColors.useButton.copyWith(
              minimumSize: MaterialStateProperty.all<Size>(
                  const Size(double.maxFinite, 50)),
            ),
            onPressed: () async {
              Navigator.pop(context, true);
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['csv', 'xls', 'xlsx']).then(
                    (FilePickerResult? result) {
                      if (result != null) {
                        FileService()
                            .uploadFile(File(result.files.single.path!),
                                widget.template.id, '', deepSearch)
                            .then(
                          (value) {
                            if (value) {
                              Navigator.pop(context);
                              showFeedbackDialog(
                                context,
                                title: 'Success',
                                content: 'File accepted!\nSending...',
                                icon: const Icon(
                                  Icons.check_circle_outline,
                                  size: 128,
                                  color: MainColors.tertiary,
                                ),
                              );
                            }
                          },
                        ).catchError((error) {
                          Navigator.pop(context);
                          showFeedbackDialog(
                            context,
                            title: 'File out of template',
                            content: 'Error sending file:\n${error.message}',
                            icon: const Icon(
                              Icons.error_outline,
                              size: 128,
                              color: MainColors.dangerRed,
                            ),
                          );
                        }, test: (error) => error is HttpException);
                      } else {
                        // User canceled the picker
                        print('User canceled the picker');
                        Navigator.pop(context);
                      }
                    },
                  );
                  return const LoadingDialog();
                },
              );
            },
            child: const Text('Select File'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: const Text(
            "Cancel",
            style: TextStyle(color: MainColors.dangerRed, fontSize: 16),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: Text(
            'Send',
            style: TextStyle(
                color: MainColors.tertiary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: GoogleFonts.inter().fontFamily),
          ),
        ),
      ],
    );
  }
}
