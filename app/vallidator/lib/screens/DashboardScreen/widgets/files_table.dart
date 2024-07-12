import 'package:flutter/material.dart';
import 'package:vallidator/screens/DashboardScreen/widgets/files_table_header.dart';
import 'package:vallidator/screens/DashboardScreen/widgets/files_table_row.dart';
import 'package:vallidator/services/file_service.dart';

class FilesTable extends StatelessWidget {
  const FilesTable({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FileService().getRecentFiles(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Map<String, dynamic>> files =
                snapshot.data as List<Map<String, dynamic>>;

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
                filesTableHeader(),
                ...List.generate(files.length,
                    (index) => filesTableRow(files[index], index % 2 == 0)),
              ],
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          return const Center(child: CircularProgressIndicator());
        });
  }
}
