import 'package:calibraciones/models/_subdireccion.dart';

class Direccion {
  late int idDireccion;
  late String nombre;
  late List<Subdireccion> subdirecciones;

  Direccion(
     int idDireccion,
     String nombre,
     List<Subdireccion> subdirecciones
  );

  // Getters para acceder a los atributos
  int get getIdDireccion => idDireccion;
  String get getNombre => nombre;
  List<Subdireccion> getSubdirecciones() => subdirecciones;

  set setIdDireccion(int value) {
    idDireccion = value; // Asignación correcta
  }

  set setNombre(String value) {
    nombre = value; // Asignación correcta
  }

  set setSubdirecciones(List<Subdireccion> value) {
    subdirecciones = value;
  }
}
