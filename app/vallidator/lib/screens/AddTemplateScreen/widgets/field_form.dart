import 'package:flutter/material.dart';
import 'package:vallidator/models/Campo.dart';
import 'package:vallidator/themes/main_colors.dart';

enum DataTypes {
  text('Text'),
  integer('Integer'),
  decimal('Decimal'),
  timestamp('Timestamp'),
  boolean('Boolean');

  const DataTypes(this.value);
  final String value;
}

// ignore: must_be_immutable
class FieldForm extends StatefulWidget {
  final int index;
  Campo? campo;
  FieldForm({super.key, required this.index, this.campo});

  @override
  State<FieldForm> createState() => _FieldFormState();
}

class _FieldFormState extends State<FieldForm> {
  late bool _isNullable;
  late TextEditingController _fieldNameController;
  late int _fieldType;

  @override
  void initState() {
    super.initState();

    _fieldNameController =
        TextEditingController(text: widget.campo?.nome_campo ?? '');
    _fieldType = (widget.campo?.id_tipo ?? 1) - 1;
    _isNullable = widget.campo?.anulavel ?? false;
  }

  @override
  Widget build(BuildContext context) {
    widget.campo = Campo(
        ordem: widget.index + 1,
        id_tipo: _fieldType + 1,
        anulavel: _isNullable,
        nome_campo: _fieldNameController.text,
        nome_tipo: DataTypes.values[_fieldType].value);
    return Column(
      children: [
        const Divider(),
        Row(
          children: [
            Text(
              '${widget.index + 1}# Field Name:',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
        TextFormField(
          controller: _fieldNameController,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 0),
          ),
          onChanged: (value) {
            setState(() {
              _fieldNameController.text = value;
            });
          },
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.index + 1}# Field Type:',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                DropdownMenu<int>(
                  inputDecorationTheme: const InputDecorationTheme(
                    contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                    constraints: BoxConstraints(
                      maxHeight: 50,
                    ),
                  ),
                  initialSelection: _fieldType,
                  dropdownMenuEntries: [
                    ...List.generate(
                      DataTypes.values.length,
                      (index) => DropdownMenuEntry(
                          value: index, label: DataTypes.values[index].value),
                    ).toList(),
                  ],
                  onSelected: (value) {
                    if (value != null) {
                      setState(() {
                        _fieldType = value;
                      });
                    }
                  },
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  'Nullable',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Transform.scale(
                  scale: 1.3,
                  child: Checkbox(
                    value: _isNullable,
                    onChanged: (bool? value) {
                      if (value != null) {
                        setState(() {
                          _isNullable = value;
                        });
                      }
                    },
                    activeColor: MainColors.tertiary,
                    side: BorderSide(color: MainColors.activeGreen, width: 1.5),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }
}
