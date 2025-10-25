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
    return SizedBox(
      height: 600,
      child: Column(
        children: <Widget>[
          // 1. PRIMERA GRÁFICA (Toma la mitad del espacio disponible)
          Text( 
            'K Factor vs Flujo',
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
                  // ... (Configuración general de la gráfica)
                  titlesData: FlTitlesData(
                    // Títulos del Eje X (Flujo)
                    bottomTitles: AxisTitles(
                      // Aumentamos el espacio reservado para el título del eje
                      axisNameSize: 35,
                      axisNameWidget: const Padding(
                        padding: EdgeInsets.only(
                          top: 8.0,
                        ), // Reducido ligeramente
                        child: Text(
                          'Flujo (m³/hr)',
                          style: TextStyle(
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
                        interval: 100,
                      ),
                    ),

                    // Títulos del Eje Y (K Factor)
                    // EJE Y (K Factor)
                    leftTitles: AxisTitles(
                      // Aumentamos el espacio reservado para el título del eje
                      axisNameSize: 35,
                      axisNameWidget: const Padding(
                        padding: EdgeInsets.only(right: 12.0),
                        child: Text(
                          'K Factor (Pulsos/m³)',
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
                          value.toStringAsFixed(3),
                          style: const TextStyle(fontSize: 8),
                        ),
                        interval: 1.0,
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
                      color: colors.secondaryContainer,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(show: false),
                      spots: spotsKFactor, // Usa la lista de puntos dinámica
                    ),
                  ],

                  // LÍMITES DE LA GRÁFICA
                  minX: kFactorMinX, // El valor X del primer punto
                  maxX: kFactorMaxX, // El valor X máximo
                  minY: kFactorMinY, // El valor Y mínimo (K Factor)
                  maxY: kFactorMaxY, // El valor Y máximo
                ),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutQuart,
              ),
            ),
          ),

          const Divider(), // Separador visual (opcional)
          // ----------------------------------------------------
          // 2. SEGUNDA GRÁFICA (Toma la otra mitad del espacio disponible)
          Text( 
            'Meter Factor vs Flujo',
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
                  // ... (Configuración general de la gráfica)
                  titlesData: FlTitlesData(
                    // Títulos del Eje X (Flujo)
                    bottomTitles: AxisTitles(
                      // Aumentamos el espacio reservado para el título del eje
                      axisNameSize: 35,
                      axisNameWidget: const Padding(
                        padding: EdgeInsets.only(
                          top: 8.0,
                        ), // Reducido ligeramente
                        child: Text(
                          'Flujo (m³/hr)',
                          style: TextStyle(
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
                        interval: 100,
                      ),
                    ),

                    // Títulos del Eje Y (K Factor)
                    // EJE Y (K Factor)
                    leftTitles: AxisTitles(
                      // Aumentamos el espacio reservado para el título del eje
                      axisNameSize: 35,
                      axisNameWidget: const Padding(
                        padding: EdgeInsets.only(right: 12.0),
                        child: Text(
                          'Meter Factor',
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
                          value.toStringAsFixed(3),
                          style: const TextStyle(fontSize: 8),
                        ),
                        interval: 0.001,
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
                      color: colors.primaryContainer,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(show: false),
                      spots: spotsMeterFactor, // Usa la lista de puntos dinámica
                    ),
                  ],

                  // LÍMITES DE LA GRÁFICA
                  minX: meterFactorMinX, // El valor X del primer punto
                  maxX: meterFactorMaxX, // El valor X máximo
                  minY: meterFactorMinY, // El valor Y mínimo (K Factor)
                  maxY: meterFactorMaxY, // El valor Y máximo
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
