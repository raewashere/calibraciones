import 'dart:io' show File; // Esto solo se usa en móviles/escritorio
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:calibraciones/common/barrel/models.dart';
import 'package:calibraciones/common/components/components.dart';
import 'package:calibraciones/common/barrel/services.dart';
import 'package:calibraciones/services/data_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:calibraciones/common/utils/conversiones.dart';

class VistaRegistroCalibracion extends StatefulWidget {
  const VistaRegistroCalibracion({super.key});

  @override
  State<StatefulWidget> createState() => VistaRegistroCalibracionState();
}

class VistaRegistroCalibracionState extends State<VistaRegistroCalibracion> {
  final CajaFormulario cajaFormulario = CajaFormulario();
  final TablaCalibracion tablaCalibracion = TablaCalibracion();
  final Conversiones convertidor = Conversiones();
  final Mensajes mensajes = Mensajes();
  final _keySeccionEquipo = GlobalKey<FormState>();
  final _keySeccionDatosCalibracion = GlobalKey<FormState>();
  final _keySeccionCorridas = GlobalKey<FormState>();
  final _keySeccionExtras = GlobalKey<FormState>();

  DateFormat formato = DateFormat("dd/MM/yyyy");

  //Datos laboratorio
  final TextEditingController _laboratorioController = TextEditingController();
  final TextEditingController _productoController = TextEditingController();
  final TextEditingController _certificadoController = TextEditingController();
  final TextEditingController _archivoController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();
  final TextEditingController _fechaProximaController = TextEditingController();

  DateTime selectedFecha = DateTime.now();
  DateTime selectedFechaProxima = DateTime.now();

  //Datos corridas
  final TextEditingController _caudalM3Controller = TextEditingController();
  final TextEditingController _caudalBblController = TextEditingController();
  final TextEditingController _temperaturaCentigradosController =
      TextEditingController();
  final TextEditingController _temperaturaFahrenheitController =
      TextEditingController();
  final TextEditingController _presionController = TextEditingController();
  final TextEditingController _presionPSIController = TextEditingController();
  final TextEditingController _presionKPaController = TextEditingController();
  final TextEditingController _meterFactorController = TextEditingController();
  final TextEditingController _kFactorPulsosM3Controller =
      TextEditingController();
  final TextEditingController _kFactorPulsosBblController =
      TextEditingController();
  final TextEditingController _frecuenciaController = TextEditingController();
  final TextEditingController _repetibilidadController =
      TextEditingController();
  final TextEditingController _linealidadController = TextEditingController();
  final TextEditingController _reproducibilidadController =
      TextEditingController();
  final TextEditingController _observacionesController =
      TextEditingController();

  final List _listaCorridas = [];
  late Corrida _corridaActual;
  late final List<Corrida> _corridasRegistradas = [];

  late CalibracionEquipo _calibracionEquipo;

  CalibracionService calibracionService = CalibracionServiceImpl();

  File? fileCertificado;
  late Uint8List? fileBytes;

