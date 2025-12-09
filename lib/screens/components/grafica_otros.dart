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

  // Función para crear la línea de referencia en Y = 0
  HorizontalLine _getLineaCero(ColorScheme colors) {
    return HorizontalLine(
      y: 0,
      color: colors.error, 
      strokeWidth: 1.5,
      dashArray: [8, 8],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      height: 400,
      child: Column(
        children: <Widget>[
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
                  // 🌟 AÑADIR LA LÍNEA DE REFERENCIA EN Y=0 🌟
                  extraLinesData: ExtraLinesData(
                    horizontalLines: [_getLineaCero(colors)],
                  ),
                  
                  titlesData: FlTitlesData(
                    // ... Títulos del Eje X (Bottom)
                    bottomTitles: AxisTitles(
                      axisNameSize: 35,
                      axisNameWidget: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          // Aquí se invierte el orden del texto para que sea (IBC vs Unidad)
                          (tipo) ? 'Lectura IBC (kg/cm²)' : 'Lectura IBC (ºC)', 
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      sideTitles: SideTitles(
                        showTitles: true,
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
                        interval: 5,
                      ),
                    ),

                    // ... Títulos del Eje Y (Left)
                    leftTitles: AxisTitles(
                      axisNameSize: 35,
                      axisNameWidget: Padding(
                        padding: EdgeInsets.only(right: 12.0),
                        child: Text(
                          // Aquí se invierte el orden del texto para que sea (Error vs Unidad)
                          (tipo) ? 'Error (kg/cm²)' : 'Error (ºC)', 
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 50,
                        getTitlesWidget: (value, meta) => Text(
                          value.toStringAsFixed(2),
                          style: const TextStyle(fontSize: 8),
                        ),
                        interval: 0.010,
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
                      color: colors.secondary,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: colors.secondaryContainer,
                        // El límite inferior debe ser 0 para colorear solo desde 0 hacia abajo
                        // Esto crea un área bajo 0 y un área sobre 0.
                        cutOffY: 0, 
                        applyCutOffY: false,
                      ),
                      spots: spots, 
                    ),
                  ],

                  // LÍMITES DE LA GRÁFICA
                  minX: minimoX, 
                  maxX: maximoX, 
                  // Asegúrate de que 'minimoY' contenga el valor más negativo de tus datos.
                  minY: minimoY, 
                  maxY: maximoY, 
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
}