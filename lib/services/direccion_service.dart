import 'package:calibraciones/dto/dto_direccion.dart';

abstract class DireccionService {
  Future<DtoDireccion> obtenerDireccionRegistro();

  Future<List<DtoDireccion>> obtenerAllDirecciones();
}
