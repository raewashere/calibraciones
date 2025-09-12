import 'package:calibraciones/models/_equipo.dart';

class TrenMedicion {
  late String tagTren;
  late String estado;
  late String puntoMedicion;
  late List<Equipo> equiposTren;

  TrenMedicion(this.tagTren, this.estado, this.puntoMedicion, this.equiposTren);

  // Getters para acceder a los atributos
  String get getTagTren => tagTren;
  String get getEstado => estado;
  String get getPuntoMedicion => puntoMedicion;
  List<Equipo> get getEquiposTren => equiposTren;

  set setTagTren(String value) {
    tagTren = value; // Asignación correcta
  }

  set setEstado(String value) {
    estado = value; // Asignación correcta
  }

  set setPuntoMedicion(String value) {
    puntoMedicion = value; // Asignación correcta
  }

  set setEquiposTren(List<Equipo> value) {
    equiposTren = value; // Asignación correcta
  }

  

  factory TrenMedicion.fromJson(Map<String, dynamic> trenMedicionJson) {
    return TrenMedicion(
      trenMedicionJson['tag_tren'],
      trenMedicionJson['estado'],
      trenMedicionJson['punto_medicion'],
      (trenMedicionJson['equipos_tren'] as List)
        .map((equipoJson) => Equipo.fromJson(equipoJson['equipo']))
        .toList(),
    );
  }
}
