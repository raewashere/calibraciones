class LecturaDensidad {
  late int idLectura;
  late double patronOperacion,
      patronReferencia,
      ibcOperacion,
      ibcReferencia,
      errorReferencia,
      incertidumbreReferencia,
      patronCorregidoOperacion,
      patronCorregidoReferencia,
      ibcCorregidoOperacion,
      ibcCorregidoReferencia,
      errorCorregidoReferencia,
      incertidumbreCorregidoReferencia,
      factorCorreccion;
  late int idCalibracion;

  LecturaDensidad(
    this.idLectura,
    this.patronOperacion,
    this.patronReferencia,
    this.ibcOperacion,
    this.ibcReferencia,
    this.errorReferencia,
    this.incertidumbreReferencia,
    this.patronCorregidoOperacion,
    this.patronCorregidoReferencia,
    this.ibcCorregidoOperacion,
    this.ibcCorregidoReferencia,
    this.errorCorregidoReferencia,
    this.incertidumbreCorregidoReferencia,
    this.factorCorreccion,
    this.idCalibracion,
  );

  int get getIdLectura => idLectura;
  double get getPatronOperacion => patronOperacion;
  double get getPatronReferencia => patronReferencia;
  double get getIbcOperacion => ibcOperacion;
  double get getIbcReferencia => ibcReferencia;
  double get getErrorReferencia => errorReferencia;
  double get getIncertidumbreReferencia => incertidumbreReferencia;
  double get getPatronCorregidoOperacion => patronCorregidoOperacion;
  double get getPatronCorregidoReferencia => patronCorregidoReferencia;
  double get getIbcCorregidoOperacion => ibcCorregidoOperacion;
  double get getIbcCorregidoReferencia => ibcCorregidoReferencia;
  double get getErrorCorregidoReferencia => errorCorregidoReferencia;
  double get getIncertidumbreCorregidoReferencia =>
      incertidumbreCorregidoReferencia;
  double get getFactorCorreccion => factorCorreccion;
  int get getIdCalibracion => idCalibracion;

  set setIdLectura(int value) {
    idLectura = value;
  }

  set setPatronOperacion(double value) {
    patronOperacion = value;
  }

  set setPatronReferencia(double value) {
    patronReferencia = value;
  }

  set setIbcOperacion(double value) {
    ibcOperacion = value;
  }

  set setIbcReferencia(double value) {
    ibcReferencia = value;
  }

  set setErrorReferencia(double value) {
    errorReferencia = value;
  }

  set setIncertidumbreReferencia(double value) {
    incertidumbreReferencia = value;
  }

  set setPatronCorregidoOperacion(double value) {
    patronCorregidoOperacion = value;
  }

  set setPatronCorregidoReferencia(double value) {
    patronCorregidoReferencia = value;
  }

  set setIbcCorregidoOperacion(double value) {
    ibcCorregidoOperacion = value;
  }

  set setIbcCorregidoReferencia(double value) {
    ibcCorregidoReferencia = value;
  }

  set setErrorCorregidoReferencia(double value) {
    errorCorregidoReferencia = value;
  }

  set setIncertidumbreCorregidoReferencia(double value) {
    incertidumbreCorregidoReferencia = value;
  }

  set setFactorCorreccion(double value) {
    factorCorreccion = value;
  }

  set setIdCalibracion(int value) {
    idCalibracion = value;
  }

  factory LecturaDensidad.fromJson(Map<String, dynamic> json) {
    return LecturaDensidad(
      ((json['id_lectura'] as num).toInt()),
      ((json['patron_operacion'] as num).toDouble()),
      ((json['patron_referencia'] as num).toDouble()),
      ((json['ibc_operacion'] as num).toDouble()),
      ((json['ibc_referencia'] as num).toDouble()),
      ((json['error_referencia'] as num).toDouble()),
      ((json['incertidumbre_referencia'] as num).toDouble()),
      ((json['patron_corregido_operacion'] as num).toDouble()),
      ((json['patron_corregido_referencia'] as num).toDouble()),
      ((json['ibc_corregido_operacion'] as num).toDouble()),
      ((json['ibc_corregido_referencia'] as num).toDouble()),
      ((json['error_corregido_referencia'] as num).toDouble()),
      ((json['incertidumbre_corregido_referencia'] as num).toDouble()),
      ((json['factor_correccion'] as num).toDouble()),
      ((json['id_calibracion'] as num).toInt()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      //'id_lectura': idCorrida,
      'patron_operacion': patronOperacion,
      'patron_referencia': patronReferencia,
      'ibc_operacion': ibcOperacion,
      'ibc_referencia': ibcReferencia,
      'error_referencia': errorReferencia,
      'incertidumbre_referencia': incertidumbreReferencia,
      'patron_corregido_operacion': patronCorregidoOperacion,
      'patron_corregido_referencia': patronCorregidoReferencia,
      'ibc_corregido_operacion': ibcCorregidoOperacion,
      'ibc_corregido_referencia': ibcCorregidoReferencia,
      'error_corregido_referencia': errorCorregidoReferencia,
      'incertidumbre_corregido_referencia': incertidumbreCorregidoReferencia,
      'factor_correccion': factorCorreccion,
      'id_calibracion': idCalibracion,
    };
  }
}
