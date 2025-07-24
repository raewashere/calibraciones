class Gerencia {
  late int idGerencia;
  late String nombre;

  Gerencia(this.idGerencia, this.nombre);

  int get getIdGerencia => idGerencia;
  String get getNombre => nombre;

  set setIdGerencia(int value) {
    idGerencia = value;
  }

  set setNombre(String value) {
    nombre = value;
  }

  factory Gerencia.fromJson(Map<String, dynamic> gerenciaJson) {
    return Gerencia(
      gerenciaJson['id_gerencia'],
      gerenciaJson['nombre_gerencia'],
    );
  }
}