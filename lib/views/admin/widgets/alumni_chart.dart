import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AlumniCharts extends StatelessWidget {
  final Map<String, int> jobDistribution;
  final Map<String, int> alumniPerYear;

  const AlumniCharts({
    required this.jobDistribution,
    required this.alumniPerYear,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Distribusi Pekerjaan Alumni', style: TextStyle(fontSize: 18)),
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sections:
                  jobDistribution.entries.map((e) {
                    return PieChartSectionData(
                      value: e.value.toDouble(),
                      title: e.key,
                      radius: 50,
                    );
                  }).toList(),
            ),
          ),
        ),
        SizedBox(height: 32),
        Text('Alumni per Angkatan', style: TextStyle(fontSize: 18)),
        SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              barGroups:
                  alumniPerYear.entries.map((e) {
                    return BarChartGroupData(
                      x: int.parse(e.key),
                      barRods: [
                        BarChartRodData(
                          fromY: 0,
                          toY: e.value.toDouble(),
                          width: 16,
                        ),
                      ],
                    );
                  }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
