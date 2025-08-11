import 'package:calibraciones/models/_direccion.dart';

abstract class DireccionService {

  Future<Direccion> obtenerDireccionId(int idDireccion);

  Future<List<Direccion>> obtenerAllDirecciones();

}
