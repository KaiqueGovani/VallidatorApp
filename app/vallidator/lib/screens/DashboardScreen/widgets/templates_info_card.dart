import 'package:flutter/material.dart';
import 'package:vallidator/screens/DashboardScreen/widgets/templates_extension_pie_chart.dart';
import 'package:vallidator/screens/DashboardScreen/widgets/templates_status_pie_chart.dart';
import 'package:vallidator/screens/DashboardScreen/widgets/templates_table.dart';

class TemplatesInfoCard extends StatelessWidget {
  TemplatesInfoCard({super.key});

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
            Text('Recent Templates',
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
                    child: TemplatesTable()),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 16),
              child: TemplatesStatusPieChart(),
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 16),
              child: TemplatesExtensionPieChart(),
            ),
          ],
        ),
      ),
    );
  }
}
