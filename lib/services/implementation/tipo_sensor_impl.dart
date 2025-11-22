import 'package:calibraciones/models/_tipo_sensor.dart';
import 'package:calibraciones/services/tipo_sensor_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TipoSensorServiceImpl extends TipoSensorService {
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  Future<List<TipoSensor>> obtenerAllTipoSensores() async {
    try {
      final response = await supabase.from('tipo_sensor').select();

      if (response.isNotEmpty) {
        return (response as List)
            .map((e) => TipoSensor.fromJsonFactory(e))
            .toList();
      } else {
        throw Exception('No se encontraron tipos de sensores');
      }
    } catch (e) {
      throw Exception('Error en la conexión: $e');
    }
  }
}
