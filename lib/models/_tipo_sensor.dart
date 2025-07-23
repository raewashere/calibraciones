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
}