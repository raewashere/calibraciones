import 'package:calibraciones/models/_usuario.dart';
import 'package:calibraciones/services/usuario_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';

class UsuarioServiceImpl implements UsuarioService {
  final SupabaseClient supabase = Supabase.instance.client;
  final String urlN8N =
      "https://n8n-1xb0.onrender.com/webhook/31f9de4b-5677-4e3a-aa03-31e7174c7b6a";
  @override
  Future<bool> registrarUsuario(
    String correoElectronico,
    String nombre,
    String primerApellido,
    String segundoApellido,
    String telefono,
    String password,
    String nombreDireccion,
    String nombreSubdireccion,
    String nombreGerencia,
    int idInstalacion,
    String nombreInstalacion,
  ) async {
    try {
      final AuthResponse res = await supabase.auth.signUp(
        email: correoElectronico,
        password: password,
      );
      final User? user = res.user;

      if (user == null) {
        return false;
      } else {
        // Aquí puedes guardar el usuario en tu base de datos
        final List<Map<String, dynamic>> data = await supabase
            .from('usuario')
            .insert([
              {
                'correo_electronico': correoElectronico,
                'nombre': nombre,
                'primer_apellido': primerApellido,
                'segundo_apellido': segundoApellido,
                'telefono': telefono,
                'rol': 'usuario',
                'verificacion_admin': false,
                'id_instalacion': idInstalacion,
              },
            ])
            .select();

        final Usuario usuario = Usuario.fromJsonCreate(data[0]);

        http.post(
          Uri.parse(urlN8N),
          body: jsonEncode({
            'email_por_aprobar': correoElectronico,
            'nombre': '$nombre $primerApellido $segundoApellido',
            'telefono': telefono,
            'id_usuario': usuario.folioUsuario,
            'direccion': nombreDireccion,
            'subdireccion': nombreSubdireccion,
            'gerencia': nombreGerencia,
            'instalacion': nombreInstalacion,
          }),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        );

        if (data.isEmpty) {
          throw Exception('Error al registrar usuario: ${data[0]['error']}');
        }
      }

      return true;
    } catch (e) {
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
  Future<bool> actualizarDatosUsuario(
    int idUsuario,
    String correoElectronico,
    String nombre,
    String primerApellido,
    String segundoApellido,
    String telefono,
  ) async {
    // Implementación de la actualización de perfil
    try {
      /*final UserResponse res = await supabase.auth.updateUser(
        UserAttributes(email: correoElectronico),
      );*/

      await supabase
          .from('usuario')
          .update({
            //'correo_electronico': correoElectronico,
            'nombre': nombre,
            'primer_apellido': primerApellido,
            'segundo_apellido': segundoApellido,
            'telefono': telefono,
          })
          .eq('id_usuario', idUsuario);

      return Future.value(true);
    } catch (e) {
      throw Exception('Error al actualizar perfil: $e');
    }
  }

  @override
  Future<String?> obtenerToken() {
    // Implementación de la obtención de token
    return Future.error('No implementado');
  }

  @override
  Future<Usuario?> obtenerUsuario(String? correoElectronico) async {
    // Implementación de la consulta de usuario
    try {
      if (correoElectronico == null) {
        throw Exception('Correo electrónico no proporcionado');
      }

      final data = await Supabase.instance.client
          .from('usuario')
          .select()
          .eq('correo_electronico', correoElectronico);

      if (data.isEmpty) {
        return null;
      }
      return Usuario.fromJsonCreate(data[0]);
    } catch (e) {
      return Future.error(e);
    }
  }
}
