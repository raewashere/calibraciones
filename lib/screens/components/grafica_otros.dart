import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GraficaOtros extends StatelessWidget {
  final List<FlSpot> spots; // Los puntos (Lectura, Error)
  final double maximoX;
  final double minimoX;
  final double maximoY;
  final double minimoY;
  final bool tipo; // false: temperatura, true: presión

  const GraficaOtros({
    super.key,
    required this.spots,
    required this.maximoX,
    required this.minimoX,
    required this.maximoY,
    required this.minimoY,
    required this.tipo,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      height: 400,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'IBC vs Error',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colors.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 0.05, // Ajusta según tus datos
                  getDrawingHorizontalLine: (value) {
                    // Línea cero distintiva pero sutil
                    if (value == 0) {
                      return FlLine(
                        color: colors.outline.withValues(alpha: 0.5),
                        strokeWidth: 1,
                      );
                    }
                    return FlLine(
                      color: colors.outlineVariant.withValues(alpha: 0.3),
                      strokeWidth: 1,
                      dashArray: [5, 5],
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    axisNameWidget: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        (tipo) ? 'Lectura IBC (kg/cm²)' : 'Lectura IBC (ºC)',
                        style: textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                    axisNameSize: 30,
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 10,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            value.toStringAsFixed(0),
                            style: textTheme.labelSmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    axisNameWidget: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        (tipo) ? 'Error (kg/cm²)' : 'Error (ºC)',
                        style: textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                    axisNameSize: 30,
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 45,
                      interval: 0.05,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toStringAsFixed(2),
                          style: textTheme.labelSmall?.copyWith(
                            color: colors.onSurfaceVariant,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.end,
                        );
                      },
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(color: colors.outlineVariant),
                    left: BorderSide(color: colors.outlineVariant),
                    right: BorderSide.none,
                    top: BorderSide.none,
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: colors.primary,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: colors.surface,
                          strokeWidth: 2,
                          strokeColor: colors.primary,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          colors.primary.withValues(alpha: 0.2),
                          colors.primary.withValues(alpha: 0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    spots: spots,
                  ),
                ],
                // Línea de referencia animada o estática extra
                extraLinesData: ExtraLinesData(
                  horizontalLines: [
                    HorizontalLine(
                      y: 0,
                      color: colors.error.withValues(alpha: 0.6),
                      strokeWidth: 1,
                      dashArray: [6, 6],
                      label: HorizontalLineLabel(
                        show: true,
                        alignment: Alignment.topRight,
                        padding: const EdgeInsets.only(right: 5, bottom: 5),
                        style: textTheme.labelSmall?.copyWith(
                          color: colors.error,
                          fontStyle: FontStyle.italic,
                        ),
                        labelResolver: (line) => '0.0',
                      ),
                    ),
                  ],
                ),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (_) => colors.primaryContainer,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((LineBarSpot touchedSpot) {
                        return LineTooltipItem(
                          '${touchedSpot.x.toStringAsFixed(1)}  kg/cm²,  ${touchedSpot.y.toStringAsFixed(3)} kg/cm²',
                          TextStyle(
                            color: colors.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                minX: minimoX,
                maxX: maximoX,
                minY: minimoY,
                maxY: maximoY,
              ),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOutCubic,
            ),
          ),
        ],
      ),
    );
  }
}
