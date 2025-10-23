import 'package:calibraciones/models/_corrida.dart';
import 'package:calibraciones/services/corridas_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CorridasServiceImpl extends CorridasService {
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  Future<List<Corrida>> obtenerCorridaPorCalibracion(int idCalibracion) async {
    try {
      final response = await supabase
          .from('corrida')
          .select()
          .eq('id_calibracion', idCalibracion);
      if (response.isNotEmpty) {
        return (response as List).map((e) => Corrida.fromJson(e)).toList();
      } else {
        throw Exception('No se encontraron corridas');
      }
    } catch (e) {
      throw Exception('Error en la conexión: $e');
    }
  }
}
