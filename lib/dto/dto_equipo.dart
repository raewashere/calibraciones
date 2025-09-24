class DtoEquipo {
  String tagEquipo;
  String estado;
  String marca;
  String modelo;
  String noSerie;
  String tipoSensor;

  DtoEquipo(
    this.tagEquipo,
    this.estado,
    this.marca,
    this.modelo,
    this.noSerie,
    this.tipoSensor,
  );

  @override
  String toString() {
    return 'DtoEquipo{tagEquipo: $tagEquipo, estado: $estado, marca: $marca, modelo: $modelo, noSerie: $noSerie, tipoSensor: $tipoSensor}';
  }

  factory DtoEquipo.fromJson(Map<String, dynamic> json) {
    String tipoSensor = '';

    //Convertir numero de sensor s string
    if (json['id_tipo_sensor'] is int) {
      if (json['id_tipo_sensor'] == 1) {
        tipoSensor = 'Medidor de flujo';
      } else if (json['id_tipo_sensor'] == 2) {
        tipoSensor = 'Temperatura';
      } else if (json['id_tipo_sensor'] == 3) {
        tipoSensor = 'Presión';
      } else {
        tipoSensor = 'Densidad';
      }
    }

    return DtoEquipo(
      json['tag_equipo'],
      json['estado'],
      json['marca'],
      json['modelo'],
      json['no_serie'],
      tipoSensor,
    );
  }

  String getTagEquipo() {
    return tagEquipo;
  }

  String getEstado() {
    return estado;
  }

  String getMarca() {
    return marca;
  }

  String getModelo() {
    return modelo;
  }

  String getNoSerie() {
    return noSerie;
  }

  String getTipoSensor() {
    return tipoSensor;
  }
}
