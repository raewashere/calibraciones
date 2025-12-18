import 'package:calibraciones/models/_lectura_temperatura.dart';
import 'package:calibraciones/services/lectura_temperatura_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LecturaTemperaturaServiceImpl extends LecturaTemperaturaService {
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  Future<List<LecturaTemperatura>> obtenerLecturaPorCalibracionTemperatura(
    int idCalibracion,
  ) async {
    try {
      final response = await supabase
          .from('lectura_temperatura')
          .select()
          .eq('id_calibracion', idCalibracion);
      if (response.isNotEmpty) {
        return (response as List)
            .map((e) => LecturaTemperatura.fromJson(e))
            .toList();
      } else {
        throw Exception('No se encontraron lecturas temperatura');
      }
    } catch (e) {
      throw Exception('Error en la conexión: $e');
    }
  }
}
