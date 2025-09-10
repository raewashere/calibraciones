import 'package:calibraciones/dto/dto_direccion.dart';
import 'package:calibraciones/models/_direccion.dart';

abstract class DireccionService {
  Future<DtoDireccion> obtenerDireccionRegistro();

  Future<List<Direccion>> obtenerAllDirecciones();
}
