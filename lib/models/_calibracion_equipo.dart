
import 'package:calibraciones/models/_corrida.dart';

class CalibracionEquipo {
  late int idCalibracionEquipo;
  late String certificadoCalibracion;
  late DateTime fechaCalibracion;
  late DateTime fechaProximaCalibracion;
  late double linealidad;
  late double reproducibilidad;
  late String observaciones;
  late String documentoCertificado;
  late List<Corrida> corridas;
  //Referencias a otros objetos
  late String tagEquipo;

  CalibracionEquipo(
    this.idCalibracionEquipo,
    this.certificadoCalibracion,
    this.fechaCalibracion,
    this.fechaProximaCalibracion,
    this.linealidad,
    this.reproducibilidad,
    this.observaciones,
    this.documentoCertificado,
    this.corridas,
    this.tagEquipo,
  );

  int get getIdCalibracionEquipo => idCalibracionEquipo;
  String get getCertificadoCalibracion => certificadoCalibracion;
  DateTime get getFechaCalibracion => fechaCalibracion;
  DateTime get getFechaProximaCalibracion => fechaProximaCalibracion;
  double get getLinealidad => linealidad;
  double get getReproducibilidad => reproducibilidad;
  String get getObservaciones => observaciones;
  String get getDocumentoCertificado => documentoCertificado;
  List<Corrida> getCorridas() => corridas;
  String getTagEquipo() => tagEquipo;

  set setIdCalibracionEquipo(int value) {
    idCalibracionEquipo = value;
  }

  set setCertificadoCalibracion(String value) {
    certificadoCalibracion = value;
  }

  set setFechaCalibracion(DateTime value) {
    fechaCalibracion = value;
  }

  set setFechaProximaCalibracion(DateTime value) {
    fechaProximaCalibracion = value;
  }

  set setLinealidad(double value) {
    linealidad = value;
  }

  set setReproducibilidad(double value) {
    reproducibilidad = value;
  }

  set setObservaciones(String value) {
    observaciones = value;
  }

  set setDocumentoCertificado(String value) {
    documentoCertificado = value;
  }

  set setCorridas(List<Corrida> value) {
    corridas = value;
  }

  set setTagEquipo(String value) {
    tagEquipo = value;
  }

  factory CalibracionEquipo.fromJson(Map<String, dynamic> calibracionJson) {
    return CalibracionEquipo(
      calibracionJson['id_calibracion'],
      calibracionJson['certificado_calibracion'],
      DateTime.parse(calibracionJson['fecha_calibracion']),
      DateTime.parse(calibracionJson['fecha_proxima_calibracion']),
      calibracionJson['linealidad'],
      calibracionJson['reproducibilidad'],
      calibracionJson['observaciones'],
      calibracionJson['documento_certificado'],
      (calibracionJson['lista_corridas'] as List)
          .map((corridaJson) => Corrida.fromJson(corridaJson))
          .toList(),
      calibracionJson['tag_equipo'],
    );
  }
}
