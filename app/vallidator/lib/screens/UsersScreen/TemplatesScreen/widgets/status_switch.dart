import 'package:flutter/material.dart';
import 'package:vallidator/helpers/show_snackbar_in_scaffold.dart';
import 'package:vallidator/services/templates_service.dart';
import 'package:vallidator/themes/main_colors.dart';

// ignore: must_be_immutable
class StatusSwitch extends StatefulWidget {
  bool? status;
  final int id;
  StatusSwitch({super.key, required this.status, required this.id});

  final TemplateService templateService = TemplateService();

  @override
  State<StatusSwitch> createState() => _StatusSwitchState();
}

class _StatusSwitchState extends State<StatusSwitch> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Status:',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        if (widget.status != null)
          Transform.scale(
            scale: 0.9,
            child: Switch(
              value: widget.status!,
              onChanged: (value) async {
                setState(() {
                  widget.status = value;
                });
                widget.templateService
                    .updateStatus(widget.id, value)
                    .then((String value) {
                  showSnackbarInScaffold(context, value);
                });
              },
              thumbColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.selected)) {
                  return Colors.white;
                }
                return Colors.black38;
              }),
              trackColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.selected)) {
                  return MainColors.tertiary;
                }
                return Colors.white;
              }),
            ),
          ),
        Text(
          widget.status == null
              ? '  Waiting for Approval'
              : widget.status!
                  ? '   Active'
                  : ' Inactive',
          style: Theme.of(context).textTheme.labelLarge,
        )
      ],
    );
  }
}
