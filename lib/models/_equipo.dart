import 'package:calibraciones/models/_calibracion_equipo.dart';
import 'package:calibraciones/models/_computadora_flujo.dart';
import 'package:calibraciones/models/_tipo_sensor.dart';

class Equipo {
  late String tagEquipo;
  late String tipoMedicion;
  late String estado;
  late String marca;
  late String modelo;
  late String noSerie;
  late int intervaloCalibracion;
  late int intervaloVerificacion;
  late double incertidumbre;
  late String magnitudIncertidumbre;
  late List<CalibracionEquipo> calibraciones;
  late TipoSensor tipoSensor;
  late ComputadoraFlujo computadoraFlujo;

  Equipo(
    this.tagEquipo,
    this.tipoMedicion,
    this.estado,
    this.marca,
    this.modelo,
    this.noSerie,
    this.intervaloCalibracion,
    this.intervaloVerificacion,
    this.incertidumbre,
    this.magnitudIncertidumbre,
    this.calibraciones,
    this.tipoSensor
  );

  // Getters para acceder a los atributos
  String get getTagEquipo => tagEquipo;
  String get getTIpoMedicion => tipoMedicion;
  String get getEstado => estado;
  String get getMarca => marca;
  String get getModelo => modelo;
  String get getNoSerie => noSerie;
  int get getIntervaloCalibracion => intervaloCalibracion;
  int get getIntervaloVerificacion => intervaloVerificacion;
  double get getIncertidumbre => incertidumbre;
  String get getMagnitudIncertidumbre => magnitudIncertidumbre;
  List<CalibracionEquipo> get getCalibraciones => calibraciones;
  TipoSensor get getTipoSensor =>   tipoSensor;
  ComputadoraFlujo get getTagComputadoraFlujo => computadoraFlujo;

  set setTagEquipo(String value) {
    tagEquipo = value; // Asignación correcta
  }

  set setTipoMedicion(String value) {
    tipoMedicion = value;
  }

  set setEstado(String value) {
    estado = value;
  }

  set setMarca(String value) {
    marca = value;
  }

  set setModelo(String value) {
    modelo = value;
  }

  set setNoSerie(String value) {
    noSerie = value;
  }

  set setIntervaloCalibracion(int value) {
    intervaloCalibracion = value;
  }

  set setIntervaloVerificacion(int value) {
    intervaloVerificacion = value;
  }

  set setIncertidumbre(double value) {
    incertidumbre = value;
  }

  set setMagnitudIncertidumbre(String value) {
    magnitudIncertidumbre = value;
  }

  set setCalibracionesEquipo(List<CalibracionEquipo> value) {
    calibraciones = value;
  }

  set setTipoSensor(TipoSensor value){
    tipoSensor = value;
  }

  set setComputadoraFlujo(ComputadoraFlujo value) {
    computadoraFlujo = value;
  }

  factory Equipo.fromJson(Map<String, dynamic> equipoJson) {
    return Equipo(
      equipoJson['tag_equipo'],
      equipoJson['tipo_medicion'],
      equipoJson['estado'],
      equipoJson['marca'],
      equipoJson['modelo'],
      equipoJson['no_serie'],
      equipoJson['intervalo_calibracion'],
      equipoJson['intervalo_verificacion'],
      equipoJson['incertidumbre'].toDouble(),
      equipoJson['magnitud_incertidumbre'],
      (equipoJson['lista_calibraciones'] as List)
          .map((calibracionJson) => CalibracionEquipo.fromJson(calibracionJson))
          .toList(),
      TipoSensor.fromJson(equipoJson['tipo_sensor']),
    );
  }
  
}
