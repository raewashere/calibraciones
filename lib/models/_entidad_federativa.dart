class EntidadFederativa {
  late int idEntidadFederativa;
  late String nombreEntidadFederativa;

  EntidadFederativa({
    required this.idEntidadFederativa,
    required this.nombreEntidadFederativa,
  });

  int get getIdEntidadFederativa => idEntidadFederativa;
  String get getNombreEntidadFederativa => nombreEntidadFederativa;

  set setIdEntidadFederativa(int value) {
    idEntidadFederativa = value;
  }

  set setNombreEntidadFederativa(String value) {
    nombreEntidadFederativa = value;
  }

  static fromJson(Map<String, dynamic> entidadJson) {
    return EntidadFederativa(
      idEntidadFederativa: entidadJson['id_entidad'],
      nombreEntidadFederativa: entidadJson['nombre_entidad'],
    );
  }
}