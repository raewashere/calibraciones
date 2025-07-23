import 'package:calibraciones/models/_equipo.dart';

class ComputadoraFlujo {
  late String tagComputadoraFlujo;
  late String configuracionPuerto;
  late String protocolo;
  late String puertoDisponible;
  late String versionSoftware;
  late List<Equipo> equiposMedicion;

  ComputadoraFlujo(
    this.tagComputadoraFlujo,
    this.configuracionPuerto,
    this.protocolo,
    this.puertoDisponible,
    this.versionSoftware,
    this.equiposMedicion
  );

  String get getTagComputadoraFlujo => tagComputadoraFlujo;
  String get getConfiguracionPuerto => configuracionPuerto;
  String get getProtocolo => protocolo;
  String get getPuertoDisponible => puertoDisponible;
  String get getVersionSoftware => versionSoftware;
  List<Equipo> get getequiposMedicion => equiposMedicion;
 
  set setTagComputadoraFlujo(String value) {
    tagComputadoraFlujo = value; // Asignación correcta
  }

  set setConfiguracionPuerto(String value) {
    configuracionPuerto = value; // Asignación correcta
  }

  set setProtocolo(String value) {
    protocolo = value; // Asignación correcta
  } 

  set setPuertoDisponible(String value) {
    puertoDisponible = value; // Asignación correcta
  }

  set setVersionSoftware(String value) {
    versionSoftware = value; // Asignación correcta
  }

  set setEquiposMedicion(List<Equipo> value){
    equiposMedicion = value;
  }
}
