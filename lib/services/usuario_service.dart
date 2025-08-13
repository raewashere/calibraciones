import 'package:calibraciones/models/_usuario.dart';

abstract class UsuarioService {
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
    String nombreInstalacionw
  );

  Future<void> iniciarSesion(String correoElectronico, String password);

  Future<void> cerrarSesion();

  Future<void> actualizarPerfil(
    String nombre,
    String apellidoPaterno,
    String apellidoMaterno,
  );

  Future<String?> obtenerToken();

  //Consultar usuario
  Future<Usuario?> obtenerUsuario(String? correoElectronico);
}