import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:vallidator/components/indicator.dart';
import 'package:vallidator/services/templates_service.dart';

class TemplatesExtensionPieChart extends StatelessWidget {
  const TemplatesExtensionPieChart({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: TemplateService().getDashboardData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            int total = int.parse(snapshot.data!['csv']) +
                int.parse(snapshot.data!['xls']) +
                int.parse(snapshot.data!['xlsx']);
            return Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Indicator(
                        color: Color.fromARGB(255, 255, 170, 170),
                        text: 'CSV',
                        isSquare: true),
                    Indicator(
                        color: Color(0xFFFADFAD), text: 'XLS', isSquare: true),
                    Indicator(
                        color: Color(0xFFAABBFF), text: 'XLSX', isSquare: true),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width / 2,
                  child: PieChart(
                    PieChartData(
                      centerSpaceRadius: 0,
                      sectionsSpace: 3,
                      sections: [
                        PieChartSectionData(
                          titlePositionPercentageOffset: 0.6,
                          radius: 100,
                          color: const Color.fromARGB(255, 255, 170, 170),
                          value: double.parse(snapshot.data!['csv']),
                          title:
                              '${(double.parse(snapshot.data!['csv']) / total * 100).toStringAsFixed(2)}%',
                          titleStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        PieChartSectionData(
                          titlePositionPercentageOffset: 0.6,
                          radius: 100,
                          color: const Color(0xFFFADFAD),
                          value: double.parse(snapshot.data!['xls']),
                          title:
                              '${(double.parse(snapshot.data!['xls']) / total * 100).toStringAsFixed(2)}%',
                          titleStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        PieChartSectionData(
                          titlePositionPercentageOffset: 0.6,
                          radius: 100,
                          color: const Color(0xFFAABBFF),
                          value: double.parse(snapshot.data!['xlsx']),
                          title:
                              '${(double.parse(snapshot.data!['xlsx']) / total * 100).toStringAsFixed(2)}%',
                          titleStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
