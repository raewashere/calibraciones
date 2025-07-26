import 'package:calibraciones/models/_usuario.dart';
import 'package:calibraciones/services/usuario_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; 

class UsuarioServiceImpl implements UsuarioService {

  final String url = "http://127.0.0.1:8090/api";


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
  ) {
    // Implementación del registro de usuario
    try {
      
      http.post(Uri.parse('$url/usuario'), body: jsonEncode({
        'correo_electronico': correoElectronico,
        'nombre': nombre,
        'primer_apellido': primerApellido,
        'segundo_apellido': segundoApellido,
        'telefono': telefono,
        'password': password,
        'rol': rol,
        'verificacion_admin': verificacionAdmin,
      }),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }
      ).then((http.Response response) {
        if (response.statusCode == 201) {
          final FirebaseAuth auth = FirebaseAuth.instance;
          auth.createUserWithEmailAndPassword(email: correoElectronico, password: password);
          auth.currentUser?.sendEmailVerification();

          return Future.value(true);
          } else {
            throw Exception('Error al registrar usuario: ${response.statusCode}');
          }
        });

        return Future.value(false);
    } catch (e) {
      return Future.value(false);
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