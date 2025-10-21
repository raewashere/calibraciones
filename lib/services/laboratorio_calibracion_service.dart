import 'package:calibraciones/models/_laboratorio_calibracion.dart';

abstract class LaboratorioCalibracionService {

  Future<List<LaboratorioCalibracion>> obtenerAllLaboratorios();

  Future<LaboratorioCalibracion> obtenerLaboratorioPorId(int idLaboratorio);
}