import 'package:calibraciones/models/_lectura_temperatura.dart';

abstract class LecturaTemperaturaService {
  Future<List<LecturaTemperatura>> obtenerLecturaPorCalibracion(
    int idCalibracion,
  );
}
