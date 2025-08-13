import 'package:calibraciones/dto/dto_direccion.dart';
import 'package:calibraciones/dto/dto_gerencia.dart';
import 'package:calibraciones/dto/dto_instalacion.dart';
import 'package:calibraciones/dto/dto_subdireccion_logistica.dart';
import 'package:calibraciones/services/direccion_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DireccionServiceImpl extends DireccionService {
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  Future<DtoDireccion> obtenerDireccionRegistro() async {
    // Implementación de la llamada a la API para obtener las direcciones
    try {
      final instalaciones = await supabase.from('instalacion').select()
      .eq('id_gerencia', 12)
      .eq('id_subdireccion', 11);

      final gerencia = await supabase.from('gerencia').select()
      .eq('id_gerencia', 12);
      
      final subdireccion = await supabase.from('subdireccion').select()
      .eq('id_subdireccion', 11);

      final direccion = await supabase.from('direccion').select()
      .eq('id_direccion', 4);


      final instalacionesDto = (instalaciones as List).map((e) => DtoInstalacion.fromJson(e)).toList();

      final gerenciasDto = (gerencia as List).map((e) => DtoGerencia.fromJson(e, instalacionesDto)).toList();

      final subdireccionesDto = (subdireccion as List).map((e) => DtoSubdireccionLogistica.fromJson(e, gerenciasDto)).toList();

      final direccionRegistro = (direccion as List).map((e) => DtoDireccion.fromJson(e, subdireccionesDto)).first;

      return direccionRegistro;
    } catch (e) {
      throw Exception('Error en la conexión: $e');
    }
  }

  @override
  Future<List<DtoDireccion>> obtenerAllDirecciones() async {
    try {
      final response = await supabase.from('direccion').select();

      return response.isNotEmpty
          ? (response as List).map((e) => DtoDireccion.fromJson(e, [])).toList()
          : throw Exception('No se encontraron direcciones');
    } catch (e) {
      throw Exception('Error en la conexión: $e');
    }
  }
}
