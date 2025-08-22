import 'package:calibraciones/dto/dto_instalacion.dart';
import 'package:calibraciones/services/instalacion_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InstalacionServiceImpl extends InstalacionService {

  final SupabaseClient supabase = Supabase.instance.client;
  
  @override
  Future<DtoInstalacion> obtenerInstalacionPorId(int idInstalacion) async {
    
    // Implementación de la llamada a la API o lógica para obtener la instalación por ID
    try {
      final response = await supabase.from('instalacion').select().eq('id_instalacion', idInstalacion).single();

      return DtoInstalacion.fromJson(response);
        } catch (e) {
      throw Exception('Error en la conexión: $e');
    }
  }

}
