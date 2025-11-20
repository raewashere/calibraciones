// Definimos una clase para devolver todos los límites de una vez
import 'dart:math';

import 'package:calibraciones/models/_calibracion_equipo.dart';
import 'package:calibraciones/models/_corrida.dart';
import 'package:fl_chart/fl_chart.dart';

class LimitesGrafica {
  final double minX;
  final double maxX;
  final double minY;
  final double maxY;
  final int
  maxCorridas; // Para el valor máximo de X si usas el índice de corrida

  LimitesGrafica({
    required this.minX,
    required this.maxX,
    required this.minY,
    required this.maxY,
    required this.maxCorridas,
  });
}

LimitesGrafica calcularLimitesGrafica({
  required List<CalibracionEquipo> todasLasCalibraciones,
  required Map<int, bool> calibracionesVisibles,
  required double Function(Corrida)
  yValueSelector, // Selector para el valor del Eje Y
}) {
  List<FlSpot> todosLosPuntos = [];
  int maxCorridas = 0;

  // 1. Consolidar todos los puntos visibles
  for (var calibracion in todasLasCalibraciones) {
    int id = calibracion.idCalibracionEquipo;

    if (calibracionesVisibles[id] == true) {
      // Actualizar el número máximo de corridas (para el caso del Eje X basado en índice)
      if (calibracion.corridas.length > maxCorridas) {
        maxCorridas = calibracion.corridas.length;
      }

      // Mapeo: Crear puntos a partir de las corridas visibles
      for (int i = 0; i < calibracion.corridas.length; i++) {
        final corrida = calibracion.corridas[i];

        // El Eje X es el caudal (caudalM3Hr) o el índice (i+1)
        // Usaremos caudalM3Hr como X, para seguir tu ejemplo de `corridasAPuntos`.
        todosLosPuntos.add(FlSpot(corrida.caudalM3Hr, yValueSelector(corrida)));
      }
    }
  }

  // 2. Manejar caso sin datos
  if (todosLosPuntos.isEmpty) {
    return LimitesGrafica(
      minX: 0,
      maxX: 200 ,
      minY: 5000,
      maxY: 20000,
      maxCorridas: 5,
    ); // Valores por defecto
  }

  // 3. Encontrar Mínimos y Máximos sin margen
  double dataMinX = todosLosPuntos.map((spot) => spot.x).reduce(min);
  double dataMaxX = todosLosPuntos.map((spot) => spot.x).reduce(max);
  double dataMinY = todosLosPuntos.map((spot) => spot.y).reduce(min);
  double dataMaxY = todosLosPuntos.map((spot) => spot.y).reduce(max);

  // Prevenir que el margen sea 0 si min/max son iguales o la diferencia es mínima
  if (dataMaxX - dataMinX < 0.0001) {
    dataMaxX += 1;
    dataMinX -= 1;
  }
  if (dataMaxY - dataMinY < 0.0001) {
    dataMaxY += 0.001;
    dataMinY -= 0.001;
  }

  // 4. Calcular y aplicar el margen del 15% (basado en el rango total)

  // Margen en X
  double rangoX = dataMaxX - dataMinX;
  double margenX = rangoX * 0.15; // 15% del rango total

  double finalMinX = dataMinX - margenX;
  double finalMaxX = dataMaxX + margenX;

  // Margen en Y
  double margenY = dataMinY * 0.001; // 15% del rango total
  print(dataMinY);
  print(margenY);
  double finalMinY = dataMinY - margenY;
  double finalMaxY = dataMaxY + margenY;
  print(finalMinY);
  print(finalMaxY);
  return LimitesGrafica(
    minX: finalMinX,
    maxX: finalMaxX,
    minY: finalMinY,
    maxY: finalMaxY,
    maxCorridas: maxCorridas,
  );
}
