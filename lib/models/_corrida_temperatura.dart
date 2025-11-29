class CorridaTemperatura {
  late int idCorrida;
  late double patronCelsius,
      patronFahrenheit,
      ibcCelsius,
      ibcFahrenheit,
      errorCelsius,
      errorFahrenheit,
      incertidumbreCelsius,
      incertidumbreFahrenheit;
  late int idCalibracion;

  CorridaTemperatura(
    this.idCorrida,
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

  int get getIdCorrida => idCorrida;
  double get getPatronCelsius => patronCelsius;
  double get getPatronFahrenheit => patronFahrenheit;
  double get getIbcCelsius => ibcCelsius;
  double get getIbcFahrenheit => ibcFahrenheit;
  double get getErrorCelsius => errorCelsius;
  double get getErrorFahrenheit => errorFahrenheit;
  double get getIncertidumbreCelsius => incertidumbreCelsius;
  double get getIncertidumbreFahrenheit => incertidumbreFahrenheit;
  int get getIdCalibracion => idCalibracion;

  set setIdCorrida(int value) {
    idCorrida = value;
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

  factory CorridaTemperatura.fromJson(Map<String, dynamic> corridaJson) {
    return CorridaTemperatura(
      corridaJson['id_corrida'],
      corridaJson['patron_celsius'],
      corridaJson['patron_fahrenheit'],
      corridaJson['ibc_celsius'],
      corridaJson['ibc_fahrenheit'],
      corridaJson['error_celsius'],
      corridaJson['error_fahrenheit'],
      corridaJson['incertidumbre_celsius'],
      corridaJson['incertidumbre_fahrenheit'],
      corridaJson['id_calibracion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      //'id_corrida': idCorrida,
      'patron_celsius': patronCelsius,
      'patron_fahrenheit': patronFahrenheit,
      'ibc_celsius': ibcCelsius,
      'ibc_fahrenheit': ibcFahrenheit,
      'error_celsius': errorCelsius,
      'error_fahrenheit': errorFahrenheit,
      'incertidumbre_celsius': incertidumbreCelsius,
      'incertidumbre_fahrenheit': incertidumbreFahrenheit,
      'id_calibracion': idCalibracion,
    };
  }
}
