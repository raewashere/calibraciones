import 'package:calibraciones/models/_corrida.dart';

abstract class CorridasService {
  Future<List<Corrida>> obtenerCorridaPorCalibracion(int idCalibracion);
}
