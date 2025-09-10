import 'package:calibraciones/models/_instalacion.dart';

class Gerencia {
  late int idGerencia;
  late String nombre;
  late List<Instalacion> instalaciones;

  Gerencia(this.idGerencia, this.nombre, this.instalaciones);

  factory Gerencia.fromJson(Map<String, dynamic> gerenciaJson) {
    return Gerencia(
      gerenciaJson['id_gerencia'],
      gerenciaJson['nombre_gerencia'],
      (gerenciaJson['instalacion'] != null
          ? (gerenciaJson['instalacion'] as List)
              .map((instJson) => Instalacion.fromJson(instJson))
              .toList()
          : <Instalacion>[]),
    );
  }
}
