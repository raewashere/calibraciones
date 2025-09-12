class Equipo {
  late String tagEquipo;
  late String estado;
  late double incertidumbre;
  late int intervaloCalibracion;
  late int intervaloVerificacion;
  late String magnitudIncertidumbre;
  late String marca;
  late String modelo;
  late String noSerie;
  late String tipoMedicion;

  Equipo(
    this.tagEquipo,
    this.estado,
    this.incertidumbre,
    this.intervaloCalibracion,
    this.intervaloVerificacion,
    this.magnitudIncertidumbre,
    this.marca,
    this.modelo,
    this.noSerie,
    this.tipoMedicion,
  );

  // Getters para acceder a los atributos
  String get getTagEquipo => tagEquipo;
  String get getTIpoMedicion => tipoMedicion;
  String get getEstado => estado;
  String get getMarca => marca;
  String get getModelo => modelo;
  String get getNoSerie => noSerie;
  int get getIntervaloCalibracion => intervaloCalibracion;
  int get getIntervaloVerificacion => intervaloVerificacion;
  double get getIncertidumbre => incertidumbre;
  String get getMagnitudIncertidumbre => magnitudIncertidumbre;

  set setTagEquipo(String value) {
    tagEquipo = value; // Asignación correcta
  }

  set setTipoMedicion(String value) {
    tipoMedicion = value;
  }

  set setEstado(String value) {
    estado = value;
  }

  set setMarca(String value) {
    marca = value;
  }

  set setModelo(String value) {
    modelo = value;
  }

  set setNoSerie(String value) {
    noSerie = value;
  }

  set setIntervaloCalibracion(int value) {
    intervaloCalibracion = value;
  }

  set setIntervaloVerificacion(int value) {
    intervaloVerificacion = value;
  }

  set setIncertidumbre(double value) {
    incertidumbre = value;
  }

  set setMagnitudIncertidumbre(String value) {
    magnitudIncertidumbre = value;
  }

  factory Equipo.fromJson(Map<String, dynamic> equipoJson) {
    return Equipo(
      equipoJson['tag_equipo'],
      equipoJson['estado'],
      equipoJson['incertidumbre'].toDouble(),
      equipoJson['intervalo_calibracion'],
      equipoJson['intervalo_verificacion'],
      equipoJson['magnitud_incertidumbre'],
      equipoJson['marca'],
      equipoJson['modelo'],
      equipoJson['no_serie'],
      equipoJson['tipo_medicion'],
    );
  }
}
