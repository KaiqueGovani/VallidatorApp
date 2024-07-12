import 'package:flutter/material.dart';
import 'package:vallidator/models/Template.dart';
import 'package:vallidator/screens/DashboardScreen/widgets/templates_table_header.dart';
import 'package:vallidator/screens/DashboardScreen/widgets/templates_table_row.dart';
import 'package:vallidator/services/templates_service.dart';

class TemplatesTable extends StatelessWidget {
  const TemplatesTable({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: TemplateService().getRecentTemplates(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            print('GOT DATA GOT DATA GOT');
            List<Template> templates = snapshot.data as List<Template>;
            return Table(
              columnWidths: const <int, TableColumnWidth>{
                0: IntrinsicColumnWidth(),
                1: IntrinsicColumnWidth(),
                2: IntrinsicColumnWidth(),
                3: IntrinsicColumnWidth(),
                4: IntrinsicColumnWidth(),
                5: IntrinsicColumnWidth(),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: <TableRow>[
                templatesTableHeader(),
                ...List.generate(
                    templates.length,
                    (index) =>
                        templatesTableRow(templates[index], index % 2 == 0))
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
