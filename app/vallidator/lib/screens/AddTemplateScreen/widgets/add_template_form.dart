import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vallidator/helpers/reroute_with_permission.dart';
import 'package:vallidator/helpers/show_snackbar_in_scaffold.dart';
import 'package:vallidator/models/Template.dart';
import 'package:vallidator/screens/AddTemplateScreen/widgets/delete_button.dart';
import 'package:vallidator/screens/AddTemplateScreen/widgets/field_form.dart';
import 'package:vallidator/services/templates_service.dart';
import 'package:vallidator/themes/main_colors.dart';

class AddTemplateForm extends StatefulWidget {
  final bool isAdmin;
  final Template? template;
  AddTemplateForm({super.key, this.isAdmin = false, this.template});

  final TemplateService templateService = TemplateService();

  @override
  State<AddTemplateForm> createState() => _AddTemplateFormState();
}

class _AddTemplateFormState extends State<AddTemplateForm> {
  late int _numberOfFields;
  late String _fileType;
  late TextEditingController _templateNameController;
  late List<FieldForm> _fields;

  @override
  void initState() {
    super.initState();

    _templateNameController =
        TextEditingController(text: widget.template?.nome ?? '');
    _numberOfFields = widget.template?.campos.length ?? 1;
    _fileType = widget.template?.extensao.toUpperCase() ?? 'CSV';

    _fields = List.generate(
        _numberOfFields,
        (index) =>
            FieldForm(index: index, campo: widget.template?.campos[index]));
  }

  @override
  Widget build(BuildContext context) {
    print(widget.template?.campos);
    return Form(
      child: Column(
        children: <Widget>[
          Row(
            children: [
              Text(
                'Template Name:',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ],
          ),
          TextFormField(
            initialValue: _templateNameController.text,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 0),
            ),
            onChanged: (String value) {
              setState(() {
                _templateNameController.text = value;
              });
            },
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Text(
                'Number of Fields in File:',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ],
          ),
          DropdownMenu<int>(
            width: MediaQuery.of(context).size.width - 66,
            inputDecorationTheme: const InputDecorationTheme(
              contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              constraints: BoxConstraints(
                maxHeight: 50,
              ),
            ),
            initialSelection: _numberOfFields,
            dropdownMenuEntries: [
              ...List.generate(
                  7,
                  (index) => DropdownMenuEntry(
                      value: index + 1, label: '${index + 1}')),
            ],
            onSelected: (int? value) {
              if (value != null) {
                setState(() {
                  print('Setting number of fields to $value');
                  _numberOfFields = value;
                  _fields = List.generate(_numberOfFields, (index) {
                    print(index);
                    return FieldForm(
                        index: index,
                        campo: (widget.template != null &&
                                widget.template!.campos.length > index)
                            ? widget.template?.campos[index]
                            : null);
                  });
                });
              }
            },
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Text(
                'File Type:',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: SegmentedButton<String>(
                  segments: const [
                    ButtonSegment<String>(value: 'CSV', label: Text('CSV')),
                    ButtonSegment<String>(value: 'XLS', label: Text('XLS')),
                    ButtonSegment<String>(value: 'XLSX', label: Text('XLSX')),
                  ],
                  selected: <String>{_fileType},
                  onSelectionChanged: (Set<String> selection) {
                    setState(() {
                      _fileType = selection.first;
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.selected)) {
                        return MainColors.tertiary;
                      }
                      return Colors.white;
                    }),
                    overlayColor: MaterialStateProperty.all<Color>(
                      MainColors.primary,
                    ),
                    foregroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.selected)) {
                        return Colors.white;
                      }
                      return MainColors.activeGreen;
                    }),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          Column(
            children: _fields,
          ),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
            onPressed: () {
              print('Sending template to database');
              print(_fields.map((e) => e.campo).toList());
              if (widget.template == null) {
                // Create Template
                widget.templateService
                    .createTemplate(
                  Template.create(
                    nome: _templateNameController.text,
                    extensao: _fileType.toLowerCase(),
                    campos: _fields.map((e) => e.campo!).toList(),
                  ),
                )
                    .then((String value) async {
                  showSnackbarInScaffold(context, value);
                  rerouteWithPermission(context, route: 'templates');
                }).onError((error, stackTrace) {
                  showSnackbarInScaffold(
                      context, (error as HttpException).message);
                });
              } else {
                // Update Template
                //Updating fields in template:
                widget.template!.nome = _templateNameController.text;
                widget.template!.extensao = _fileType.toLowerCase();
                widget.template!.campos = _fields.map((e) => e.campo!).toList();

                print('Updating template ${widget.template}');

                widget.templateService
                    .updateTemplate(widget.template!)
                    .then((String value) async {
                  showSnackbarInScaffold(context, value);
                  rerouteWithPermission(context, route: 'templates');
                }).onError((error, stackTrace) {
                  showSnackbarInScaffold(
                      context, (error as HttpException).message);
                });
              }
            },
            style: MainColors.successButton,
            child: Text(widget.template != null
                ? widget.template?.status == null
                    ? 'Accept Template'
                    : 'Save Changes'
                : 'Create Template'),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.template != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: DeleteButton(
                    template: widget.template!,
                  ),
                ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: MainColors.dangerButton,
                child: const Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
