import 'package:flutter/material.dart';
import 'package:vallidator/models/Template.dart';
import 'package:vallidator/screens/TemplatesScreen/widgets/options_column.dart';
import 'package:vallidator/themes/main_colors.dart';

class TemplateCardBody extends StatelessWidget {
  final Template template;
  final bool isAdmin;
  final String permission;
  const TemplateCardBody({
    super.key,
    required this.isAdmin,
    required this.template,
    required this.permission,
  });

  @override
  Widget build(BuildContext context) {
    final int id = template.id;
    final String name = template.nome;
    final String creator = template.nome_criador;
    final DateTime createdAt = DateTime.parse(template.data_criacao);
    final String ext = template.extensao;
    final bool? status = template.status;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: MainColors.inactiveGreen,
          width: 2,
          strokeAlign: BorderSide.strokeAlignCenter,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      '# $id  $name - ${ext.toUpperCase()}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'Noto Sans Thai UI',
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.4,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      children: [
                        Text('Created by $creator'),
                        Text(
                            'Created at ${createdAt.day}/${createdAt.month}/${createdAt.year}'),
                      ],
                    ),
                  ),
                ],
              ),
              OptionsColumn(
                template: template,
                status: status,
                isAdmin: isAdmin,
                id: id,
                permission: permission,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
