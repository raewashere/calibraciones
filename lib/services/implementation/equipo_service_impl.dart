import 'package:calibraciones/dto/dto_equipo.dart';
import 'package:calibraciones/models/_equipo.dart';
import 'package:calibraciones/services/equipo_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EquipoServiceImpl extends EquipoService {
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  Future<List<DtoEquipo>> obtenerAllEquipos() async {
    try {
      final response = await supabase.from('equipo').select();

      return response.isNotEmpty
          ? (response as List).map((e) => DtoEquipo.fromJson(e)).toList()
          : throw Exception('No se encontraron equipos');
    } catch (e) {
      throw Exception('Error en la conexión: $e');
    }
  }

  @override
  Future<Equipo> obtenerEquipoPorId(String tagEquipo) async {
    try {
      final response = await supabase
          .from('equipo')
          .select()
          .eq('tag_equipo', tagEquipo)
          .single();

      return Equipo.fromJson(response);
    } catch (e) {
      throw Exception('Error al obtener el equipo por tag: $e');
    }
  }
}
