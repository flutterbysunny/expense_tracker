import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/category_data.dart';

class CategoryPieChart extends StatelessWidget {
  final Map<String, double> categoryTotals;
  final double totalAmount;

  const CategoryPieChart({
    super.key,
    required this.categoryTotals,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    final entries = categoryTotals.entries.toList();

    return SizedBox(
      height: 240,
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 60,
          sections: entries.map((entry) {
            final percentage = totalAmount == 0
                ? 0.0
                : (entry.value / totalAmount) * 100;
            return PieChartSectionData(
              value: entry.value,
              title: '${percentage.toStringAsFixed(0)}%',
              color: CategoryData.getColor(entry.key),
              radius: 50,
              titleStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}