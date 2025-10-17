import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GraficaCorridas extends StatelessWidget {
  const GraficaCorridas({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    );
  }

  Widget graficar(BuildContext context) {
    return SizedBox(
      height: 300,
      child: LineChart(
          LineChartData(
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (value) =>
                  FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 1),
            ),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 32,
                  getTitlesWidget: (value, meta) {
                    const meses = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun'];
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        meses[value.toInt() % meses.length],
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  },
                  interval: 1,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 2,
                  getTitlesWidget: (value, meta) => Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 10),
                  ),
                  reservedSize: 30,
                ),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
            ),
            lineBarsData: [
              LineChartBarData(
                isCurved: true,
                color: Theme.of(context).colorScheme.secondary,
                barWidth: 3,
                isStrokeCapRound: true,
                belowBarData: BarAreaData(
                  show: true,
                  color: Theme.of(context)
                      .colorScheme
                      .secondary
                      .withOpacity(0.2),
                ),
                dotData: FlDotData(show: true),
                spots: const [
                  FlSpot(0, 3),
                  FlSpot(1, 2.5),
                  FlSpot(2, 5),
                  FlSpot(3, 3.1),
                  FlSpot(4, 4),
                  FlSpot(5, 4.8),
                ],
              ),
            ],
            minX: 0,
            maxX: 5,
            minY: 0,
            maxY: 6,
          ),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutQuart,
        ),
    );
  }
}
