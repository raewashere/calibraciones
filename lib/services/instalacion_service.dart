import 'package:calibraciones/dto/dto_instalacion.dart';

abstract class InstalacionService {

  Future<DtoInstalacion> obtenerInstalacionPorId(int idInstalacion);
  
}