import 'dart:io';
import 'dart:typed_data';

import 'package:calibraciones/models/_calibracion_equipo.dart';

abstract class CalibracionService {
  Future<bool> registrarCalibracionEquipo(CalibracionEquipo calibracionEquipo, Uint8List certificadoFile);

  Future<List<CalibracionEquipo>> obtenerCalibracionesEquipo(int offset, int limit);
}
