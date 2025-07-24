import 'package:calibraciones/models/_computadora_flujo.dart';
import 'package:calibraciones/models/_equipo.dart';

class TransporteDucto {
  late int idTransporteDucto;
  late String nombre;
  late String tipoFluido;
  late List<Equipo> equipos;
  late List<ComputadoraFlujo> computadorasFlujo;

  TransporteDucto(
    this.idTransporteDucto,
    this.nombre,
    this.tipoFluido,
    this.equipos,
    this.computadorasFlujo,
  );

  // Getters para acceder a los atributos
  int get getIdTransporteDucto => idTransporteDucto;
  String get getNombre => nombre;
  String get getTipoFluido => tipoFluido;
  List<Equipo> getEquipos() => equipos;
  List<ComputadoraFlujo> getComputadorasFlujo() => computadorasFlujo;

  set setIdTransporteDucto(int value) {
    idTransporteDucto = value; // Asignación correcta
  }

  set setNombre(String value) {
    nombre = value; // Asignación correcta
  }

  set setTipoFluido(String value) {
    tipoFluido = value; // Asignación correcta
  }

  set setEquipos(List<Equipo> equiposRegular) {
    equipos = equiposRegular;
  }
  set setComputadorasFlujo(List<ComputadoraFlujo> computadoras) {
    computadorasFlujo = computadoras;
  }

factory TransporteDucto.fromJson(Map<String, dynamic> ductoJson) {
    return TransporteDucto(
      ductoJson['id_transporte_ducto'],
      ductoJson['nombre'],
      ductoJson['tipo_fluido'],
      (ductoJson['lista_equipo_medicion'] as List)
          .map((equipoJson) => Equipo.fromJson(equipoJson))
          .toList(),
      (ductoJson['lista_computadora_flujo'] as List)
          .map((computadoraJson) => ComputadoraFlujo.fromJson(computadoraJson))
          .toList(),
    );
  }
}
