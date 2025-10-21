import 'package:calibraciones/models/_corrida.dart';

class CalibracionEquipo {
  late int idCalibracionEquipo;
  late String certificadoCalibracion;
  late DateTime fechaCalibracion;
  late DateTime fechaProximaCalibracion;
  late double linealidad;
  late double reproducibilidad;
  late String observaciones;
  late String rutaCertificado;
  late List<Corrida> corridas;
  //Referencias a otros objetos
  late String tagEquipo;
  late int idLaboratorioCalibracion;
  late int idUsuario;

  CalibracionEquipo(
    this.idCalibracionEquipo,
    this.certificadoCalibracion,
    this.fechaCalibracion,
    this.fechaProximaCalibracion,
    this.linealidad,
    this.reproducibilidad,
    this.observaciones,
    this.rutaCertificado,
    this.corridas,
    this.tagEquipo,
    this.idLaboratorioCalibracion,
    this.idUsuario,
  );

  //Otro constructor sin corridas
  CalibracionEquipo.sinCorridas(
    this.idCalibracionEquipo,
    this.certificadoCalibracion,
    this.fechaCalibracion,
    this.fechaProximaCalibracion,
    this.linealidad,
    this.reproducibilidad,
    this.observaciones,
    this.rutaCertificado,
    this.tagEquipo,
    this.idLaboratorioCalibracion,
    this.idUsuario,
  );

  int get getIdCalibracionEquipo => idCalibracionEquipo;
  String get getCertificadoCalibracion => certificadoCalibracion;
  DateTime get getFechaCalibracion => fechaCalibracion;
  DateTime get getFechaProximaCalibracion => fechaProximaCalibracion;
  double get getLinealidad => linealidad;
  double get getReproducibilidad => reproducibilidad;
  String get getObservaciones => observaciones;
  //String get getDocumentoCertificado => documentoCertificado;
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

  set setRutaCertificado(String value) {
    rutaCertificado = value;
  }

  set setCorridas(List<Corrida> value) {
    corridas = value;
  }

  set setTagEquipo(String value) {
    tagEquipo = value;
  }

  set setIdLaboratorioCalibracion(int value) {
    idLaboratorioCalibracion = value;
  }

  set setIdUsuario(int value) {
    idUsuario = value;
  }

  factory CalibracionEquipo.fromJson(Map<String, dynamic> calibracionJson) {
    return CalibracionEquipo.sinCorridas(
      calibracionJson['id_calibracion'],
      calibracionJson['certificado_calibracion'],

      //Cover
      DateTime.parse(calibracionJson['fecha_calibracion']),
      DateTime.parse(calibracionJson['fecha_proxima_calibracion']),
      calibracionJson['linealidad'],
      calibracionJson['reproducibilidad'],
      calibracionJson['observaciones'],
      calibracionJson['ruta_certificado'],
      /*(calibracionJson['lista_corridas'] as List)
          .map((corridaJson) => Corrida.fromJson(corridaJson))
          .toList(),*/
      calibracionJson['tag_equipo'],
      calibracionJson['id_laboratorio_calibracion'],
      calibracionJson['id_usuario'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      //'id_calibracion': 1,
      'certificado_calibracion': certificadoCalibracion,
      'fecha_calibracion': fechaCalibracion.toIso8601String(),
      'fecha_proxima_calibracion': fechaProximaCalibracion.toIso8601String(),
      'linealidad': linealidad,
      'reproducibilidad': reproducibilidad,
      'observaciones': observaciones,
      'ruta_certificado': rutaCertificado,
      //'corrida': corridas.map((corrida) => corrida.toJson()).toList(),
      'tag_equipo': tagEquipo,
      'id_laboratorio_calibracion':
          idLaboratorioCalibracion, // Valor fijo por ahora
      'id_usuario': idUsuario, // Valor fijo por ahora
    };
  }
}
