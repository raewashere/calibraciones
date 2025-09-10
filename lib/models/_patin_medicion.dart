import 'package:calibraciones/models/_tren_medicion.dart';

class PatinMedicion {
  late String tagPatin;
  late String nombrePatin;
  late String tipoFluido;
  late String tipo;
  late List<TrenMedicion> trenMedicion;

  PatinMedicion(
    this.tagPatin,
    this.nombrePatin,
    this.tipoFluido,
    this.tipo,
    this.trenMedicion,
  );

  // Getters para acceder a los atributos
  String get getTagPatin => tagPatin;
  String get getNombrePatin => nombrePatin;
  String get getTipoFluido => tipoFluido;
  String get getTipo => tipo;
  List<TrenMedicion> get getTrenMedicion => trenMedicion;


  set setTagPatin(String value) {
    tagPatin = value; // Asignación correcta
  }
  set setNombrePatin(String value) {
    nombrePatin = value; // Asignación correcta
  }
  set setTipoFluido(String value) {
    tipoFluido = value; // Asignación correcta
  }
  set setTipo(String value) {
    tipo = value; // Asignación correcta
  }
  set setTrenMedicion(List<TrenMedicion> value) {
    trenMedicion = value; // Asignación correcta
  }

  factory PatinMedicion.fromJson(Map<String, dynamic> patinMedicionJson) {
    return PatinMedicion(
      patinMedicionJson['tag_patin'],
      patinMedicionJson['nombre_patin'],
      patinMedicionJson['tipo_fluido'],
      patinMedicionJson['tipo'],
      (patinMedicionJson['tren_medicion'] as List)
          .map((trenJson) => TrenMedicion.fromJson(trenJson))
          .toList(),
    );
  }

}
