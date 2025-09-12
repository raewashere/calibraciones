import 'package:calibraciones/dto/dto_direccion.dart';
import 'package:calibraciones/dto/dto_gerencia.dart';
import 'package:calibraciones/dto/dto_instalacion.dart';
import 'package:calibraciones/dto/dto_subdireccion_logistica.dart';
import 'package:calibraciones/services/direccion_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:calibraciones/models/_direccion.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DireccionServiceImpl extends DireccionService {
  final String url =
      "https://zkviewvpmswfgpiwpoez.supabase.co/rest/v1/direccion?select=id_direccion,nombre_direccion,subdireccion(id_subdireccion,nombre_subdireccion,gerencia(id_gerencia,nombre_gerencia,instalacion(id_instalacion,nombre_instalacion)))&apikey=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inprdmlld3ZwbXN3ZmdwaXdwb2V6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ0NTgxMzQsImV4cCI6MjA3MDAzNDEzNH0.E5i81N4_usUAqcLySjGZUk7rGOFHOLBBk8p1nzYjHbw";
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  Future<DtoDireccion> obtenerDireccionRegistro() async {
    // Implementación de la llamada a la API para obtener las direcciones
    try {
      final instalaciones = await supabase
          .from('instalacion')
          .select()
          .eq('id_gerencia', 12)
          .eq('id_subdireccion', 11);

      final gerencia = await supabase
          .from('gerencia')
          .select()
          .eq('id_gerencia', 12);

      final subdireccion = await supabase
          .from('subdireccion')
          .select()
          .eq('id_subdireccion', 11);

      final direccion = await supabase
          .from('direccion')
          .select()
          .eq('id_direccion', 4);

      final instalacionesDto = (instalaciones as List)
          .map((e) => DtoInstalacion.fromJson(e))
          .toList();

      final gerenciasDto = (gerencia as List)
          .map((e) => DtoGerencia.fromJson(e, instalacionesDto))
          .toList();

      final subdireccionesDto = (subdireccion as List)
          .map((e) => DtoSubdireccionLogistica.fromJson(e, gerenciasDto))
          .toList();

      final direccionRegistro = (direccion as List)
          .map((e) => DtoDireccion.fromJson(e, subdireccionesDto))
          .first;

      return direccionRegistro;
    } catch (e) {
      throw Exception('Error en la conexión: $e');
    }
  }

  @override
  Future<List<Direccion>> obtenerAllDirecciones() async {
    List<Direccion> direcciones = [];
    var request = http.Request(
      'GET',
      Uri.parse(
        'https://zkviewvpmswfgpiwpoez.supabase.co/rest/v1/direccion?select=id_direccion,nombre_direccion,subdireccion(id_subdireccion,nombre_subdireccion,instalacion(id_instalacion, nombre_instalacion, patin_medicion(tag_patin, nombre_patin, tipo_fluido, tipo, tren_medicion!tren_medicion_tag_patin_fkey(tag_tren, estado, punto_medicion, equipos_tren(equipo(tag_equipo, estado, incertidumbre, intervalo_calibracion, intervalo_verificacion, magnitud_incertidumbre, marca, modelo, no_serie, tipo_medicion))))),gerencia(id_gerencia,nombre_gerencia,instalacion(id_instalacion, nombre_instalacion,patin_medicion(tag_patin, nombre_patin, tipo_fluido, tipo, tren_medicion!tren_medicion_tag_patin_fkey(tag_tren, estado, punto_medicion, equipos_tren(equipo(tag_equipo, estado, incertidumbre, intervalo_calibracion, intervalo_verificacion, magnitud_incertidumbre, marca, modelo, no_serie, tipo_medicion)))))))&apikey=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inprdmlld3ZwbXN3ZmdwaXdwb2V6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ0NTgxMzQsImV4cCI6MjA3MDAzNDEzNH0.E5i81N4_usUAqcLySjGZUk7rGOFHOLBBk8p1nzYjHbw',
      ),
    );

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      //print(await response.stream.bytesToString());

      // Decodificar la respuesta JSON
      final List<dynamic> decodedJson = json.decode(
        await response.stream.bytesToString(),
      );
      for (var direccionJson in decodedJson) {
        Direccion direccion = Direccion.fromJson(direccionJson);
        // Aquí podrías agregar lógica adicional si es necesario
        direcciones.add(direccion);
      }
    } else {
      print(response.reasonPhrase);
    }

    return direcciones;

    /*try {
      final String url =
          "https://zkviewvpmswfgpiwpoez.supabase.co/rest/v1/direccion?select=id_direccion,nombre_direccion,subdireccion(id_subdireccion,nombre_subdireccion,gerencia(id_gerencia,nombre_gerencia,instalacion(id_instalacion,nombre_instalacion)))&apikey=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inprdmlld3ZwbXN3ZmdwaXdwb2V6Iiwicm9zZSI6ImFub24iLCJpYXQiOjE3NTQ0NTgxMzQsImV4cCI6MjA3MDAzNDEzNH0.E5i81N4_usUAqcLySjGZUk7rGOFHOLBBk8p1nzYjHbw";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> decodedJson = json.decode(response.body);
        List<Direccion> direcciones = [];
        for (var direccionJson in decodedJson) {
          Direccion direccion = Direccion.fromJson(direccionJson);
          // Aquí podrías agregar lógica adicional si es necesario
          direcciones.add(direccion);
        }
        return direcciones;
      } else {
        if (response.statusCode == 404) {
          // Decodificar la respuesta JSON
          throw Exception('No hay direcciones registradas');
        } else {
          throw Exception(
            'Hubo un error al recuperar la lista de direcciones 1',
          );
        }
      }
    } catch (e) {
      throw Exception(' Ojoooo $e');
    }
    */
  }
}
