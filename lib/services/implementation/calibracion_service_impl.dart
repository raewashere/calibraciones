import 'dart:typed_data';
import 'package:calibraciones/models/_calibracion_equipo.dart';
import 'package:calibraciones/models/_corrida.dart';
import 'package:calibraciones/services/calibracion_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CalibracionServiceImpl implements CalibracionService {
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  Future<bool> registrarCalibracionEquipo(
    String direccionSeleccionada,
    String subdireccionSeleccionada,
    String gerenciaSeleccionada,
    String instalacionSeleccionada,
    String patinSeleccionado,
    String trenSeleccionado,
    CalibracionEquipo calibracionEquipo,
    Uint8List certificadoBytes,
  ) async {
    //Obtener email usuario
    String? emailUsuario = supabase.auth.currentSession!.user.email;

    //Obtener id usuario
    final responseUsuario = await supabase
        .from('usuario')
        .select()
        .eq('correo_electronico', emailUsuario!)
        .single();

    int idUsuario = responseUsuario['id_usuario'];
    calibracionEquipo.setIdUsuario = idUsuario;

    calibracionEquipo.setRutaCertificado = '$patinSeleccionado/$trenSeleccionado/${calibracionEquipo.tagEquipo}/${calibracionEquipo.certificadoCalibracion}.pdf';

    final response = await supabase
        .from('calibracion_equipo')
        .insert(calibracionEquipo.toJson())
        .select();

    //Busca id de calibracion
    int idCalibracionEquipo = response[0]['id_calibracion'];

    List<Corrida> corridas = calibracionEquipo.getCorridas();
    for (var corrida in corridas) {
      corrida.setIdCalibracion = idCalibracionEquipo;
      await supabase.from('corrida').insert(corrida.toJson());
    }

    await supabase.storage
        .from('certificados')
        .uploadBinary(
          '$patinSeleccionado/$trenSeleccionado/${calibracionEquipo.tagEquipo}/${calibracionEquipo.certificadoCalibracion}.pdf',
          certificadoBytes,
          fileOptions: const FileOptions(
            cacheControl: '3600',
            upsert: false,
            contentType: 'application/pdf',
          ),
        );

    return true;
  }

  @override
  Future<List<CalibracionEquipo>> obtenerCalibracionesEquipo(
    int offset,
    int limit,
  ) async {
    try {
      final response = await supabase
          .from('calibracion_equipo')
          .select()
          .order('id_calibracion', ascending: false)
          .range(offset, offset + limit - 1);

      // response ya es una List<Map<String, dynamic>>
      return (response as List)
          .map(
            (item) => CalibracionEquipo.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw Exception('Error al obtener calibraciones: $e');
    }
  }
}
