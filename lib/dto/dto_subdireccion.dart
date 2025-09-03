import 'package:calibraciones/dto/dto_gerencia.dart';

class DtoSubdireccion {
  late int idSubdireccion;
  late String nombreSubdireccion;

  DtoSubdireccion(this.idSubdireccion, this.nombreSubdireccion);

  @override
  String toString() {
    return 'DtoSubdireccion{id: $idSubdireccion, nombre: $nombreSubdireccion}';
  }

  factory DtoSubdireccion.fromJson(
    Map<String, dynamic> json,
    List<DtoGerencia> gerencias,
  ) {
    return DtoSubdireccion(
      json['id_subdireccion'],
      json['nombre_subdireccion'],
    );
  }

  int getIdSubdireccion() {
    return idSubdireccion;
  }

  String getNombreSubdireccion() {
    return nombreSubdireccion;
  }
}
