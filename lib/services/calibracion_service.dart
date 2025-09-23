import 'package:calibraciones/models/_calibracion_equipo.dart';

abstract class CalibracionService {
  Future<bool> registrarCalibracionEquipo(CalibracionEquipo calibracionEquipo);
}
