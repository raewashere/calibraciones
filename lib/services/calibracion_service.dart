import 'dart:typed_data';

import 'package:calibraciones/models/_calibracion_equipo.dart';

abstract class CalibracionService {
  Future<bool> registrarCalibracionEquipo(String direccionSeleccionada,String subdireccionSeleccionada, String gerenciaSeleccionada, String instalacionSeleccionada, String patinSeleccionado, String trenSeleccionado, CalibracionEquipo calibracionEquipo, Uint8List certificadoFile);

  Future<List<CalibracionEquipo>> obtenerCalibracionesAll(int offset, int limit);

  Future<List<CalibracionEquipo>> obtenerCalibracionesEquipo(String tagEquipo);

}