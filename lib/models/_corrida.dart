class Corrida {
  late int idCorrida;
  late double caudalM3Hr;
  late double caudalBblHr;
  late double temperaturaC;
  late double presionKgCm3;
  late double meterFactor;
  late double kFactorPulseM3;
  late double kFactoPulseBbl;
  late double repetibilidad;
  late double frecuenciaHz;

  Corrida(
    this.idCorrida,
    this.caudalM3Hr,
    this.caudalBblHr,
    this.temperaturaC,
    this.presionKgCm3,
    this.meterFactor,
    this.kFactorPulseM3,
    this.kFactoPulseBbl,
    this.repetibilidad,
    this.frecuenciaHz,
  );

  int get getIdCorrida => idCorrida;
  double get getCaudalM3Hr => caudalM3Hr;
  double get getCaudalBblHr => caudalBblHr;
  double get getTemperaturaC => temperaturaC;
  double get getPresionKgCm3 => presionKgCm3;
  double get getMeterFactor => meterFactor;
  double get getKFactorPulseM3 => kFactorPulseM3;
  double get getKFactoPulseBbl => kFactoPulseBbl;
  double get getRepetibilidad => repetibilidad;
  double get getFrecuenciaHz => frecuenciaHz;


  set setIdCorrida(int value) {
    idCorrida = value;
  }

  set setCaudalM3Hr(double value) {
    caudalM3Hr = value;
  }

  set setCaudalBblHr(double value) {
    caudalBblHr = value;
  }

  set setTemperaturaC(double value) {
    temperaturaC = value;
  }

  set setPresionKgCm3(double value) {
    presionKgCm3 = value;
  }

  set setMeterFactor(double value) {
    meterFactor = value;
  }

  set setKFactorPulseM3(double value) {
    kFactorPulseM3 = value;
  }

  set setKFactoPulseBbl(double value) {
    kFactoPulseBbl = value;
  }

  set setRepetibilidad(double value) {
    repetibilidad = value;
  }

  set setFrecuenciaHz(double value) {
    frecuenciaHz = value;
  }
}