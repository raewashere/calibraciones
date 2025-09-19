class Corrida {
  late int idCorrida;
  late double caudalM3Hr;
  late double caudalBblHr;
  late double temperaturaC;
  late double presionKgCm2;
  late double presionPSI;
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
    this.presionKgCm2,
    this.presionPSI,
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
  double get getpresionKgCm2 => presionKgCm2;
  double get getpresionPSI => presionPSI;
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

  set setpresionKgCm2(double value) {
    presionKgCm2 = value;
  }

  set setpresionPSI(double value) {
    presionPSI = value;
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

  factory Corrida.fromJson(Map<String, dynamic> corridaJson) {
    return Corrida(
      corridaJson['id_corrida'],
      corridaJson['caudal_m3_hr'],
      corridaJson['caudal_bbl_hr'],
      corridaJson['temperatura_c'],
      corridaJson['presion_kg_cm2'],
      corridaJson['presion_psi'],
      corridaJson['meter_factor'],
      corridaJson['k_factor_pulse_m3'],
      corridaJson['k_factor_pulse_bbl'],
      corridaJson['repetibilidad'],
      corridaJson['frecuencia'],
    );
  }
}