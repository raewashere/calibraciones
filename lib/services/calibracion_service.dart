import 'package:calibraciones/models/_corrida.dart';

abstract class CalibracionService {

  Future<bool> registrarCalibracionEquipo(
    String certificadoCalibracion,
    String documentoCertificado,
    DateTime fechaCalibracion,
    DateTime fechaProximaCalibracion,
    double linealidad,
    double reproducibilidad,
    String observaciones,    
    String tagEquipo,
    int idLaboratorio,
    List<Corrida> corridasPorEquipo,
    int idUsuario
  );

}
