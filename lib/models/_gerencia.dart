import 'package:calibraciones/models/_instalacion.dart';

class Gerencia {
  late int idGerencia;
  late String nombre;
  late List<dynamic> instalaciones = [];

  Gerencia(this.idGerencia, this.nombre, this.instalaciones);

  int get getIdGerencia => idGerencia;
  String get getNombre => nombre;
  List<dynamic> get getInstalaciones => instalaciones;

  set setIdGerencia(int value) {
    idGerencia = value;
  }

  set setNombre(String value) {
    nombre = value;
  }

  set setInstalaciones(List<dynamic> value) {
    instalaciones = value;
  }

  factory Gerencia.fromJson(Map<String, dynamic> gerenciaJson) {
    return Gerencia(
      gerenciaJson['id_gerencia'],
      gerenciaJson['nombre_gerencia'],
      (gerenciaJson['instalaciones'] as List)
          .map((instalacionJson) => Instalacion.fromJson(instalacionJson))
          .toList(),
    );
  }
}