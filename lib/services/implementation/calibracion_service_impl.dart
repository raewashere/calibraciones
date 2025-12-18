import 'dart:typed_data';
import 'package:calibraciones/models/_calibracion_equipo.dart';
import 'package:calibraciones/models/_corrida.dart';
import 'package:calibraciones/models/_lectura_densidad.dart';
import 'package:calibraciones/models/_lectura_presion.dart';
import 'package:calibraciones/models/_lectura_temperatura.dart';
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

    calibracionEquipo.setRutaCertificado =
        '$patinSeleccionado/$trenSeleccionado/${calibracionEquipo.tagEquipo}/${calibracionEquipo.certificadoCalibracion}.pdf';

    final response = await supabase
        .from('calibracion_equipo')
        .insert(calibracionEquipo.toJson())
        .select();

    //Busca id de calibracion
    int idCalibracionEquipo = response[0]['id_calibracion'];

    if (calibracionEquipo.datosEspecificos is DatosCalibracionFlujo) {
      final datosDeFlujo =
          calibracionEquipo.datosEspecificos as DatosCalibracionFlujo;

      List<Corrida> corridas = datosDeFlujo.corridas;
      for (var corrida in corridas) {
        corrida.setIdCalibracion = idCalibracionEquipo;
        await supabase.from('corrida').insert(corrida.toJson());
      }
    } else if (calibracionEquipo.datosEspecificos
        is DatosCalibracionTemperatura) {
      final datosDeTemperatura =
          calibracionEquipo.datosEspecificos as DatosCalibracionTemperatura;

      List<LecturaTemperatura> lecturas = datosDeTemperatura.lecturas;
      for (var lectura in lecturas) {
        lectura.setIdCalibracion = idCalibracionEquipo;
        await supabase.from('lectura_temperatura').insert(lectura.toJson());
      }
    } else if (calibracionEquipo.datosEspecificos is DatosCalibracionPresion) {
      final datosDePresion =
          calibracionEquipo.datosEspecificos as DatosCalibracionPresion;

      List<LecturaPresion> lecturas = datosDePresion.lecturas;
      for (var lectura in lecturas) {
        lectura.setIdCalibracion = idCalibracionEquipo;
        await supabase.from('lectura_presion').insert(lectura.toJson());
      }
    } else {
      final datosDeDensidad =
          calibracionEquipo.datosEspecificos as DatosCalibracionDensidad;

      LecturaDensidad lectura = datosDeDensidad.lectura;

      lectura.setIdCalibracion = idCalibracionEquipo;
      await supabase.from('lectura_densidad').insert(lectura.toJson());
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
  Future<List<CalibracionEquipo>> obtenerCalibracionesAll(
    int offset,
    int limit,
  ) async {
    try {
      final response = await supabase
          .from('calibracion_equipo')
          .select()
          .order('id_calibracion', ascending: false)
          .range(offset, offset + limit - 1);

      return await Future.wait(
        response.map<Future<CalibracionEquipo>>((calibracionJson) async {
          return await CalibracionEquipo.fromJsonAsync(calibracionJson);
        }).toList(),
      );
    } catch (e) {
      throw Exception('Error al obtener calibraciones: $e');
    }
  }

  @override
  Future<List<CalibracionEquipo>> obtenerCalibracionesEquipo(
    String tagEquipo,
  ) async {
    try {
      final response = await supabase
          .from('calibracion_equipo')
          .select()
          .eq('tag_equipo', tagEquipo)
          .order('id_calibracion', ascending: false)
          .limit(5);

      return await Future.wait(
        response.map<Future<CalibracionEquipo>>((calibracionJson) async {
          return await CalibracionEquipo.fromJsonAsync(calibracionJson);
        }).toList(),
      );
    } catch (e) {
      throw Exception('Error al obtener calibraciones: $e');
    }
  }
}
