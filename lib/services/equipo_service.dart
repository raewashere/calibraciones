import 'package:calibraciones/dto/dto_equipo.dart';

abstract class EquipoService {

  Future<List<DtoEquipo>> obtenerAllEquipos();
}
