class DtoInstalacion {
  late int idInstalacion;
  late String nombreInstalacion;

  DtoInstalacion(this.idInstalacion, this.nombreInstalacion);

  @override
  String toString() {
    return 'DtoInstalacion{id: $idInstalacion, nombre: $nombreInstalacion}';
  }

  factory DtoInstalacion.fromJson(Map<String, dynamic> json) {
    return DtoInstalacion(
      json['id_instalacion'],
      json['nombre_instalacion'],
    );
  }

  int getIdInstalacion() {
    return idInstalacion;
  }

  String getNombreInstalacion() {
    return nombreInstalacion;
  }
}
