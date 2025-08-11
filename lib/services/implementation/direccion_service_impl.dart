import 'package:calibraciones/models/_direccion.dart';
import 'package:calibraciones/services/direccion_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DireccionServiceImpl extends DireccionService {

  @override
  Future<Direccion> obtenerDireccionId(int idDireccion) async {
    final SupabaseClient supabase = Supabase.instance.client;
    // Implementación de la llamada a la API para obtener las direcciones
    try{
      final response = await supabase
          .from('direccion')
          .select()
          .inFilter('id_direccion', [idDireccion]);

          return response.isNotEmpty
              ? Direccion.fromJson(response.first)
              : throw Exception('Dirección no encontrada');
    } catch (e) {
      throw Exception('Error en la conexión: $e');
    }
  }

  @override
  Future<List<Direccion>> obtenerAllDirecciones() async {
    final SupabaseClient supabase = Supabase.instance.client;

    try {
      final response = await supabase.from('direcciones').select();

      return response.isNotEmpty
          ? (response as List).map((e) => Direccion.fromJson(e)).toList()
          : throw Exception('No se encontraron direcciones');
    } catch (e) {
      throw Exception('Error en la conexión: $e');
    }
  }

}
