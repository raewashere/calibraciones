import 'package:calibraciones/models/_calibracion_equipo.dart';

class Usuario {
  // Atributos privados
  late final int folioUsuario;
  late String correoElectronico;
  late String nombre;
  late String primerApellido;
  late String segundoApellido;
  late String telefono;
  late String password;
  late String rol;
  late bool verificacionAdmin;
  late List<CalibracionEquipo> registroCalibraciones;

  // Constructor
  Usuario(
    this.folioUsuario,
    this.correoElectronico,
    this.nombre,
    this.primerApellido,
    this.segundoApellido,
    this.telefono,
    this.password,
    this.rol,
    this.verificacionAdmin,
    this.registroCalibraciones,
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
}
