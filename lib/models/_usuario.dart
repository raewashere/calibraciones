import 'package:calibraciones/models/_calibracion_equipo.dart';

class Usuario {
  // Atributos privados
  int folioUsuario;
  String correoElectronico;
  String nombre;
  String primerApellido;
  String segundoApellido;
  String telefono;
  String password = '';
  String rol;
  bool verificacionAdmin;
  int idInstalacion;
  List<CalibracionEquipo> registroCalibraciones = [];

  // Constructor
  Usuario(
    this.folioUsuario,
    this.correoElectronico,
    this.nombre,
    this.primerApellido,
    this.segundoApellido,
    this.telefono,
    this.rol,
    this.verificacionAdmin,
    this.idInstalacion,
  );

  

  int get getFolioUsuario => folioUsuario;
  String get getCorreoElectronico => correoElectronico;
  String get getNombre => nombre;
  String get getPrimerApellido => primerApellido;
  String get getSegundoApellido => segundoApellido;
  String get getTelefono => telefono;
  String get getPasword => password;
  String get getRol => rol;
  bool get getVerificacionAdmin => verificacionAdmin;
  int get getIdInstalacion => idInstalacion;
  List<CalibracionEquipo> getRegistroCalibraciones() => registroCalibraciones;

  set setFolioUsuario(int value) {
    folioUsuario = value;
  }

  set setCorreoElectronico(String value) {
    correoElectronico = value;
  }

  set setNombre(String value) {
    nombre = value;
  }

  set setPrimerApellido(String value) {
    primerApellido = value;
  }

  set setSegundoApellido(String value) {
    segundoApellido = value;
  }

  set setTelefono(String value) {
    telefono = value;
  }

  set setPassword(String value) {
    password = value;
  }

  set setRol(String value) {
    rol = value;
  }

  set setVerificacionAdmin(bool value) {
    verificacionAdmin = value;
  }

  set setRegistroCalibracion(List<CalibracionEquipo> value) {
    registroCalibraciones = value;
  }

  set setIdInstalacion(int value) {
    idInstalacion = value;
  }

  factory Usuario.fromJsonCreate(Map<String, dynamic> json) {
    return Usuario(
      json['id_usuario'] as int,
      json['correo_electronico'] as String,
      json['nombre'] as String,
      json['primer_apellido'] as String,
      json['segundo_apellido'] as String,
      json['telefono'] as String,
      json['rol'] as String,
      json['verificacion_admin'] as bool,
      json['id_instalacion'] as int
    );
  }

  //A String representation of the Usuario object
  @override
  String toString() {
    return 'Usuario(folioUsuario: $folioUsuario, correoElectronico: $correoElectronico, nombre: $nombre, primerApellido: $primerApellido, segundoApellido: $segundoApellido, telefono: $telefono, rol: $rol, verificacionAdmin: $verificacionAdmin, idInstalacion: $idInstalacion)';
  }
}
