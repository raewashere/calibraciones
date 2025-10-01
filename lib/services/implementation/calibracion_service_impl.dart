import 'dart:io';
import 'dart:typed_data';
import 'package:calibraciones/models/_calibracion_equipo.dart';
import 'package:calibraciones/models/_corrida.dart';
import 'package:calibraciones/services/calibracion_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class CalibracionServiceImpl implements CalibracionService {
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  Future<bool> registrarCalibracionEquipo(
    CalibracionEquipo calibracionEquipo,
    Uint8List certificadoFile,
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

    final response = await supabase
        .from('calibracion_equipo')
        .insert(calibracionEquipo.toJson())
        .select();

    //Busca id de calibracion
    int idCalibracionEquipo = response[0]['id_calibracion'];

    List<Corrida> corridas = calibracionEquipo.getCorridas();
    for (var corrida in corridas) {
      corrida.setIdCalibracion = idCalibracionEquipo;
      final responseCorridas = await supabase
          .from('corrida')
          .insert(corrida.toJson());
    }

    if (kIsWeb) {
      await supabase.storage
          .from('certificados')
          .uploadBinary(
            '${calibracionEquipo.certificadoCalibracion}.pdf',
            certificadoFile,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: false,
              contentType: 'application/pdf',
            ),
          );
    } else {
      await supabase.storage
          .from('certificados')
          .upload(
            '${calibracionEquipo.certificadoCalibracion}.pdf',
            File.fromRawPath(certificadoFile),
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: false,
              contentType: 'application/pdf',
            ),
          );
    }

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
