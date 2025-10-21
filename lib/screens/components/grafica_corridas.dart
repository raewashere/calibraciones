import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GraficaCorridas extends StatelessWidget {
  final List<FlSpot> spots; // Los puntos (Flujo, K Factor)
  final double maxX;
  final double minX;
  final double maxY;
  final double minY; // Añadir minY para un mejor control del K Factor

  const GraficaCorridas({
    super.key,
    required this.spots,
    required this.maxX,
    required this.minX,
    required this.maxY,
    required this.minY, // Ahora es requerido
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      height: 300,
      child: LineChart(
        LineChartData(
          // ... (Configuración general de la gráfica)
          titlesData: FlTitlesData(
            // Títulos del Eje X (Flujo)
            bottomTitles: AxisTitles(
              // Aumentamos el espacio reservado para el título del eje
              axisNameSize: 35,
              axisNameWidget: const Padding(
                padding: EdgeInsets.only(top: 8.0), // Reducido ligeramente
                child: Text(
                  'Flujo',
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
                reservedSize: 40,
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
                interval: 200,
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
                  'K Factor',
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
                  value.toStringAsFixed(4),
                  style: const TextStyle(fontSize: 10),
                ),
                interval: 0.0002,
              ),
            ),

            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),

          // ... (Configuración de BorderData, etc.)
          lineBarsData: [
            LineChartBarData(
              // ... (Estilos de la línea)
              color: colors.secondaryContainer,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(show: false),
              spots: spots, // Usa la lista de puntos dinámica
            ),
          ],

          // LÍMITES DE LA GRÁFICA
          minX: minX, // El valor X del primer punto
          maxX: maxX, // El valor X máximo
          minY: minY, // El valor Y mínimo (K Factor)
          maxY: maxY, // El valor Y máximo
        ),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutQuart,
      ),
    );
  }
}
