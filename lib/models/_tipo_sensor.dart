class TipoSensor {
  late int idTipoSensor;
  late String nombreTipoSensor;

  TipoSensor(this.idTipoSensor, this.nombreTipoSensor);

  int get getIdTipoSensor => idTipoSensor;
  String get getNombreTipoSensor => nombreTipoSensor;

  set setIdTipoSensor(int value) {
    idTipoSensor = value;
  }

  set setNombreTipoSensor(String value) {
    nombreTipoSensor = value;
  }

  static fromJson(Map<String, dynamic> tipoSensorJson) {
    return TipoSensor(
      tipoSensorJson['id_tipo_sensor'],
      tipoSensorJson['descripcion'],
    );
  }
}