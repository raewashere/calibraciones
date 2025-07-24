import 'package:calibraciones/models/_instalacion.dart';

class Subdireccion {
  late int idSubdireccion;
  late String nombre;
  late List<Instalacion> instalaciones;

  Subdireccion(this.idSubdireccion, this.nombre, this.instalaciones);

  // Getters para acceder a los atributos
  int get getIdSubdireccion => idSubdireccion;
  String get getNombre => nombre;
  List<Instalacion> get getInstalaciones => instalaciones;

  set setIdSubdireccion(int value) {
    idSubdireccion = value; // Asignación correcta
  }

  set setNombre(String value) {
    nombre = value; // Asignación correcta
  }

  set setInstalaciones(List<Instalacion> value) {
    instalaciones = value; // Asignación correcta
  }

  factory Subdireccion.fromJson(Map<String, dynamic> subdireccionJson) {
    return Subdireccion(
      subdireccionJson['id_subdireccion'],
      subdireccionJson['nombre_subdireccion'],
      (subdireccionJson['instalaciones'] as List)
          .map((instalacionJson) => Instalacion.fromJson(instalacionJson))
          .toList(),
    );
  }
}
