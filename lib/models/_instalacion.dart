
import 'package:calibraciones/models/_patin_medicion.dart';

class Instalacion {
  late int idInstalacion;
  late String nombreInstalacion;
  late List<PatinMedicion> patinesMedicion;

  Instalacion(
    this.idInstalacion,
    this.nombreInstalacion,
    this.patinesMedicion,
  );

  // Getters para acceder a los atributos
  int get getIdInstalacion => idInstalacion;
  String get getNombreInstalacion => nombreInstalacion;
  List<PatinMedicion> get getPatinesMedicion => patinesMedicion;

  set setIdInstalacion(int value) {
    idInstalacion = value; // Asignación correcta
  }

  set setNombreInstalacion(String value) {
    nombreInstalacion = value; // Asignación correcta
  }

  set setPatinesMedicion(List<PatinMedicion> value) {
    patinesMedicion = value; // Asignación correcta
  }

  factory Instalacion.fromJson(Map<String, dynamic> instalacionJson) {
    return Instalacion(
      instalacionJson['id_instalacion'],
      instalacionJson['nombre_instalacion'],
      (instalacionJson['patin_medicion'] as List)
          .map((patinJson) => PatinMedicion.fromJson(patinJson))
          .toList(),
    );
  }
  
}
  
