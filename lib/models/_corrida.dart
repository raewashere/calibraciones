class Corrida {
  late int idCorrida;
  late double caudalM3Hr;
  late double caudalBblHr;
  late double temperaturaC;
  late double presionKgCm2;
  late double presionPSI;
  late double meterFactor;
  late double kFactorPulseM3;
  late double kFactorPulseBbl;
  late double repetibilidad;
  late double frecuenciaHz;
  late int idCalibracion;

  Corrida(
    this.idCorrida,
    this.caudalM3Hr,
    this.caudalBblHr,
    this.temperaturaC,
    this.presionKgCm2,
    this.presionPSI,
    this.meterFactor,
    this.kFactorPulseM3,
    this.kFactorPulseBbl,
    this.repetibilidad,
    this.frecuenciaHz,
    this.idCalibracion,
  );

  int get getIdCorrida => idCorrida;
  double get getCaudalM3Hr => caudalM3Hr;
  double get getCaudalBblHr => caudalBblHr;
  double get getTemperaturaC => temperaturaC;
  double get getpresionKgCm2 => presionKgCm2;
  double get getpresionPSI => presionPSI;
  double get getMeterFactor => meterFactor;
  double get getKFactorPulseM3 => kFactorPulseM3;
  double get getkFactorPulseBbl => kFactorPulseBbl;
  double get getRepetibilidad => repetibilidad;
  double get getFrecuenciaHz => frecuenciaHz;
  int get getIdCalibracion => idCalibracion;

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

  set setkFactorPulseBbl(double value) {
    kFactorPulseBbl = value;
  }

  set setRepetibilidad(double value) {
    repetibilidad = value;
  }

  set setFrecuenciaHz(double value) {
    frecuenciaHz = value;
  }

  set setIdCalibracion(int value) {
    idCalibracion = value;
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
      corridaJson['idCalibracion']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      //'id_corrida': idCorrida,
      'caudal_m3_hr': caudalM3Hr,
      'caudal_bbl_hr': caudalBblHr,
      'temperatura': temperaturaC,
      'presion': presionKgCm2,
      //'presion_psi': presionPSI,
      'meter_factor': meterFactor,
      'k_factor_pulsos_m3': kFactorPulseM3,
      'k_factor_pulsos_bbl': kFactorPulseBbl,
      'repetibilidad': repetibilidad,
      'frecuencia': frecuenciaHz,
      'id_calibracion': idCalibracion,
    };
  }
}
