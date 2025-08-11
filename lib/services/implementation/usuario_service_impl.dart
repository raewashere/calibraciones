import 'package:calibraciones/models/_usuario.dart';
import 'package:calibraciones/services/usuario_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';

class UsuarioServiceImpl implements UsuarioService {
  final SupabaseClient supabase = Supabase.instance.client;
  final String urlN8N =
      "http://127.0.0.1:5678/webhook/31f9de4b-5677-4e3a-aa03-31e7174c7b6a";
  @override
  Future<bool> registrarUsuario(
    String correoElectronico,
    String nombre,
    String primerApellido,
    String segundoApellido,
    String telefono,
    String password,
    String rol,
    bool verificacionAdmin,
  ) async {
    try {
      final AuthResponse res = await supabase.auth.signUp(
        email: correoElectronico,
        password: password,
      );
      final Session? session = res.session;
      final User? user = res.user;

      if (user == null) {
        return false;
      } else {
        // Aquí puedes guardar el usuario en tu base de datos
        final List<Map<String, dynamic>> data = await supabase.from('usuario').insert([{
          'correo_electronico': correoElectronico,
          'nombre': nombre,
          'primer_apellido': primerApellido,
          'segundo_apellido': segundoApellido,
          'telefono': telefono,
          'rol': rol,
          'verificacion_admin': verificacionAdmin,
          'id_instalacion': 1, // Asignar una instalación por defecto
        }]).select();

/*
        http.post(
          Uri.parse(urlN8N),
          body: jsonEncode({
            'email_por_aprobar': correoElectronico,
            'nombre': '$nombre $primerApellido $segundoApellido',
            'telefono': telefono,
            'id_usuario': usuario.folioUsuario,
          }),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        );
        */

        if (data.isEmpty) {
          throw Exception(
            'Error al registrar usuario: ${data[0]['error']}',
          );
        }
      }

      return true;
    } catch (e) {
      print('Error al registrar usuario: $e');
      return false;
    }
  }

  @override
  Future<void> iniciarSesion(String correoElectronico, String password) {
    // Implementación del inicio de sesión
    try {
      // Aquí iría la lógica para iniciar sesión al usuario en Firebase o en tu backend
      // Por ejemplo, podrías usar FirebaseAuth para autenticar al usuario
    } catch (e) {
      throw Exception('Error al iniciar sesión: $e');
    }

    return Future.error('No implementado');
  }

  @override
  Future<void> cerrarSesion() {
    // Implementación del cierre de sesión
    try {
      // Aquí iría la lógica para cerrar sesión del usuario en Firebase o en tu backend
    } catch (e) {
      throw Exception('Error al cerrar sesión: $e');
    }
    return Future.error('No implementado');
  }

  @override
  Future<void> actualizarPerfil(
    String nombre,
    String apellidoPaterno,
    String apellidoMaterno,
  ) {
    // Implementación de la actualización de perfil
    try {
      // Aquí iría la lógica para actualizar el perfil del usuario en Firebase o en tu backend
    } catch (e) {
      throw Exception('Error al actualizar perfil: $e');
    }
    return Future.error('No implementado');
  }

  @override
  Future<String?> obtenerToken() {
    // Implementación de la obtención de token
    return Future.error('No implementado');
  }

  @override
  Future<Usuario?> obtenerUsuario(String? correoElectronico) {
    // Implementación de la consulta de usuario
    return Future.error('No implementado');
  }
}