  bool editandoCorrida = false;
  int indiceCorridaEditando = -1;

  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), // fecha mínima
      lastDate: DateTime(2100), // fecha máxima
      locale: Locale("es", "ES"), // idioma español
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(
                context,
              ).colorScheme.primary, // Color del encabezado y selección
              onPrimary: Theme.of(
                context,
              ).colorScheme.onPrimary, // Texto en el encabezado
              onSurface: Theme.of(
                context,
              ).colorScheme.onSurface, // Texto de días
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _fechaController.text = formato.format(picked);
        selectedFecha = picked;
        selectedFechaProxima = picked.add(
          Duration(
            days: equipoSeleccionado != null
                ? equipoSeleccionado!.intervaloCalibracion
                : 0,
          ),
        );
        _fechaProximaController.text = formato.format(selectedFechaProxima);
      });
    }
  }

  final FocusNode _focusNodeCaudal = FocusNode();

  DireccionService direccionService = DireccionServiceImpl();
  LaboratorioCalibracionService laboratorioService =
      LaboratorioCalibracionServiceImpl();

  Subdireccion? selectedSubdireccion;

  late Future<List<Direccion>> _futureDirecciones;
  Direccion? selectedDireccion;
  Direccion? direccionSeleccionada;

  List<Subdireccion> subdirecciones = [];
  Subdireccion? subdireccionSeleccionada;

  List<Gerencia> gerencias = [];
  Gerencia? gerenciaSeleccionada;

  List<Instalacion> instalaciones = [];
  Instalacion? instalacionSeleccionada;

  List<PatinMedicion> patinesMedicion = [];
  PatinMedicion? patinMedicionSeleccionado;

  List<TrenMedicion> trenesMedicion = [];
  TrenMedicion? trenMedicionSeleccionado;

  List<Equipo> equiposTren = [];
  Equipo? equipoSeleccionado;

  late Future<List<LaboratorioCalibracion>> _futureLaboratorios;
  LaboratorioCalibracion? laboratorioSeleccionado;

  bool habilitaGerencia = false;

  bool _editingM3 = false;
  bool _editingBbl = false;
  bool _editingCelsius = false;
  bool _editingFahrenheit = false;
  bool _editingPulsosM3 = false;
  bool _editingPulsosBbl = false;
  bool _editingPresion = false;
  bool _editingPresionPSI = false;
  bool _editingPresionKPa = false;

  static const double factor = 6.28981; // m³/h a bbl/h
  static const double factorPulsos = 0.158987; // bbl → m³

  static const double factorPresion = 14.22334; // PSI → kg/cm²

  void _onCaudalM3Changed(String value) {
    if (_editingBbl) return; // evita recursividad
    setState(() => _editingM3 = true);
    if (value.isNotEmpty) {
      double m3 = double.tryParse(value) ?? 0;
      _caudalBblController.text = convertidor.formatoMiles(
        Conversiones.caudalM3ToBbl(m3),
        2,
      );
    } else {
      _caudalBblController.clear();
    }
    setState(() => _editingM3 = false);
  }

  void _onCaudalBblChanged(String value) {
    if (_editingM3) return; // evita recursividad
    setState(() => _editingBbl = true);
    if (value.isNotEmpty) {
      double bbl = double.tryParse(value) ?? 0;
      _caudalM3Controller.text = convertidor.formatoMiles(
        Conversiones.caudalBblToM3(bbl),
        2,
      );
    } else {
      _caudalM3Controller.clear();
    }
    setState(() => _editingBbl = false);
  }

  void _onPulsosM3Changed(String value) {
    if (_editingPulsosBbl) return; // evita recursividad
    setState(() => _editingPulsosM3 = true);
    if (value.isNotEmpty) {
      double pm3 = double.tryParse(value) ?? 0;
      _kFactorPulsosBblController.text = convertidor.formatoMiles(
        Conversiones.m3ToBbl(pm3),
        3,
      );
    } else {
      _kFactorPulsosBblController.clear();
    }
    setState(() => _editingPulsosM3 = false);
  }

  void _onPulsosBblChanged(String value) {
    if (_editingPulsosM3) return; // evita recursividad
    setState(() => _editingPulsosBbl = true);
    if (value.isNotEmpty) {
      double pbbl = double.tryParse(value) ?? 0;
      _kFactorPulsosM3Controller.text = convertidor.formatoMiles(
        Conversiones.bblToM3(pbbl),
        3,
      );
    } else {
      _kFactorPulsosM3Controller.clear();
    }
    setState(() => _editingPulsosBbl = false);
  }

  void _onPresionChanged(String value) {
    if (_editingPresionPSI && _editingPresionKPa) return; // evita recursividad
    setState(() => _editingPresion = true);
    if (value.isNotEmpty) {
      double kgcm2 = double.tryParse(value) ?? 0;
      _presionPSIController.text = convertidor.formatoMiles(
        Conversiones.kgCm2ToPsi(kgcm2),
        2,
      );
      _presionKPaController.text = convertidor.formatoMiles(
        Conversiones.kgCm2ToKPa(kgcm2),
        2,
      );
    } else {
      _presionPSIController.clear();
      _presionKPaController.clear();
    }
    setState(() => _editingPresion = false);
  }

  void _onPresionPSIChanged(String value) {
    if (_editingPresion && _editingPresionKPa) return; // evita recursividad
    setState(() => _editingPresionPSI = true);
    if (value.isNotEmpty) {
      double psi = double.tryParse(value) ?? 0;
      _presionController.text = convertidor.formatoMiles(
        Conversiones.psiToKgCm2(psi),
        2,
      );
      _presionKPaController.text = convertidor.formatoMiles(
        Conversiones.psiToKPa(psi),
        2,
      );
    } else {
      _presionController.clear();
      _presionKPaController.clear();
    }
    setState(() => _editingPresionPSI = false);
  }

  void _onPresionKPaChanged(String value) {
    if (_editingPresionPSI && _editingPresion) return; // evita recursividad
    setState(() => _editingPresionKPa = true);
    if (value.isNotEmpty) {
      double kPa = double.tryParse(value) ?? 0;
      _presionController.text = convertidor.formatoMiles(
        Conversiones.kPaToKgCm2(kPa),
        2,
      );
      _presionPSIController.text = convertidor.formatoMiles(
        Conversiones.kPaToPsi(kPa),
        2,
      );
    } else {
      _presionController.clear();
      _presionPSIController.clear();
    }
    setState(() => _editingPresion = false);
  }

  void _onCelsiusChanged(String value) {
    if (_editingFahrenheit) return; // evita recursividad
    setState(() => _editingCelsius = true);
    if (value.isNotEmpty) {
      double celsius = double.tryParse(value) ?? 0;
      _temperaturaFahrenheitController.text = convertidor.formatoMiles(
        Conversiones.celsiusToFahrenheit(celsius),
        2,
      );
    } else {
      _temperaturaFahrenheitController.clear();
    }
    setState(() => _editingCelsius = false);
  }

  void _onFahrenheitChanged(String value) {
    if (_editingCelsius) return; // evita recursividad
    setState(() => _editingFahrenheit = true);
    if (value.isNotEmpty) {
      double fahrenheit = double.tryParse(value) ?? 0;
      _temperaturaCentigradosController.text = convertidor.formatoMiles(
        Conversiones.fahrenheitToCelsius(fahrenheit),
        2,
      );
    } else {
      _temperaturaCentigradosController.clear();
    }
    setState(() => _editingFahrenheit = false);
  }

  bool validarEmail(String email) {
    final RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  @override
  void initState() {
    super.initState();
    _futureDirecciones = DataService().updateAndCacheData();
    _futureLaboratorios = laboratorioService.obtenerAllLaboratorios();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.onPrimary,
      body: FutureBuilder<List<Direccion>>(
        future: _futureDirecciones,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: \\${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay direcciones disponibles'));
          } else {
            final lista = snapshot.data!;
            direccionSeleccionada ??= lista[0];
            return SingleChildScrollView(
              child: Container(
                width: double.maxFinite,
                decoration: BoxDecoration(color: theme.colorScheme.onPrimary),
                child: Column(
                  children: <Widget>[
                    Form(
                      key: _keySeccionEquipo,
                      child: Container(
                        decoration: cajaFormulario.boxDecoration(context),
                        child: Padding(
                          padding: EdgeInsets.all(30),
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 15),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Center(
                                  child: Row(
                                    children: [
                                      Text(
                                        "Equipo",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.tertiary,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      _iconoAyudaSeccion(
                                        context,
                                        'Seleccione la ubicación del equipo a calibrar, inicie con la dirección, subdirección, gerencia (si aplica), instalación, patín de medición, tren de medición y finalmente el equipo.',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    _buildDropdownButtonDireccion(
                                      context,
                                      hintText: "Dirección",
                                      items: _futureDirecciones,
                                      value: direccionSeleccionada,
                                      onChanged: (value) {
                                        setState(() {
                                          subdireccionSeleccionada = null;
                                          gerenciaSeleccionada = null;
                                          instalacionSeleccionada = null;
                                          patinMedicionSeleccionado = null;
                                          trenMedicionSeleccionado = null;
                                          equipoSeleccionado = null;
                                          subdirecciones = [];
                                          gerencias = [];
                                          instalaciones = [];
                                          patinesMedicion = [];
                                          trenesMedicion = [];
                                          equiposTren = [];
                                          direccionSeleccionada = value;
                                          subdirecciones =
                                              value!.subdirecciones;
                                        });
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    _buildDropdownButtonSubdireccion(
                                      context,
                                      hintText: "Subdirección",
                                      items: subdirecciones,
                                      value: subdireccionSeleccionada,
                                      onChanged: (value) {
                                        setState(() {
                                          gerenciaSeleccionada = null;
                                          instalacionSeleccionada = null;
                                          patinMedicionSeleccionado = null;
                                          trenMedicionSeleccionado = null;
                                          equipoSeleccionado = null;
                                          gerencias = [];
                                          instalaciones = [];
                                          patinesMedicion = [];
                                          trenesMedicion = [];
                                          equiposTren = [];
                                          subdireccionSeleccionada = value;
                                          if (value!.gerencias.isEmpty) {
                                            instalaciones = value.instalaciones;
                                            habilitaGerencia = false;
                                          } else {
                                            gerencias = value.gerencias;
                                            habilitaGerencia = true;
                                          }
                                        });
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    habilitaGerencia
                                        ? _buildDropdownButtonGerencia(
                                            context,
                                            hintText: "Gerencia",
                                            items: gerencias,
                                            value: gerenciaSeleccionada,
                                            onChanged: (value) {
                                              setState(() {
                                                instalacionSeleccionada = null;
                                                patinMedicionSeleccionado =
                                                    null;
                                                trenMedicionSeleccionado = null;
                                                equipoSeleccionado = null;
                                                instalaciones = [];
                                                patinesMedicion = [];
                                                trenesMedicion = [];
                                                equiposTren = [];
                                                gerenciaSeleccionada = value;
                                                instalaciones =
                                                    value!.instalaciones;
                                              });
                                            },
                                          )
                                        : SizedBox.shrink(),
                                    SizedBox(height: 10),
                                    _buildDropdownButtonInstalaciones(
                                      context,
                                      hintText: "Instalación",
                                      items: instalaciones,
                                      value: instalacionSeleccionada,
                                      onChanged: (value) {
                                        setState(() {
                                          patinMedicionSeleccionado = null;
                                          trenMedicionSeleccionado = null;
                                          equipoSeleccionado = null;
                                          patinesMedicion = [];
                                          trenesMedicion = [];
                                          equiposTren = [];
                                          instalacionSeleccionada = value;
                                          patinesMedicion =
                                              value!.getPatinesMedicion;
                                        });
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    _buildDropdownButtonPatines(
                                      context,
                                      hintText: "Patín de Medición",
                                      items: patinesMedicion,
                                      value: patinMedicionSeleccionado,
                                      onChanged: (value) {
                                        setState(() {
                                          trenMedicionSeleccionado = null;
                                          equipoSeleccionado = null;
                                          trenesMedicion = [];
                                          equiposTren = [];
                                          patinMedicionSeleccionado = value;
                                          trenesMedicion =
                                              value!.getTrenMedicion;
                                        });
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    _buildDropdownButtonTrenes(
                                      context,
                                      hintText: "Tren de Medición",
                                      items: trenesMedicion,
                                      value: trenMedicionSeleccionado,
                                      onChanged: (value) {
                                        setState(() {
                                          equipoSeleccionado = null;
                                          equiposTren = [];
                                          trenMedicionSeleccionado = value;
                                          equiposTren = value!.getEquiposTren;
                                        });
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    _buildDropdownButtonEquipos(
                                      context,
                                      hintText: "Equipo",
                                      items: equiposTren,
                                      value: equipoSeleccionado,
                                      onChanged: (value) {
                                        setState(() {
                                          equipoSeleccionado = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Form(
                      key: _keySeccionDatosCalibracion,
                      child: Container(
                        decoration: cajaFormulario.boxDecoration(context),
                        child: Padding(
                          padding: EdgeInsets.all(30),
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 15),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Center(
                                  child: Row(
                                    children: [
                                      Text(
                                        "Datos calibración",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.tertiary,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      _iconoAyudaSeccion(
                                        context,
                                        'Elige el laboratorio que realizó la calibración, ingrese el producto calibrado, el número y archivo del certificado, así como la fecha de calibración y la fecha de la próxima calibración.',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    _buildDropdownButtonLaboratorio(
                                      context,
                                      hintText: "Laboratorio de calibración",
                                      items: _futureLaboratorios,
                                      value: laboratorioSeleccionado,
                                      onChanged: (value) {
                                        setState(() {
                                          laboratorioSeleccionado = value;
                                        });
                                      },
                                    ),
                                    _buildTextFormField(
                                      context,
                                      hintText: "Producto",
                                      validatorText:
                                          'Favor de escribir el producto',
                                      controllerText: _productoController,
                                      decimales: 0,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildTextFormField(
                                            context,
                                            hintText: "No. Certificado",
                                            validatorText:
                                                'Favor de escribir el número de certificado',
                                            controllerText:
                                                _certificadoController,
                                            decimales: 0,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ), // separación entre campos
                                        Expanded(
                                          child: _buildFileFormField(
                                            context,
                                            hintText: "Archivo certificado",
                                            validatorText:
                                                'Favor de seleccionar el archivo del certificado',
                                            controllerText: _archivoController,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildDateFormField(
                                            context,
                                            hintText: "Fecha calibración",
                                            validatorText:
                                                'Favor de escribir la fecha',
                                            controllerText: _fechaController,
                                            tipoFecha: 1,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ), // separación entre campos
                                        Expanded(
                                          child: _buildDateFormField(
                                            context,
                                            hintText:
                                                "Fecha de próxima calibración recomendada",
                                            validatorText:
                                                'Favor de escribir la fecha',
                                            controllerText:
                                                _fechaProximaController,
                                            tipoFecha: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Form(
                      key: _keySeccionCorridas,
                      child: Container(
                        decoration: cajaFormulario.boxDecoration(context),
                        child: Padding(
                          padding: EdgeInsets.all(30),
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 15),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Center(
                                  child: Row(
                                    children: [
                                      Text(
                                        "Corridas",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.tertiary,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      _iconoAyudaSeccion(
                                        context,
                                        'Ingrese los datos de la corrida de calibración y agreguela a la tabla, las conversiones se hacen en automático, también elimine las corridas que no sean necesarias.',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildTextFormField(
                                            context,
                                            hintText: "Caudal (m³/hr)",
                                            validatorText:
                                                'Favor de escribir el caudal',
                                            controllerText: _caudalM3Controller,
                                            focusNode: _focusNodeCaudal,
                                            onChanged: _onCaudalM3Changed,
                                            decimales: 2,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ), // separación entre campos
                                        Expanded(
                                          child: _buildTextFormField(
                                            context,
                                            hintText: "Caudal (bbl/hr)",
                                            validatorText:
                                                'Favor de escribir el caudal',
                                            controllerText:
                                                _caudalBblController,
                                            onChanged: _onCaudalBblChanged,
                                            decimales: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildTextFormField(
                                            context,
                                            hintText: "Temperatura (°C)",
                                            validatorText:
                                                'Favor de escribir la temperatura',
                                            controllerText:
                                                _temperaturaCentigradosController,
                                            onChanged: _onCelsiusChanged,
                                            decimales: 2,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ), // separación entre campos
                                        Expanded(
                                          child: _buildTextFormField(
                                            context,
                                            hintText: "Temperatura (°F)",
                                            validatorText:
                                                'Favor de escribir la temperatura',
                                            controllerText:
                                                _temperaturaFahrenheitController,
                                            onChanged: _onFahrenheitChanged,
                                            decimales: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildTextFormField(
                                            context,
                                            hintText: "Presión (kg/cm2)",
                                            validatorText:
                                                'Favor de escribir la presión',
                                            controllerText: _presionController,
                                            onChanged: _onPresionChanged,
                                            decimales: 2,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ), // separación entre campos
                                        Expanded(
                                          child: _buildTextFormField(
                                            context,
                                            hintText: "Presión (PSI)",
                                            validatorText:
                                                'Favor de escribir la presión',
                                            controllerText:
                                                _presionPSIController,
                                            onChanged: _onPresionPSIChanged,
                                            decimales: 2,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ), // separación entre campos
                                        Expanded(
                                          child: _buildTextFormField(
                                            context,
                                            hintText: "Presión (kPa)",
                                            validatorText:
                                                'Favor de escribir la presión',
                                            controllerText:
                                                _presionKPaController,
                                            onChanged: _onPresionKPaChanged,
                                            decimales: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                    _buildTextFormField(
                                      context,
                                      hintText: "Meter Factor",
                                      validatorText:
                                          'Favor de escribir el Meter Factor',
                                      controllerText: _meterFactorController,
                                      decimales: 5,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildTextFormField(
                                            context,
                                            hintText: "K Factor (pulsos/m3)",
                                            validatorText:
                                                'Favor de escribir el K Factor (pulsos/m3)',
                                            controllerText:
                                                _kFactorPulsosM3Controller,
                                            onChanged: _onPulsosM3Changed,
                                            decimales: 3,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ), // separación entre campos
                                        Expanded(
                                          child: _buildTextFormField(
                                            context,
                                            hintText: "K Factor (pulsos/bbl)",
                                            validatorText:
                                                'Favor de escribir el K Factor (pulsos/bbl)',
                                            controllerText:
                                                _kFactorPulsosBblController,
                                            onChanged: _onPulsosBblChanged,
                                            decimales: 3,
                                          ),
                                        ),
                                      ],
                                    ),

                                    _buildTextFormField(
                                      context,
                                      hintText: "Frecuencia (Hz)",
                                      validatorText:
                                          'Favor de escribir la frecuencia',
                                      controllerText: _frecuenciaController,
                                      decimales: 2,
                                    ),
                                    _buildTextFormField(
                                      context,
                                      hintText: "Repetibilidad (%)",
                                      validatorText:
                                          'Favor de escribir la repetibilidad',
                                      controllerText: _repetibilidadController,
                                      decimales: 3,
                                    ),
                                    SizedBox(height: 20),
                                    Table(
                                      border: TableBorder.symmetric(
                                        inside: const BorderSide(
                                          color: Colors.black,
                                          width: 1,
                                        ),
                                        outside: const BorderSide(
                                          color: Colors.black,
                                          width: 2,
                                        ),
                                      ),
                                      children: [
                                        TableRow(
                                          decoration: BoxDecoration(
                                            color: theme.colorScheme.tertiary,
                                          ),
                                          children: [
                                            tablaCalibracion.cabeceraTabla(
                                              context,
                                              'Caudal',
                                            ),
                                            tablaCalibracion.cabeceraTabla(
                                              context,
                                              'Caudal',
                                            ),
                                            tablaCalibracion.cabeceraTabla(
                                              context,
                                              'Temperatura',
                                            ),
                                            tablaCalibracion.cabeceraTabla(
                                              context,
                                              'Presión',
                                            ),
                                            tablaCalibracion.cabeceraTabla(
                                              context,
                                              'Meter',
                                            ),
                                            tablaCalibracion.cabeceraTabla(
                                              context,
                                              'Frecuencia',
                                            ),
                                            tablaCalibracion.cabeceraTabla(
                                              context,
                                              'K Factor',
                                            ),
                                            tablaCalibracion.cabeceraTabla(
                                              context,
                                              'K Factor',
                                            ),
                                            tablaCalibracion.cabeceraTabla(
                                              context,
                                              'Repetibilidad',
                                            ),
                                            tablaCalibracion.cabeceraTabla(
                                              context,
                                              'Editar',
                                            ),
                                            tablaCalibracion.cabeceraTabla(
                                              context,
                                              'Borrar',
                                            ),
                                          ],
                                        ),
                                        TableRow(
                                          decoration: BoxDecoration(
                                            color: theme.colorScheme.tertiary,
                                          ),
                                          children: [
                                            tablaCalibracion.cabeceraTabla(
                                              context,
                                              'm³/hr',
                                            ),
                                            tablaCalibracion.cabeceraTabla(
                                              context,
                                              'bbl/hr',
                                            ),
                                            tablaCalibracion.cabeceraTabla(
                                              context,
                                              '°C',
                                            ),
                                            tablaCalibracion.cabeceraTabla(
                                              context,
                                              'Kg/m2',
                                            ),
                                            tablaCalibracion.cabeceraTabla(
                                              context,
                                              'Factor',
                                            ),
                                            tablaCalibracion.cabeceraTabla(
                                              context,
                                              'Hz',
                                            ),
                                            tablaCalibracion.cabeceraTabla(
                                              context,
                                              'Pulsos/m³',
                                            ),
                                            tablaCalibracion.cabeceraTabla(
                                              context,
                                              'Pulsos/bbl',
                                            ),
                                            tablaCalibracion.cabeceraTabla(
                                              context,
                                              '%',
                                            ),
                                            tablaCalibracion.cabeceraTabla(
                                              context,
                                              '',
                                            ),
                                            tablaCalibracion.cabeceraTabla(
                                              context,
                                              '',
                                            ),
                                          ],
                                        ),
                                        ...(_corridasRegistradas.isNotEmpty
                                            ? _corridasRegistradas
                                                  .map(
                                                    (corrida) => TableRow(
                                                      decoration: BoxDecoration(
                                                        color: theme
                                                            .colorScheme
                                                            .tertiaryContainer,
                                                      ),
                                                      children: [
                                                        tablaCalibracion.celdaTabla(
                                                          context,
                                                          convertidor
                                                              .formatoMiles(
                                                                corrida
                                                                    .caudalM3Hr,
                                                                2,
                                                              ),
                                                        ),
                                                        tablaCalibracion.celdaTabla(
                                                          context,
                                                          convertidor
                                                              .formatoMiles(
                                                                corrida
                                                                    .caudalBblHr,
                                                                2,
                                                              ),
                                                        ),
                                                        tablaCalibracion.celdaTabla(
                                                          context,
                                                          convertidor
                                                              .formatoMiles(
                                                                corrida
                                                                    .temperaturaC,
                                                                2,
                                                              ),
                                                        ),
                                                        tablaCalibracion.celdaTabla(
                                                          context,
                                                          convertidor
                                                              .formatoMiles(
                                                                corrida
                                                                    .presionKgCm2,
                                                                2,
                                                              ),
                                                        ),
                                                        tablaCalibracion.celdaTabla(
                                                          context,
                                                          convertidor
                                                              .formatoMiles(
                                                                corrida
                                                                    .meterFactor,
                                                                5,
                                                              ),
                                                        ),
                                                        tablaCalibracion.celdaTabla(
                                                          context,
                                                          convertidor
                                                              .formatoMiles(
                                                                corrida
                                                                    .frecuenciaHz,
                                                                2,
                                                              ),
                                                        ),
                                                        tablaCalibracion.celdaTabla(
                                                          context,
                                                          convertidor.formatoMiles(
                                                            corrida
                                                                .kFactorPulseM3,
                                                            3,
                                                          ),
                                                        ),
                                                        tablaCalibracion.celdaTabla(
                                                          context,
                                                          convertidor.formatoMiles(
                                                            corrida
                                                                .kFactorPulseBbl,
                                                            3,
                                                          ),
                                                        ),
                                                        tablaCalibracion.celdaTabla(
                                                          context,
                                                          convertidor.formatoMiles(
                                                            corrida
                                                                .repetibilidad,
                                                            3,
                                                          ),
                                                        ),
                                                        tablaCalibracion.editarFilaTabla(context, () {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (
                                                                  BuildContext
                                                                  context,
                                                                ) {
                                                                  // This is an alert dialog that asks for confirmation to delete something.
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                      "¿Quieres editar esta corrida?",
                                                                    ),
                                                                    content: SingleChildScrollView(
                                                                      child: ListBody(
                                                                        children:
                                                                            <
                                                                              Widget
                                                                            >[
                                                                              Text(
                                                                                'Se cargaran los datos de la corrida en los campos de entrada para su edición',
                                                                              ),
                                                                            ],
                                                                      ),
                                                                    ),
                                                                    actions: [
                                                                      ElevatedButton(
                                                                        onPressed: () {
                                                                          Navigator.of(
                                                                            context,
                                                                          ).pop(
                                                                            false,
                                                                          ); // Return false if cancelled
                                                                        },
                                                                        child: Text(
                                                                          "Cancelar",
                                                                        ),
                                                                      ),
                                                                      ElevatedButton(
                                                                        style: ButtonStyle(
                                                                          backgroundColor: WidgetStateProperty.all(
                                                                            theme.colorScheme.secondary,
                                                                          ),
                                                                        ),
                                                                        onPressed: () async {
                                                                          // Call a function that deletes the data when confirmed.
                                                                          setState(() {
                                                                            int
                                                                            index = _corridasRegistradas.indexWhere(
                                                                              (
                                                                                c,
                                                                              ) =>
                                                                                  c.idCorrida ==
                                                                                  corrida.idCorrida,
                                                                            );
                                                                            _corridaActual =
                                                                                _corridasRegistradas[index];
                                                                            _caudalM3Controller.text = convertidor.formatoMiles(
                                                                              _corridaActual.caudalM3Hr,
                                                                              2,
                                                                            );
                                                                            _caudalBblController.text = convertidor.formatoMiles(
                                                                              _corridaActual.caudalBblHr,
                                                                              2,
                                                                            );
                                                                            _temperaturaCentigradosController.text = convertidor.formatoMiles(
                                                                              _corridaActual.temperaturaC,
                                                                              2,
                                                                            );
                                                                            _temperaturaFahrenheitController.text = convertidor.formatoMiles(
                                                                              _corridaActual.temperaturaF,
                                                                              2,
                                                                            );
                                                                            _presionController.text = convertidor.formatoMiles(
                                                                              _corridaActual.presionKgCm2,
                                                                              2,
                                                                            );
                                                                            _presionPSIController.text = convertidor.formatoMiles(
                                                                              _corridaActual.presionPSI,
                                                                              2,
                                                                            );
                                                                            _presionKPaController.text = convertidor.formatoMiles(
                                                                              _corridaActual.presionKPa,
                                                                              2,
                                                                            );
                                                                            _meterFactorController.text = convertidor.formatoMiles(
                                                                              _corridaActual.meterFactor,
                                                                              5,
                                                                            );
                                                                            _kFactorPulsosM3Controller.text = convertidor.formatoMiles(
                                                                              _corridaActual.kFactorPulseM3,
                                                                              3,
                                                                            );
                                                                            _kFactorPulsosBblController.text = convertidor.formatoMiles(
                                                                              _corridaActual.kFactorPulseBbl,
                                                                              3,
                                                                            );
                                                                            _frecuenciaController.text = convertidor.formatoMiles(
                                                                              _corridaActual.frecuenciaHz,
                                                                              2,
                                                                            );
                                                                            _repetibilidadController.text = convertidor.formatoMiles(
                                                                              _corridaActual.repetibilidad,
                                                                              3,
                                                                            );
                                                                            editandoCorrida =
                                                                                true;
                                                                            indiceCorridaEditando =
                                                                                index;
                                                                          });

                                                                          Navigator.of(
                                                                            context,
                                                                          ).pop(
                                                                            true,
                                                                          );
                                                                        },
                                                                        child: Text(
                                                                          "Editar",
                                                                          style: TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                          );

                                                          _linealidadController
                                                              .text = convertidor
                                                              .calcularLinealidad(
                                                                _corridasRegistradas,
                                                              );
                                                        }),
                                                        tablaCalibracion.borraFilaTabla(context, () {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (
                                                                  BuildContext
                                                                  context,
                                                                ) {
                                                                  // This is an alert dialog that asks for confirmation to delete something.
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                      "¿Quieres quitar esta corrida?",
                                                                    ),
                                                                    content: SingleChildScrollView(
                                                                      child: ListBody(
                                                                        children:
                                                                            <
                                                                              Widget
                                                                            >[
                                                                              Text(
                                                                                'Quitarás la corrida de la tabla y del cálculo',
                                                                              ),
                                                                            ],
                                                                      ),
                                                                    ),
                                                                    actions: [
                                                                      ElevatedButton(
                                                                        style: ButtonStyle(
                                                                          backgroundColor: WidgetStateProperty.all(
                                                                            theme.colorScheme.primary,
                                                                          ),
                                                                        ),
                                                                        onPressed: () {
                                                                          Navigator.of(
                                                                            context,
                                                                          ).pop(
                                                                            false,
                                                                          ); // Return false if cancelled
                                                                        },
                                                                        child: Text(
                                                                          "Cancelar",
                                                                        ),
                                                                      ),
                                                                      ElevatedButton(
                                                                        style: ButtonStyle(
                                                                          backgroundColor: WidgetStateProperty.all(
                                                                            theme.colorScheme.secondary,
                                                                          ),
                                                                        ),
                                                                        onPressed: () async {
                                                                          // Call a function that deletes the data when confirmed.
                                                                          setState(() {
                                                                            int
                                                                            index = _corridasRegistradas.indexWhere(
                                                                              (
                                                                                c,
                                                                              ) =>
                                                                                  c.idCorrida ==
                                                                                  corrida.idCorrida,
                                                                            );
                                                                            _corridasRegistradas.removeWhere(
                                                                              (
                                                                                c,
                                                                              ) =>
                                                                                  c.idCorrida ==
                                                                                  corrida.idCorrida,
                                                                            );
                                                                            _listaCorridas.removeAt(
                                                                              index,
                                                                            );
                                                                          });

                                                                          Navigator.of(
                                                                            context,
                                                                          ).pop(
                                                                            true,
                                                                          );
                                                                        },
                                                                        child: Text(
                                                                          "Quitar",
                                                                          style: TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                          );

                                                          _linealidadController
                                                              .text = convertidor
                                                              .calcularLinealidad(
                                                                _corridasRegistradas,
                                                              );
                                                        }),
                                                      ],
                                                    ),
                                                  )
                                                  .toList()
                                            : [
                                                TableRow(
                                                  decoration: BoxDecoration(
                                                    color: theme
                                                        .colorScheme
                                                        .tertiaryContainer,
                                                  ),
                                                  children: List.generate(
                                                    11,
                                                    (index) => Padding(
                                                      padding: EdgeInsets.all(
                                                        2.0,
                                                      ),
                                                      child: Text(''),
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              Center(
                                child: editandoCorrida
                                    ? ElevatedButton(
                                        onPressed: _agregarCorrida,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Theme.of(
                                            context,
                                          ).colorScheme.secondary,
                                          foregroundColor: Theme.of(
                                            context,
                                          ).colorScheme.onSecondary,
                                        ),
                                        child: const Text('Agregar edición'),
                                      )
                                    : ElevatedButton(
                                        onPressed: _agregarCorrida,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Theme.of(
                                            context,
                                          ).colorScheme.secondary,
                                          foregroundColor: Theme.of(
                                            context,
                                          ).colorScheme.onSecondary,
                                        ),
                                        child: const Text('Agregar corrida'),
                                      ),
                              ),
                              SizedBox(height: 10),
                              Center(
                                child: ElevatedButton(
                                  onPressed: _limpiaCorrida,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    foregroundColor: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
                                  ),
                                  child: const Text('Limpiar corrida'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Form(
                      key: _keySeccionExtras,
                      child: Container(
                        decoration: cajaFormulario.boxDecoration(context),
                        child: Padding(
                          padding: EdgeInsets.all(30),
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 15),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Center(
                                  child: Row(
                                    children: [
                                      Text(
                                        "Extras",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.tertiary,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      _iconoAyudaSeccion(
                                        context,
                                        'La linealidad se calcula automáticamente al agregar o eliminar corridas, solo agrega observaciones si es necesario.',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildTextFormField(
                                            context,
                                            hintText: "Linealidad (%)",
                                            validatorText:
                                                'Favor de escribir la linealidad',
                                            controllerText:
                                                _linealidadController,
                                            decimales: 3,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ), // separación entre campos
                                        Expanded(
                                          child: _buildTextFormField(
                                            context,
                                            hintText: "Reproducibilidad (%)",
                                            validatorText:
                                                'Favor de escribir la reproducibilidad',
                                            controllerText:
                                                _reproducibilidadController,
                                            decimales: 3,
                                          ),
                                        ),
                                      ],
                                    ),
                                    _buildTextFormField(
                                      context,
                                      hintText: "Observaciones",
                                      validatorText:
                                          'Favor de escribir las observaciones',
                                      controllerText: _observacionesController,
                                      decimales: 0,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              Center(
                                child: ElevatedButton(
                                  onPressed: _guardarCalibracion,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                                    foregroundColor: Theme.of(
                                      context,
                                    ).colorScheme.onSecondary,
                                  ),
                                  child: Text('Registrar'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  void _guardarCalibracion() async {
    if (_corridasRegistradas.isEmpty && _corridasRegistradas.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        mensajes.error(context, 'Debe registrar al menos 5 corridas'),
      );
      return;
    } else {
      if (!_keySeccionEquipo.currentState!.validate() &&
          !_keySeccionDatosCalibracion.currentState!.validate() &&
          !_keySeccionExtras.currentState!.validate()) {
        return;
      }

      _calibracionEquipo = CalibracionEquipo(
        0,
        _certificadoController.text,
        selectedFecha,
        selectedFechaProxima,
        double.tryParse(_linealidadController.text) ?? 0,
        double.tryParse(_reproducibilidadController.text) ?? 0,
        _observacionesController.text,
        '', // ruta certificado
        _corridasRegistradas,
        equipoSeleccionado!.getTagEquipo,
        laboratorioSeleccionado!.getIdLaboratorioCalibracion,
        0,
      );

      bool exito = await calibracionService.registrarCalibracionEquipo(
        direccionSeleccionada!.nombre,
        subdireccionSeleccionada!.nombre,
        gerenciaSeleccionada!.nombre,
        instalacionSeleccionada!.nombreInstalacion,
        patinMedicionSeleccionado!.getTagPatin,
        trenMedicionSeleccionado!.tagTren,
        _calibracionEquipo,
        fileBytes!,
      );

      if (exito) {
        ScaffoldMessenger.of(context).showSnackBar(
          mensajes.info(context, 'Calibración registrada con éxito'),
        );
        //limpiar formulario
        setState(() {
          _keySeccionEquipo.currentState!.reset();
          _keySeccionDatosCalibracion.currentState!.reset();
          _keySeccionCorridas.currentState!.reset();
          _keySeccionExtras.currentState!.reset();
          _laboratorioController.clear();
          _productoController.clear();
          _certificadoController.clear();
          _archivoController.clear();
          _fechaController.clear();
          _fechaProximaController.clear();
          _linealidadController.clear();
          _reproducibilidadController.clear();
          _observacionesController.clear();
          _caudalM3Controller.clear();
          _caudalBblController.clear();
          _temperaturaCentigradosController.clear();
          _presionController.clear();
          _presionPSIController.clear();
          _meterFactorController.clear();
          _kFactorPulsosM3Controller.clear();
          _kFactorPulsosBblController.clear();
          _frecuenciaController.clear();
          _repetibilidadController.clear();
          _listaCorridas.clear();
          _corridasRegistradas.clear();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          mensajes.error(context, 'Error al registrar la calibración'),
        );
      }
    }
  }

  void _agregarCorrida() {
    if (!_keySeccionCorridas.currentState!.validate()) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(mensajes.info(context, 'Se  agregó una corrida'));
    _corridaActual = Corrida(
      _listaCorridas.length + 1,
      double.tryParse(_caudalM3Controller.text.replaceAll(',', '')) ?? 0,
      double.tryParse(_caudalBblController.text.replaceAll(',', '')) ?? 0,
      double.tryParse(
            _temperaturaCentigradosController.text.replaceAll(',', ''),
          ) ??
          0,
      double.tryParse(
            _temperaturaFahrenheitController.text.replaceAll(',', ''),
          ) ??
          0,
      double.tryParse(_presionController.text.replaceAll(',', '')) ?? 0,
      double.tryParse(_presionPSIController.text.replaceAll(',', '')) ?? 0,
      double.tryParse(_presionKPaController.text.replaceAll(',', '')) ?? 0,
      double.tryParse(_meterFactorController.text.replaceAll(',', '')) ?? 0,
      double.tryParse(_kFactorPulsosM3Controller.text.replaceAll(',', '')) ?? 0,
      double.tryParse(_kFactorPulsosBblController.text.replaceAll(',', '')) ??
          0,
      double.tryParse(_repetibilidadController.text.replaceAll(',', '')) ?? 0,
      double.tryParse(_frecuenciaController.text.replaceAll(',', '')) ?? 0,
      0,
    );

    setState(() {
      if (editandoCorrida && indiceCorridaEditando != -1) {
        // Si estamos editando, reemplazamos la corrida en el índice correspondiente
        _corridasRegistradas[indiceCorridaEditando] = _corridaActual;
        _listaCorridas[indiceCorridaEditando] = _corridaActual;
        editandoCorrida = false;
        indiceCorridaEditando = -1;
      } else {
        _listaCorridas.add(_corridaActual);
        _corridasRegistradas.add(_corridaActual);
      }
    });

    _linealidadController.text = convertidor.calcularLinealidad(
      _corridasRegistradas,
    );

    // dar focus después de limpiar
    FocusScope.of(context).requestFocus(_focusNodeCaudal);
  }

  void _limpiaCorrida() {
    setState(() {
      _caudalM3Controller.clear();
      _caudalBblController.clear();
      _temperaturaCentigradosController.clear();
      _temperaturaFahrenheitController.clear();
      _presionController.clear();
      _presionPSIController.clear();
      _presionKPaController.clear();
      _meterFactorController.clear();
      _kFactorPulsosM3Controller.clear();
      _kFactorPulsosBblController.clear();
      _frecuenciaController.clear();
      _repetibilidadController.clear();
    });

    FocusScope.of(context).requestFocus(_focusNodeCaudal);
  }

  InputDecoration _inputDecoration(String label) =>
      InputDecoration(labelText: label, border: const OutlineInputBorder());

  Widget _buildTextFormField(
    BuildContext context, {
    required String hintText,
    required String validatorText,
    required TextEditingController controllerText,
    bool obscureText = false,
    FocusNode? focusNode,
    ValueChanged<String>? onChanged,
    required int decimales,
  }) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Focus(
        onFocusChange: (hasFocus) {
          if (!hasFocus && decimales > 0) {
            String textoFormateado = convertidor.formatoMiles(
              double.tryParse(controllerText.text) ?? 0,
              decimales,
            );
            controllerText.text = textoFormateado;
          }
        },
        child: TextFormField(
          focusNode: focusNode,
          controller: controllerText,
          obscureText: obscureText,
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
          decoration: _inputDecoration(hintText),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return validatorText;
            }
            return null;
          },
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildDateFormField(
    BuildContext context, {
    required String hintText,
    required String validatorText,
    required TextEditingController controllerText,
    bool obscureText = false,
    FocusNode? focusNode,
    required int tipoFecha,
  }) {
    return Container(
      padding: EdgeInsets.all(5),
      child: TextFormField(
        focusNode: focusNode,
        readOnly: true,
        controller: controllerText,
        obscureText: obscureText,
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
        decoration: InputDecoration(
          suffixIcon: Icon(Icons.calendar_today),
          hintText: hintText,
          label: Text(hintText),
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.surface),
          border: const OutlineInputBorder(),
        ),
        onTap: () => tipoFecha == 1 ? _seleccionarFecha(context) : null,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return validatorText;
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDropdownButtonDireccion(
    BuildContext context, {
    required String hintText,
    required Future<List<Direccion>> items,
    required Direccion? value,
    required ValueChanged<Direccion?> onChanged,
  }) {
    //future to list
    return FutureBuilder<List<Direccion>>(
      future: items,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final direcciones = snapshot.data!;
          return DropdownButtonFormField<Direccion>(
            isExpanded: true,
            decoration: _inputDecoration(hintText),
            initialValue: value,
            dropdownColor: Theme.of(context).colorScheme.tertiaryContainer,
            items: direcciones.map((Direccion item) {
              return DropdownMenuItem<Direccion>(
                value: item,
                child: Text(item.getNombre),
              );
            }).toList(),
            onChanged: onChanged,
            validator: (value) {
              if (value == null) {
                return 'Por favor selecciona una opción';
              }
              return null;
            },
          );
        }
      },
    );
  }

  Widget _buildDropdownButtonSubdireccion(
    BuildContext context, {
    required String hintText,
    required List<Subdireccion> items,
    required Subdireccion? value,
    required ValueChanged<Subdireccion?> onChanged,
  }) {
    return DropdownButtonFormField<Subdireccion>(
      isExpanded: true,
      decoration: _inputDecoration(hintText),
      initialValue: value,
      dropdownColor: Theme.of(context).colorScheme.tertiaryContainer,
      items: items.map((Subdireccion item) {
        return DropdownMenuItem<Subdireccion>(
          value: item,
          child: Text(item.nombre),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null) {
          return 'Por favor selecciona una opción';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownButtonGerencia(
    BuildContext context, {
    required String hintText,
    required List<Gerencia> items,
    required Gerencia? value,
    required ValueChanged<Gerencia?> onChanged,
  }) {
    return DropdownButtonFormField<Gerencia>(
      isExpanded: true,
      decoration: _inputDecoration(hintText),
      initialValue: value,
      dropdownColor: Theme.of(context).colorScheme.tertiaryContainer,
      items: items.map((Gerencia item) {
        return DropdownMenuItem<Gerencia>(
          value: item,
          child: Text(item.nombre),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null) {
          return 'Por favor selecciona una opción';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownButtonInstalaciones(
    BuildContext context, {
    required String hintText,
    required List<Instalacion> items,
    required Instalacion? value,
    required ValueChanged<Instalacion?> onChanged,
  }) {
    return DropdownButtonFormField<Instalacion>(
      isExpanded: true,
      decoration: _inputDecoration(hintText),
      initialValue: value,
      dropdownColor: Theme.of(context).colorScheme.tertiaryContainer,
      items: items.map((Instalacion item) {
        return DropdownMenuItem<Instalacion>(
          value: item,
          child: Text(item.getNombreInstalacion),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null) {
          return 'Por favor selecciona una opción';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownButtonPatines(
    BuildContext context, {
    required String hintText,
    required List<PatinMedicion> items,
    required PatinMedicion? value,
    required ValueChanged<PatinMedicion?> onChanged,
  }) {
    return DropdownButtonFormField<PatinMedicion>(
      isExpanded: true,
      decoration: _inputDecoration(hintText),
      initialValue: value,
      dropdownColor: Theme.of(context).colorScheme.tertiaryContainer,
      items: items.map((PatinMedicion item) {
        return DropdownMenuItem<PatinMedicion>(
          value: item,
          child: Text(item.getNombrePatin),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null) {
          return 'Por favor selecciona una opción';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownButtonTrenes(
    BuildContext context, {
    required String hintText,
    required List<TrenMedicion> items,
    required TrenMedicion? value,
    required ValueChanged<TrenMedicion?> onChanged,
  }) {
    return DropdownButtonFormField<TrenMedicion>(
      isExpanded: true,
      decoration: _inputDecoration(hintText),
      initialValue: value,
      dropdownColor: Theme.of(context).colorScheme.tertiaryContainer,
      items: items.map((TrenMedicion item) {
        return DropdownMenuItem<TrenMedicion>(
          value: item,
          child: Text(item.getTagTren),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null) {
          return 'Por favor selecciona una opción';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownButtonEquipos(
    BuildContext context, {
    required String hintText,
    required List<Equipo> items,
    required Equipo? value,
    required ValueChanged<Equipo?> onChanged,
  }) {
    return DropdownButtonFormField<Equipo>(
      isExpanded: true,
      decoration: _inputDecoration(hintText),
      initialValue: value,
      dropdownColor: Theme.of(context).colorScheme.tertiaryContainer,
      items: items.map((Equipo item) {
        return DropdownMenuItem<Equipo>(
          value: item,
          child: Text(item.getTagEquipo),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null) {
          return 'Por favor selecciona una opción';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownButtonLaboratorio(
    BuildContext context, {
    required String hintText,
    required Future<List<LaboratorioCalibracion>> items,
    required LaboratorioCalibracion? value,
    required ValueChanged<LaboratorioCalibracion?> onChanged,
  }) {
    //future to list
    return FutureBuilder<List<LaboratorioCalibracion>>(
      future: items,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final direcciones = snapshot.data!;
          return DropdownButtonFormField<LaboratorioCalibracion>(
            isExpanded: true,
            decoration: _inputDecoration(hintText),
            initialValue: value,
            dropdownColor: Theme.of(context).colorScheme.tertiaryContainer,
            items: direcciones.map((LaboratorioCalibracion item) {
              return DropdownMenuItem<LaboratorioCalibracion>(
                value: item,
                child: Text(item.getNombre),
              );
            }).toList(),
            onChanged: onChanged,
            validator: (value) {
              if (value == null) {
                return 'Por favor selecciona una opción';
              }
              return null;
            },
          );
        }
      },
    );
  }

  void _pickFileWeb() {
    final uploadInput = html.FileUploadInputElement();
    uploadInput.accept = '.pdf';
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final file = uploadInput.files!.first;
      final reader = html.FileReader();

      reader.readAsArrayBuffer(file);
      reader.onLoadEnd.listen((e) {
        _archivoController.text = file.name;
        fileBytes = reader.result as Uint8List;
      });
    });
  }

  /*Future<void> _pickFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf'],
  );

  if (result != null && result.files.isNotEmpty) {
    setState(() {
      _archivoController.text = result.files.single.name;

      if (kIsWeb) {
        // En web NO hay path, solo bytes
        fileBytes = result.files.single.bytes;
        fileCertificado = null; // o ignóralo
      } else {
        // En móvil/escritorio SÍ hay path
        fileCertificado = File(result.files.single.path!);
        fileBytes = null; // o ambas, según necesites
      }
    });
  }
} */

  Widget _buildFileFormField(
    BuildContext context, {
    required String hintText,
    required String validatorText,
    required TextEditingController controllerText,
    bool obscureText = false,
    FocusNode? focusNode,
  }) {
    return Container(
      padding: EdgeInsets.all(5),
      child: TextFormField(
        focusNode: focusNode,
        readOnly: true,
        controller: controllerText,
        obscureText: obscureText,
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
        decoration: InputDecoration(
          suffixIcon: Icon(Icons.upload_file),
          hintText: hintText,
          label: Text(hintText),
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.surface),
          border: const OutlineInputBorder(),
        ),
        onTap: () => _pickFileWeb(),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Por favor selecciona un archivo PDF";
          }
          return null;
        },
      ),
    );
  }

  IconButton _iconoAyudaSeccion(BuildContext context, String mensaje) {
    final theme = Theme.of(context);
    return IconButton(
      icon: Icon(
        Icons.help_outline_rounded, // ícono más estilizado
        color: theme.colorScheme.primary,
        size: 22,
      ),
      tooltip: 'Ayuda',
      onPressed: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(mensajes.ayuda(context, mensaje));
      },
    );
  }
}