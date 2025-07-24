import 'package:calibraciones/models/_gerencia.dart';
import 'package:calibraciones/models/_instalacion.dart';
import 'package:calibraciones/models/_subdireccion.dart';

class SubdireccionLogistica extends Subdireccion {

  late List<Gerencia> gerencias;
  SubdireccionLogistica(super.idSubdireccion, super.nombre, super.instalaciones);
  SubdireccionLogistica.withGerencias(
    super.idSubdireccion,
    super.nombre,
    super.instalaciones,
    this.gerencias,
  );

  static fromJson(Map<String, dynamic> subdireccionJson) {
    return SubdireccionLogistica(
      subdireccionJson['id_subdireccion'],
      subdireccionJson['nombre_subdireccion'],
      (subdireccionJson['instalaciones'] as List)
          .map((instalacionJson) => Instalacion.fromJson(instalacionJson))
          .toList(),
    )..gerencias = (subdireccionJson['gerencias'] as List)
        .map((gerenciaJson) => Gerencia.fromJson(gerenciaJson))
        .toList();
  }

}