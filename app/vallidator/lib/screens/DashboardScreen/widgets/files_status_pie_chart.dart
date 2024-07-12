import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:vallidator/components/indicator.dart';
import 'package:vallidator/services/file_service.dart';
import 'package:vallidator/themes/main_colors.dart';

class FilesStatusPieChart extends StatelessWidget {
  const FilesStatusPieChart({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FileService().getFileDashboardData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //print(snapshot.data);
            int total =
                snapshot.data!['aprovados'] + snapshot.data!['reprovados'];
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Indicator(
                        color: MainColors.tertiary,
                        text: 'Approved',
                        isSquare: true),
                    Indicator(
                        color: MainColors.dangerRed.withOpacity(0.5),
                        text: 'Rejected',
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
                          value: double.parse(
                              snapshot.data!['aprovados'].toString()),
                          title:
                              '${(snapshot.data!['aprovados'] / total * 100).toStringAsFixed(2)}%',
                          titleStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffffffff),
                          ),
                        ),
                        PieChartSectionData(
                          titlePositionPercentageOffset: 0.6,
                          radius: 100,
                          color: MainColors.dangerRed.withOpacity(0.5),
                          value: double.parse(
                              snapshot.data!['reprovados'].toString()),
                          title:
                              '${(snapshot.data!['reprovados'] / total * 100).toStringAsFixed(2)}%',
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
