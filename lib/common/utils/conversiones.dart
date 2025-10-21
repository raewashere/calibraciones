// lib/utils/conversion_utils.dart¨
import 'package:calibraciones/models/_corrida.dart';
import 'package:intl/intl.dart';

class Conversiones {
  static const double m3ToBblFactor = 6.28981;
  static const double bblToM3Factor = 1 / m3ToBblFactor;
  static const double psiToKgCm2Factor = 0.0703070;
  static const double kgCm2ToPsiFactor = 14.22334;
  static const double kgCm2ToKPaFactor = 98.0665;
  static const double kPaToKgCm2Factor = 0.0101972;

  //Caudal
  static double caudalM3ToBbl(double m3) => (m3 * m3ToBblFactor);
  static double caudalBblToM3(double bbl) => (bbl * bblToM3Factor);
  //Temperatura
  static double celsiusToFahrenheit(double celsius) => (celsius * 9 / 5) + 32;
  static double fahrenheitToCelsius(double fahrenheit) =>
      (fahrenheit - 32) * 5 / 9;
  //Presion
  static double kgCm2ToPsi(double kgCm2) => (kgCm2 * kgCm2ToPsiFactor);
  static double kgCm2ToKPa(double kgCm2) => (kgCm2 * kgCm2ToKPaFactor);
  static double psiToKgCm2(double psi) => (psi * psiToKgCm2Factor);
  static double psiToKPa(double psi) => (psiToKgCm2(psi) * kgCm2ToKPaFactor);
  static double kPaToKgCm2(double kPa) => (kPa * kPaToKgCm2Factor);
  static double kPaToPsi(double kPa) => (kPaToKgCm2(kPa) * kgCm2ToPsiFactor);
  //Pulsos
  static double m3ToBbl(double m3) => (m3 * bblToM3Factor);
  static double bblToM3(double bbl) => (bbl * m3ToBblFactor);

  //Formato de miles
  String formatoMiles(double value) {
    final formateador = NumberFormat("####,###,##0.00", "en");
    return formateador.format(value); // Format as integer to avoid decimals.
  }

  String calcularLinealidad(List<Corrida> corridas) {
    if (corridas.isEmpty) {
      return '0.0';
    }

    List<double> valores = corridas.map((c) => c.getMeterFactor).toList();
    // 1. Promedio
    double promedio = valores.reduce((a, b) => a + b) / valores.length;

    if (promedio == 0) {
      return '0.0';
    }

    // 2. Calcular desviaciones absolutas respecto al promedio
    List<double> desviaciones = valores
        .map((v) => (v - promedio).abs())
        .toList();

    // 3. Obtener la máxima desviación
    double maxDesviacion = desviaciones.reduce((a, b) => a > b ? a : b);

    // 4. Porcentaje de linealidad
    double porcentajeLinealidad = (maxDesviacion / promedio) * 100;

    return formatoMiles(porcentajeLinealidad);
  }
}
