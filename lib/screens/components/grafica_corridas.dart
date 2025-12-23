import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GraficaCorridas extends StatelessWidget {
  final List<FlSpot> spotsKFactor; // Los puntos (Flujo, K Factor)
  final List<FlSpot> spotsMeterFactor; // Los puntos (Flujo, Meter Factor)
  final double kFactorMaxX;
  final double kFactorMinX;
  final double kFactorMaxY;
  final double kFactorMinY;
  final double meterFactorMaxX;
  final double meterFactorMinX;
  final double meterFactorMaxY;
  final double meterFactorMinY;
  // Añadir minY para un mejor control del K Factor

  const GraficaCorridas({
    super.key,
    required this.spotsKFactor,
    required this.spotsMeterFactor,
    required this.kFactorMaxX,
    required this.kFactorMinX,
    required this.kFactorMaxY,
    required this.kFactorMinY,
    required this.meterFactorMaxX,
    required this.meterFactorMinX,
    required this.meterFactorMaxY,
    required this.meterFactorMinY,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: 800, // Aumentado ligeramente para mejor espaciado
      child: Column(
        children: <Widget>[
          // 1. PRIMERA GRÁFICA: K Factor vs Flujo
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
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
                children: [
                  Text(
                    'K Factor vs Flujo',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colors.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 20,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: colors.outlineVariant.withValues(
                                alpha: 0.3,
                              ),
                              strokeWidth: 1,
                              dashArray: [5, 5],
                            );
                          },
                        ),
                        extraLinesData: ExtraLinesData(
                          horizontalLines: [
                            _getLineaMediaKFactor(colors, textTheme),
                          ],
                        ),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            axisNameWidget: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'Flujo (m³/hr)',
                                style: textTheme.labelSmall?.copyWith(
                                  color: colors.onSurfaceVariant,
                                  fontSize: 10,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ),
                            axisNameSize: 30,
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              interval: 20,
                              getTitlesWidget: (value, meta) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    value.toStringAsFixed(0),
                                    style: textTheme.labelSmall?.copyWith(
                                      color: colors.onSurfaceVariant,
                                      fontSize: 10,
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            axisNameWidget: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                'K Factor (Pulsos/m³)',
                                style: textTheme.labelSmall?.copyWith(
                                  color: colors.onSurfaceVariant,
                                  fontSize: 10,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ),
                            axisNameSize: 30,
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              interval: 20,
                              getTitlesWidget: (value, meta) => Text(
                                value.toStringAsFixed(2),
                                style: textTheme.labelSmall?.copyWith(
                                  color: colors.onSurfaceVariant,
                                  fontSize: 10,
                                ),
                                textAlign: TextAlign.end,
                              ),
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
                            color: colors.secondary,
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) {
                                return FlDotCirclePainter(
                                  radius: 4,
                                  color: colors.surface,
                                  strokeWidth: 2,
                                  strokeColor: colors.secondary,
                                );
                              },
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                colors: [
                                  colors.secondary.withValues(alpha: 0.2),
                                  colors.secondary.withValues(alpha: 0.0),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            spots: spotsKFactor,
                          ),
                        ],
                        lineTouchData: LineTouchData(
                          touchTooltipData: LineTouchTooltipData(
                            getTooltipColor: (_) => colors.secondaryContainer,
                            getTooltipItems: (touchedSpots) {
                              return touchedSpots.map((
                                LineBarSpot touchedSpot,
                              ) {
                                return LineTooltipItem(
                                  'Flujo: ${touchedSpot.x.toStringAsFixed(1)}\nK: ${touchedSpot.y.toStringAsFixed(2)}',
                                  textTheme.labelSmall?.copyWith(
                                        color: colors.onSecondaryContainer,
                                        fontWeight: FontWeight.bold,
                                      ) ??
                                      const TextStyle(),
                                );
                              }).toList();
                            },
                          ),
                        ),
                        minX: kFactorMinX,
                        maxX: kFactorMaxX,
                        minY: kFactorMinY,
                        maxY: kFactorMaxY,
                      ),
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOutCubic,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. SEGUNDA GRÁFICA: Meter Factor vs Flujo
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 12),
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
                children: [
                  Text(
                    'Meter Factor vs Flujo',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colors.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 0.010,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: colors.outlineVariant.withValues(
                                alpha: 0.3,
                              ),
                              strokeWidth: 1,
                              dashArray: [5, 5],
                            );
                          },
                        ),
                        extraLinesData: ExtraLinesData(
                          horizontalLines: [
                            _getLimiteInferior(colors, textTheme),
                            _getLimiteSuperior(colors, textTheme),
                            _getLineaMedia(colors, textTheme),
                          ],
                        ),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            axisNameWidget: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'Flujo (m³/hr)',
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
                              interval: 20,
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
                                'Meter Factor',
                                style: textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colors.onSurfaceVariant,
                                ),
                              ),
                            ),
                            axisNameSize: 30,
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              interval: 0.020,
                              getTitlesWidget: (value, meta) => Text(
                                value.toStringAsFixed(3),
                                style: textTheme.labelSmall?.copyWith(
                                  color: colors.onSurfaceVariant,
                                  fontSize: 10,
                                ),
                                textAlign: TextAlign.end,
                              ),
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
                            spots: spotsMeterFactor,
                          ),
                        ],
                        lineTouchData: LineTouchData(
                          touchTooltipData: LineTouchTooltipData(
                            getTooltipColor: (_) => colors.primaryContainer,
                            getTooltipItems: (touchedSpots) {
                              return touchedSpots.map((
                                LineBarSpot touchedSpot,
                              ) {
                                return LineTooltipItem(
                                  'Flujo: ${touchedSpot.x.toStringAsFixed(1)}\nMF: ${touchedSpot.y.toStringAsFixed(4)}',
                                  textTheme.labelSmall?.copyWith(
                                        color: colors.onPrimaryContainer,
                                        fontWeight: FontWeight.bold,
                                      ) ??
                                      const TextStyle(),
                                );
                              }).toList();
                            },
                          ),
                        ),
                        minX: meterFactorMinX,
                        maxX: meterFactorMaxX,
                        minY: meterFactorMinY,
                        maxY: meterFactorMaxY,
                      ),
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOutCubic,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Línea de Límite Inferior (LI)
  HorizontalLine _getLimiteInferior(ColorScheme colors, TextTheme textTheme) {
    double yValue =
        _calcularPromedio(spotsMeterFactor) -
        2 * _calcularDesviacionEstandar(spotsMeterFactor);
    return HorizontalLine(
      y: yValue,
      color: colors.tertiary,
      strokeWidth: 2,
      dashArray: [5, 5], // Línea punteada
      label: HorizontalLineLabel(
        show: true,
        alignment: Alignment.bottomRight,
        padding: const EdgeInsets.only(right: 5, top: 20),
        style: textTheme.labelSmall?.copyWith(
          color: colors.onSurface,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
        labelResolver: (line) => 'LI ${yValue.toStringAsFixed(5)}',
      ),
    );
  }

  // Línea de Límite Superior (LS)
  HorizontalLine _getLimiteSuperior(ColorScheme colors, TextTheme textTheme) {
    double yValue =
        _calcularPromedio(spotsMeterFactor) +
        2 * _calcularDesviacionEstandar(spotsMeterFactor);
    return HorizontalLine(
      y: yValue, // 💡 Define el valor Y de tu límite
      color: colors.tertiary,
      strokeWidth: 2,
      dashArray: [5, 5], // Línea punteada
      label: HorizontalLineLabel(
        show: true,
        alignment: Alignment.topRight,
        padding: const EdgeInsets.only(right: 5, bottom: 20),
        style: textTheme.labelSmall?.copyWith(
          color: colors.onSurface,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
        labelResolver: (line) => 'LS ${yValue.toStringAsFixed(5)}',
      ),
    );
  }

  // Línea de Valor Promedio (Media)
  HorizontalLine _getLineaMedia(ColorScheme colors, TextTheme textTheme) {
    double yValue = _calcularPromedio(spotsMeterFactor);
    return HorizontalLine(
      y: yValue, // 💡 Define el valor Y de tu límite
      color: colors.secondary,
      strokeWidth: 2,
      dashArray: [5, 5], // Línea punteada
      label: HorizontalLineLabel(
        show: true,
        alignment: Alignment.topRight,
        padding: const EdgeInsets.only(right: 5),
        style: textTheme.labelSmall?.copyWith(
          color: colors.onSurface,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
        labelResolver: (line) => 'AVG ${yValue.toStringAsFixed(5)}',
      ),
    );
  }

  HorizontalLine _getLineaMediaKFactor(
    ColorScheme colors,
    TextTheme textTheme,
  ) {
    double yValue = _calcularPromedio(spotsKFactor);
    return HorizontalLine(
      y: yValue, // 💡 Define el valor Y de tu límite
      color: colors.secondary,
      strokeWidth: 2,
      dashArray: [5, 5], // Línea punteada
      label: HorizontalLineLabel(
        show: true,
        alignment: Alignment.topRight,
        padding: const EdgeInsets.only(right: 5),
        style: textTheme.labelSmall?.copyWith(
          color: colors.onSurface,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
        labelResolver: (line) => 'AVG ${yValue.toStringAsFixed(2)}',
      ),
    );
  }

  //Calcular el valor promedio de Meter Factor
  double _calcularPromedio(List<FlSpot> spots) {
    if (spots.isEmpty) return 0.0;

    double suma = spots.fold(0.0, (prev, spot) => prev + spot.y);
    return suma / spots.length;
  }

  //Calcular desviación estándar de Meter Factor
  double _calcularDesviacionEstandar(List<FlSpot> spots) {
    if (spots.isEmpty) return 0.0;

    double promedio = _calcularPromedio(spots);
    double sumaDiferenciasCuadradas = spots.fold(
      0.0,
      (prev, spot) => prev + (spot.y - promedio) * (spot.y - promedio),
    );
    return sqrt((sumaDiferenciasCuadradas / spots.length));
  }
}
