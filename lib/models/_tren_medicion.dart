class TrenMedicion {
  late String tagTren;
  late String estado;
  late String puntoMedicion;

  TrenMedicion(
    this.tagTren,
    this.estado,
    this.puntoMedicion,
  );

  // Getters para acceder a los atributos
  String get getTagTren => tagTren;
  String get getEstado => estado;
  String get getPuntoMedicion => puntoMedicion;

  set setTagTren(String value) {
    tagTren = value; // Asignación correcta
  }
  set setEstado(String value) {
    estado = value; // Asignación correcta
  }
  set setPuntoMedicion(String value) {
    puntoMedicion = value; // Asignación correcta
  }
  
  factory TrenMedicion.fromJson(Map<String, dynamic> trenMedicionJson) {
    return TrenMedicion(
      trenMedicionJson['tag_tren'],
      trenMedicionJson['estado'],
      trenMedicionJson['punto_medicion'],
    );
  }
}
