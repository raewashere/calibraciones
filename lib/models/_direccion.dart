import 'package:calibraciones/models/_subdireccion.dart';

class Direccion {
  late int idDireccion;
  late String nombre;
  late List<Subdireccion> subdirecciones;

  Direccion(
    this.idDireccion,
    this.nombre,
    this.subdirecciones,
  );

  int get getIdDireccion => idDireccion;
  String get getNombre => nombre;
  List<Subdireccion> get getSubdirecciones => subdirecciones;

  set setIdDireccion(int value) {
    idDireccion = value;
  }
  set setNombre(String value) {
    nombre = value;
  }
  set setSubdirecciones(List<Subdireccion> value) {
    subdirecciones = value;
  }

  factory Direccion.fromJson(Map<String, dynamic> direccionJson) {
    return Direccion(
      direccionJson['id_direccion'],
      direccionJson['nombre_direccion'],
      (direccionJson['subdireccion'] as List)
          .map((subJson) => Subdireccion.fromJson(subJson))
          .toList(),
    );
  }
}

