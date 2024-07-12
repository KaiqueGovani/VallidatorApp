import 'package:flutter/material.dart';
import 'package:vallidator/screens/DashboardScreen/widgets/files_status_pie_chart.dart';
import 'package:vallidator/screens/DashboardScreen/widgets/files_table.dart';

class FilesInfoCard extends StatelessWidget {
  FilesInfoCard({super.key});

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(2),
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text('Recent Files',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            Scrollbar(
              controller: _scrollController,
              interactive: true,
              trackVisibility: true,
              thickness: 5,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    child: FilesTable()),
              ),
            ),
            const Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 16),
                child: FilesStatusPieChart(),
                ),
          ],
        ),
      ),
    );
  }
}
