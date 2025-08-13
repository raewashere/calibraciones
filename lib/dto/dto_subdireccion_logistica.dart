import 'package:calibraciones/dto/dto_gerencia.dart';

class DtoSubdireccionLogistica {
  late int idSubdireccion;
  late String nombreSubdireccion;
  late List<DtoGerencia> gerencias;

  DtoSubdireccionLogistica(this.idSubdireccion, this.nombreSubdireccion, this.gerencias);

  @override
  String toString() {
    return 'DtoSubdireccionLogistica{id: $idSubdireccion, nombre: $nombreSubdireccion, gerencias: $gerencias}';
  }

  factory DtoSubdireccionLogistica.fromJson(Map<String, dynamic> json, List<DtoGerencia> gerencias) {
    return DtoSubdireccionLogistica(
      json['id_subdireccion'],
      json['nombre_subdireccion'],
      gerencias
    );
  }

  int getIdSubdireccion() {
    return idSubdireccion;
  }

  String getNombreSubdireccion() {
    return nombreSubdireccion;
  }

  List<DtoGerencia> getGerencias() {
    return gerencias;
  }

  

  
}