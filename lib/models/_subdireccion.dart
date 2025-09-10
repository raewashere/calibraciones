import 'package:calibraciones/models/_gerencia.dart';
import 'package:calibraciones/models/_instalacion.dart';

class Subdireccion {
  late int idSubdireccion;
  late String nombre;
  late List<Gerencia> gerencias;
  late List<Instalacion> instalaciones;

  Subdireccion(
    this.idSubdireccion,
    this.nombre,
    this.instalaciones,
    this.gerencias,
  );

  factory Subdireccion.fromJson(Map<String, dynamic> subdireccionJson) {
    return Subdireccion(
      subdireccionJson['id_subdireccion'],
      subdireccionJson['nombre_subdireccion'],
      // instalaciones directas (pueden no existir)
      (subdireccionJson['instalacion'] != null
          ? (subdireccionJson['instalacion'] as List)
              .map((instJson) => Instalacion.fromJson(instJson))
              .toList()
          : <Instalacion>[]),
      // gerencias (pueden no existir)
      (subdireccionJson['gerencia'] != null
          ? (subdireccionJson['gerencia'] as List)
              .map((gerenciaJson) => Gerencia.fromJson(gerenciaJson))
              .toList()
          : <Gerencia>[]),
    );
  }
}
