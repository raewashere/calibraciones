import 'package:calibraciones/dto/dto_instalacion.dart';

class DtoGerencia {
  late int idGerencia;
  late String nombreGerencia;
  late List<DtoInstalacion> instalaciones;

  DtoGerencia(this.idGerencia, this.nombreGerencia, this.instalaciones);

  @override
  String toString() {
    return 'DtoGerencia{id: $idGerencia, nombre: $nombreGerencia, instalaciones: $instalaciones}';
  }

  factory DtoGerencia.fromJson(Map<String, dynamic> json, List<DtoInstalacion> instalaciones) {
    return DtoGerencia(
      json['id_gerencia'],
      json['nombre_gerencia'],
      instalaciones,
    );
  }

  int getIdGerencia() {
    return idGerencia;
  }

  String getNombreGerencia() {
    return nombreGerencia;
  }

  List<DtoInstalacion> getInstalaciones() {
    return instalaciones;
  }
}