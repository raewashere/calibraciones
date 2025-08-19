class DtoInstalacion {
  late int idInstalacion;
  late String nombreInstalacion;
  late int idEntidad;
  late int idGerencia;
  late int idSubdireccion;

  DtoInstalacion(this.idInstalacion, this.nombreInstalacion);

  DtoInstalacion.detalle(this.idInstalacion, this.nombreInstalacion, this.idEntidad, this.idGerencia, this.idSubdireccion);

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

  factory DtoInstalacion.fromJsonDetalle(Map<String, dynamic> json) {
    return DtoInstalacion.detalle(
      json['id_instalacion'],
      json['nombre_instalacion'],
      json['id_entidad'],
      json['id_gerencia'],
      json['id_subdireccion'],
    );
  }

  int getIdInstalacion() {
    return idInstalacion;
  }

  String getNombreInstalacion() {
    return nombreInstalacion;
  }

  int getIdEntidad() {
    return idEntidad;
  }

  int getIdGerencia() {
    return idGerencia;
  }

  int getIdSubdireccion() {
    return idSubdireccion;
  }
}
