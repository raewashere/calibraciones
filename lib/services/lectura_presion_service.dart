import 'package:calibraciones/models/_lectura_presion.dart';

abstract class LecturaPresionService {
  Future<List<LecturaPresion>> obtenerLecturaPorCalibracionPresion(int idCalibracion);
}
