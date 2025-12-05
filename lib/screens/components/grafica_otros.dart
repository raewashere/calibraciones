import 'dart:math';
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

    return SizedBox(
      height: 600,
      child: Column(
        children: <Widget>[
          // 1. PRIMERA GRÁFICA (Toma la mitad del espacio disponible)
          Text(
            'IBC vs Error',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colors.onSurface,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: LineChart(
                LineChartData(
                  extraLinesData: ExtraLinesData(
                    horizontalLines: [_getLineaMediatemperatura(colors)],
                    // Puedes dejar verticalLines vacía si no las necesitas
                    // verticalLines: [],
                  ),
                  // ... (Configuración general de la gráfica)
                  titlesData: FlTitlesData(
                    // Títulos del Eje X (Flujo)
                    bottomTitles: AxisTitles(
                      // Aumentamos el espacio reservado para el título del eje
                      axisNameSize: 35,
                      axisNameWidget: Padding(
                        padding: const EdgeInsets.only(
                          top: 8.0,
                        ), // Reducido ligeramente
                        child: Text(
                          (tipo) ? 'Lectura IBC (ºC)':'Lectura IBC (ºkg/cm²)',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      sideTitles: SideTitles(
                        showTitles: true,
                        // Aumentamos el espacio reservado para las etiquetas numéricas
                        reservedSize: 50,
                        getTitlesWidget: (value, meta) {
                          final text = value.toStringAsFixed(0);
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              text,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        },
                        interval: 15,
                      ),
                    ),

                    // Títulos del Eje Y (K Factor)
                    // EJE Y (K Factor)
                    leftTitles: AxisTitles(
                      // Aumentamos el espacio reservado para el título del eje
                      axisNameSize: 35,
                      axisNameWidget: Padding(
                        padding: EdgeInsets.only(right: 12.0),
                        child: Text(
                          (tipo) ? 'Error (ºC)':'Error (ºkg/cm²)',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      sideTitles: SideTitles(
                        showTitles: true,
                        // Aumentamos el espacio reservado para las etiquetas con decimales
                        reservedSize: 50,
                        getTitlesWidget: (value, meta) => Text(
                          value.toStringAsFixed(2),
                          style: const TextStyle(fontSize: 8),
                        ),
                        interval: 20,
                      ),
                    ),

                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),

                  // ... (Configuración de BorderData, etc.)
                  lineBarsData: [
                    LineChartBarData(
                      // ... (Estilos de la línea)
                      color: colors.secondary,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: colors.secondaryContainer,
                      ),
                      spots:
                          spots, // Usa la lista de puntos dinámica
                    ),
                  ],

                  // LÍMITES DE LA GRÁFICA
                  minX: minimoX, // El valor X del primer punto
                  maxX: maximoX, // El valor X máximo
                  minY: minimoY, // El valor Y mínimo (K Factor)
                  maxY: maximoY, // El valor Y máximo
                ),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutQuart,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Línea de Límite Inferior (LI)
  HorizontalLine _getLimiteInferior(dynamic colors) {
    double yValue =
        _calcularPromedio(spots) -
        2 * _calcularDesviacionEstandar(spots);
    return HorizontalLine(
      y: yValue,
      color: colors.tertiary,
      strokeWidth: 2,
      dashArray: [5, 5], // Línea punteada
      label: HorizontalLineLabel(
        show: true,
        alignment: Alignment.bottomRight,
        padding: const EdgeInsets.only(right: 5),
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
        labelResolver: (line) => 'LI ${yValue.toStringAsFixed(5)}',
      ),
    );
  }

  // Línea de Límite Superior (LS)
  HorizontalLine _getLimiteSuperior(dynamic colors) {
    double yValue =
        _calcularPromedio(spots) +
        2 * _calcularDesviacionEstandar(spots);
    return HorizontalLine(
      y: yValue, // 💡 Define el valor Y de tu límite
      color: colors.tertiary,
      strokeWidth: 2,
      dashArray: [5, 5], // Línea punteada
      label: HorizontalLineLabel(
        show: true,
        alignment: Alignment.topRight,
        padding: const EdgeInsets.only(right: 5),
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
        labelResolver: (line) => 'LS ${yValue.toStringAsFixed(5)}',
      ),
    );
  }

  // Línea de Valor Promedio (Media)
  HorizontalLine _getLineaMedia(dynamic colors) {
    double yValue = _calcularPromedio(spots);
    return HorizontalLine(
      y: yValue, // 💡 Define el valor Y de tu límite
      color: colors.secondary,
      strokeWidth: 2,
      dashArray: [5, 5], // Línea punteada
      label: HorizontalLineLabel(
        show: true,
        alignment: Alignment.topRight,
        padding: const EdgeInsets.only(right: 5),
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
        labelResolver: (line) => 'AVG ${yValue.toStringAsFixed(5)}',
      ),
    );
  }

  HorizontalLine _getLineaMediatemperatura(dynamic colors) {
    double yValue = _calcularPromedio(spots);
    return HorizontalLine(
      y: yValue, // 💡 Define el valor Y de tu límite
      color: colors.secondary,
      strokeWidth: 2,
      dashArray: [5, 5], // Línea punteada
      label: HorizontalLineLabel(
        show: true,
        alignment: Alignment.topRight,
        padding: const EdgeInsets.only(right: 5),
        style: TextStyle(
          color: Colors.black,
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
