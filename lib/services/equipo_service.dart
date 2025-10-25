import 'package:calibraciones/common/barrel/models.dart';
import 'package:calibraciones/dto/dto_equipo.dart';

abstract class EquipoService {

  Future<List<DtoEquipo>> obtenerAllEquipos();

  Future<Equipo> obtenerEquipoPorId(String id);
}
