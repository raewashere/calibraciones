import 'package:calibraciones/models/_lectura_densidad.dart';

abstract class LecturaDensidadService {
  Future<LecturaDensidad> obtenerLecturaPorCalibracionDensidad(int idCalibracion);
}
