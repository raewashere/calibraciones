import 'package:calibraciones/models/_calibracion_equipo.dart';

class LaboratorioCalibracion {
  late int idLaboratorioCalibracion;
  late String nombre;
  late List<CalibracionEquipo> registroCalibraciones;

  LaboratorioCalibracion(
    this.idLaboratorioCalibracion,
    this.nombre,
    this.registroCalibraciones,
  );

  // Getters para acceder a los atributos
  int get getIdLaboratorioCalibracion => idLaboratorioCalibracion;
  String get getNombre => nombre;
  List<CalibracionEquipo> get getRegistroCalibraciones => registroCalibraciones;

  set setIdLaboratorioCalibracion(int value) {
    idLaboratorioCalibracion = value; // Asignación correcta
  }

  set setNombre(String value) {
    nombre = value; // Asignación correcta
  }

  set setRegistroCalibracion(List<CalibracionEquipo> value) {
    registroCalibraciones = value;
  }

  static fromJson(Map<String, dynamic> laboratorioJson) {
    return LaboratorioCalibracion(
      laboratorioJson['id_laboratorio_calibracion'],
      laboratorioJson['nombre'],
      (laboratorioJson['calibraciones'] as List)
          .map((calibracionJson) => CalibracionEquipo.fromJson(calibracionJson))
          .toList(),
    );
  }

  factory LaboratorioCalibracion.fromJsonFactory(Map<String, dynamic> json) {
    return LaboratorioCalibracion(
      json['id_laboratorio_calibracion'],
      json['nombre'],
      [],
    );
  }
}
