class LecturaTemperatura {
  late int idLectura;
  late double patronCelsius,
      patronFahrenheit,
      ibcCelsius,
      ibcFahrenheit,
      errorCelsius,
      errorFahrenheit,
      incertidumbreCelsius,
      incertidumbreFahrenheit;
  late int idCalibracion;

  LecturaTemperatura(
    this.idLectura,
    this.patronCelsius,
    this.patronFahrenheit,
    this.ibcCelsius,
    this.ibcFahrenheit,
    this.errorCelsius,
    this.errorFahrenheit,
    this.incertidumbreCelsius,
    this.incertidumbreFahrenheit,
    this.idCalibracion,
  );

  int get getIdLectura=> idLectura;
  double get getPatronCelsius => patronCelsius;
  double get getPatronFahrenheit => patronFahrenheit;
  double get getIbcCelsius => ibcCelsius;
  double get getIbcFahrenheit => ibcFahrenheit;
  double get getErrorCelsius => errorCelsius;
  double get getErrorFahrenheit => errorFahrenheit;
  double get getIncertidumbreCelsius => incertidumbreCelsius;
  double get getIncertidumbreFahrenheit => incertidumbreFahrenheit;
  int get getIdCalibracion => idCalibracion;

  set setIdLectura(int value) {
    idLectura = value;
  }

  set setPatronCelsius(double value) {
    patronCelsius = value;
  }

  set setPatronFahrenheit(double value) {
    patronFahrenheit = value;
  }

  set setIbcCelsius(double value) {
    ibcCelsius = value;
  }

  set setIbcFahrenheit(double value) {
    ibcFahrenheit = value;
  }

  set setErrorCelsius(double value) {
    errorCelsius = value;
  }

  set setErrorFahrenheit(double value) {
    errorFahrenheit = value;
  }

  set setIncertidumbreCelsius(double value) {
    incertidumbreCelsius = value;
  }

  set setIncertidumbreFahrenheit(double value) {
    incertidumbreFahrenheit = value;
  }

  set setIdCalibracion(int value) {
    idCalibracion = value;
  }

  factory LecturaTemperatura.fromJson(Map<String, dynamic> corridaJson) {
    return LecturaTemperatura(
      corridaJson['id_lectura'],
      corridaJson['patron_c'],
      corridaJson['patron_f'],
      corridaJson['ibc_c'],
      corridaJson['ibc_f'],
      corridaJson['error_c'],
      corridaJson['error_f'],
      corridaJson['incertidumbre_c'],
      corridaJson['incertidumbre_f'],
      corridaJson['id_calibracion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      //'id_lectura': idCorrida,
      'patron_c': patronCelsius,
      'patron_f': patronFahrenheit,
      'ibc_c': ibcCelsius,
      'ibc_f': ibcFahrenheit,
      'error_c': errorCelsius,
      'error_f': errorFahrenheit,
      'incertidumbre_c': incertidumbreCelsius,
      'incertidumbre_f': incertidumbreFahrenheit,
      'id_calibracion': idCalibracion,
    };
  }
}
