import 'package:calibraciones/models/_entidad_federativa.dart';
import 'package:calibraciones/models/_transporte_ducto.dart';

class Instalacion {
  late int idInstalacion;
  late String nombreInstalacion;
  late String regionFiscal;
  late EntidadFederativa entidad;
  late List<TransporteDucto> ductos;

  Instalacion(
    this.idInstalacion,
    this.nombreInstalacion,
    this.regionFiscal,
    this.entidad,
    this.ductos,
  );

  // Getters para acceder a los atributos
  int get getIdInstalacion => idInstalacion;
  String get getNombreInstalacion => nombreInstalacion;
  String get getRegionFiscal => regionFiscal;
  EntidadFederativa get getEntidad => entidad;
  List<TransporteDucto> getDuctos() => ductos;

  set setIdInstalacion(int value) {
    idInstalacion = value; // Asignación correcta
  }

  set setNombreInstalacion(String value) {
    nombreInstalacion = value; // Asignación correcta
  }

  set setRegionFiscal(String value) {
    regionFiscal = value; // Asignación correcta
  }

  set setEntidad(EntidadFederativa value) {
    entidad = value; // Asignación correcta
  }

  set setDuctos(List<TransporteDucto> value) {
    ductos = value;
  }

  factory Instalacion.fromJson(Map<String, dynamic> instalacionJson) {
    return Instalacion(
      instalacionJson['id_instalacion'],
      instalacionJson['nombre_instalacion'],
      instalacionJson['region_fiscal'],
      EntidadFederativa.fromJson(instalacionJson['entidad_federativa']),
      (instalacionJson['lista_transporte_ducto'] as List)
          .map((ductoJson) => TransporteDucto.fromJson(ductoJson))
          .toList(),
    );
  }
  
}
  
