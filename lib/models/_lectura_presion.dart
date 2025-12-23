class LecturaPresion {
  late int idLectura;
  late double patronKgCm2,
      patronPSI,
      patronkPa,
      ibcKgCm2,
      ibcPSI,
      ibckPa,
      errorKgCm2,
      errorPSI,
      errorkPa,
      incertidumbreKgCm2,
      incertidumbrePSI,
      incertidumbrekPa;
  late int idCalibracion;

  LecturaPresion(
    this.idLectura,
    this.patronKgCm2,
    this.patronPSI,
    this.patronkPa,
    this.ibcKgCm2,
    this.ibcPSI,
    this.ibckPa,
    this.errorKgCm2,
    this.errorPSI,
    this.errorkPa,
    this.incertidumbreKgCm2,
    this.incertidumbrePSI,
    this.incertidumbrekPa,
    this.idCalibracion,
  );

  int get getIdLectura => idLectura;
  double get getPatrongCm2 => patronKgCm2;
  double get getPatronPSI => patronPSI;
  double get getPatronkPa => patronkPa;
  double get getIbcKgCm2 => ibcKgCm2;
  double get getIbcPSI => ibcPSI;
  double get getIbckPa => ibckPa;
  double get getErrorKgCm2 => errorKgCm2;
  double get getErrorPSI => errorPSI;
  double get getErrorkPa => errorkPa;
  double get getIncertidumbreKgCm2 => incertidumbreKgCm2;
  double get getIncertidumbrePSI => incertidumbrePSI;
  double get getIncertidumbrekPa => incertidumbrekPa;
  int get getIdCalibracion => idCalibracion;

  set setIdLectura(int value) {
    idLectura = value;
  }

  set setPatronKgCm2(double value) {
    patronKgCm2 = value;
  }

  set setPatronPSI(double value) {
    patronPSI = value;
  }

  set setPatronkPa(double value) {
    patronkPa = value;
  }

  set setIbcKgCm2(double value) {
    ibcKgCm2 = value;
  }

  set setIbcPSI(double value) {
    ibcPSI = value;
  }

  set setIbckPa(double value) {
    ibckPa = value;
  }

  set setErrorKgCm2(double value) {
    errorKgCm2 = value;
  }

  set setErrorPSI(double value) {
    errorPSI = value;
  }

  set setErrorkPa(double value) {
    errorkPa = value;
  }

  set setIncertidumbreKgCm2(double value) {
    incertidumbreKgCm2 = value;
  }

  set setIncertidumbrePSI(double value) {
    incertidumbrePSI = value;
  }

  set setIncertidumbrekPa(double value) {
    incertidumbrekPa = value;
  }

  set setIdCalibracion(int value) {
    idCalibracion = value;
  }

  factory LecturaPresion.fromJson(Map<String, dynamic> corridaJson) {
    return LecturaPresion(
      ((corridaJson['id_lectura'] as num).toInt()),
      ((corridaJson['patron_kgcm2'] as num).toDouble()),
      ((corridaJson['patron_psi'] as num).toDouble()),
      ((corridaJson['patron_kpa'] as num).toDouble()),
      ((corridaJson['ibc_kgcm2'] as num).toDouble()),
      ((corridaJson['ibc_psi'] as num).toDouble()),
      ((corridaJson['ibc_kpa'] as num).toDouble()),
      ((corridaJson['error_kgcm2'] as num).toDouble()),
      ((corridaJson['error_psi'] as num).toDouble()),
      ((corridaJson['error_kpa'] as num).toDouble()),
      ((corridaJson['incertidumbre_kgcm2'] as num).toDouble()),
      ((corridaJson['incertidumbre_psi'] as num).toDouble()),
      ((corridaJson['incertidumbre_kpa'] as num).toDouble()),
      ((corridaJson['id_calibracion'] as num).toInt()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      //'id_lectura': idCorrida,
      'patron_kgcm2': patronKgCm2,
      'patron_psi': patronPSI,
      'patron_kpa': patronkPa,
      'ibc_kgcm2': ibcKgCm2,
      'ibc_psi': ibcPSI,
      'ibc_kpa': ibckPa,
      'error_kgcm2': errorKgCm2,
      'error_psi': errorPSI,
      'error_kpa': errorkPa,
      'incertidumbre_kgcm2': incertidumbreKgCm2,
      'incertidumbre_psi': incertidumbrePSI,
      'incertidumbre_kpa': incertidumbrekPa,
      'id_calibracion': idCalibracion,
    };
  }
}
