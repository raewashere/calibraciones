import 'package:calibraciones/models/_tipo_sensor.dart';

abstract class TipoSensorService {

  Future<List<TipoSensor>> obtenerAllTipoSensores();
  
}