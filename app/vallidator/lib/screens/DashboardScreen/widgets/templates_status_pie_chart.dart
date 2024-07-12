import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:vallidator/components/indicator.dart';
import 'package:vallidator/services/templates_service.dart';
import 'package:vallidator/themes/main_colors.dart';

class TemplatesStatusPieChart extends StatelessWidget {
  const TemplatesStatusPieChart({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: TemplateService().getDashboardData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            int total = int.parse(snapshot.data!['ativo']) +
                int.parse(snapshot.data!['inativo']) +
                int.parse(snapshot.data!['pendente']);
            return Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Indicator(
                        color: MainColors.tertiary,
                        text: 'Active',
                        isSquare: true),
                    Indicator(
                        color: MainColors.babyGreen,
                        text: 'Inactive',
                        isSquare: true),
                    Indicator(
                        color: MainColors.warningYellow,
                        text: 'Pending',
                        isSquare: true),
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
                          color: MainColors.tertiary,
                          value: double.parse(snapshot.data!['ativo']),
                          title:
                              '${(double.parse(snapshot.data!['ativo']) / total * 100).toStringAsFixed(2)}%',
                          titleStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffffffff),
                          ),
                        ),
                        PieChartSectionData(
                          titlePositionPercentageOffset: 0.6,
                          radius: 100,
                          color: MainColors.babyGreen,
                          value: double.parse(snapshot.data!['inativo']),
                          title:
                              '${(double.parse(snapshot.data!['inativo']) / total * 100).toStringAsFixed(2)}%',
                          titleStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        PieChartSectionData(
                          titlePositionPercentageOffset: 0.6,
                          radius: 100,
                          color: MainColors.warningYellow,
                          value: double.parse(snapshot.data!['pendente']),
                          title:
                              '${(double.parse(snapshot.data!['pendente']) / total * 100).toStringAsFixed(2)}%',
                          titleStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
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
