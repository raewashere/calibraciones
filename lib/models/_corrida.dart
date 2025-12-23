class Corrida {
  late int idCorrida;
  late double caudalM3Hr;
  late double caudalBblHr;
  late double temperaturaC;
  late double temperaturaF;
  late double presionKgCm2;
  late double presionPSI;
  late double presionKPa;
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
    this.temperaturaF,
    this.presionKgCm2,
    this.presionPSI,
    this.presionKPa,
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
  double get getTemperaturaF => temperaturaF;
  double get getpresionKgCm2 => presionKgCm2;
  double get getpresionPSI => presionPSI;
  double get getpresionKPa => presionKPa;
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

  set setTemperaturaF(double value) {
    temperaturaF = value;
  }

  set setpresionKgCm2(double value) {
    presionKgCm2 = value;
  }

  set setpresionPSI(double value) {
    presionPSI = value;
  }

  set setpresionKPa(double value) {
    presionKPa = value;
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
      ((corridaJson['id_corrida'] as num).toInt()),
      ((corridaJson['caudal_m3_hr'] as num).toDouble()),
      ((corridaJson['caudal_bbl_hr'] as num).toDouble()),
      ((corridaJson['temperatura_c'] as num).toDouble()),
      ((corridaJson['temperatura_f'] as num).toDouble()),
      ((corridaJson['presion_kg_cm2'] as num).toDouble()),
      ((corridaJson['presion_psi'] as num).toDouble()),
      ((corridaJson['presion_kpa'] as num).toDouble()),
      ((corridaJson['meter_factor'] as num).toDouble()),
      ((corridaJson['k_factor_pulsos_m3'] as num).toDouble()),
      ((corridaJson['k_factor_pulsos_bbl'] as num).toDouble()),
      ((corridaJson['repetibilidad'] as num).toDouble()),
      ((corridaJson['frecuencia'] as num).toDouble()),
      ((corridaJson['id_calibracion'] as num).toInt()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      //'id_corrida': idCorrida,
      'caudal_m3_hr': caudalM3Hr,
      'caudal_bbl_hr': caudalBblHr,
      'temperatura_c': temperaturaC,
      'temperatura_f': temperaturaF,
      'presion_kg_cm2': presionKgCm2,
      'presion_psi': presionPSI,
      'presion_kpa': presionKPa,
      'meter_factor': meterFactor,
      'k_factor_pulsos_m3': kFactorPulseM3,
      'k_factor_pulsos_bbl': kFactorPulseBbl,
      'repetibilidad': repetibilidad,
      'frecuencia': frecuenciaHz,
      'id_calibracion': idCalibracion,
    };
  }
}
