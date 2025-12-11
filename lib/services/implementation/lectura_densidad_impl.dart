import 'package:calibraciones/models/_lectura_densidad.dart';
import 'package:calibraciones/services/lectura_densidad_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LecturaDensidadServiceImpl extends LecturaDensidadService {
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  Future<LecturaDensidad> obtenerLecturaPorCalibracionDensidad(
    int idCalibracion,
  ) async {
    try {
      final response = await supabase
          .from('lectura_densidad')
          .select()
          .eq('id_calibracion', idCalibracion);
      if (response.isNotEmpty) {
        return LecturaDensidad.fromJson(response[0]);
      } else {
        throw Exception('No se encontraron lecturas de densidad');
      }
    } catch (e) {
      throw Exception('Error en la conexión: $e');
    }
  }
}
