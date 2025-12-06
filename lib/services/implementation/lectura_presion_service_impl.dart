import 'package:calibraciones/models/_lectura_presion.dart';
import 'package:calibraciones/services/lectura_presion_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LecturaPresionServiceImpl extends LecturaPresionService {
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  Future<List<LecturaPresion>> obtenerLecturaPorCalibracion(int idCalibracion) async {
    try {
      final response = await supabase
          .from('lectura_presion')
          .select()
          .eq('id_calibracion', idCalibracion);
      if (response.isNotEmpty) {
        return (response as List).map((e) => LecturaPresion.fromJson(e)).toList();
      } else {
        throw Exception('No se encontraron corridas');
      }
    } catch (e) {
      throw Exception('Error en la conexión: $e');
    }
  }
}
