import 'dart:io' show File; // Esto solo se usa en móviles/escritorio
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:calibraciones/models/_calibracion_equipo.dart';
import 'package:calibraciones/models/_corrida.dart';
import 'package:calibraciones/models/_direccion.dart';
import 'package:calibraciones/models/_equipo.dart';
import 'package:calibraciones/models/_gerencia.dart';
import 'package:calibraciones/models/_instalacion.dart';
import 'package:calibraciones/models/_laboratorio_calibracion.dart';
import 'package:calibraciones/models/_patin_medicion.dart';
import 'package:calibraciones/models/_subdireccion.dart';
import 'package:calibraciones/models/_tren_medicion.dart';
import 'package:calibraciones/screens/components/tabla_calibracion.dart';
import 'package:calibraciones/services/calibracion_service.dart';
import 'package:calibraciones/services/direccion_service.dart';
import 'package:calibraciones/services/implementation/calibracion_service_impl.dart';
import 'package:calibraciones/services/implementation/direccion_service_impl.dart';
import 'package:calibraciones/services/implementation/laboratorio_calibracion_service_impl.dart';
import 'package:calibraciones/services/laboratorio_calibracion_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VistaRegistroCalibracion extends StatefulWidget {
  const VistaRegistroCalibracion({super.key});

  @override
  State<StatefulWidget> createState() => VistaRegistroCalibracionState();
}

class VistaRegistroCalibracionState extends State<VistaRegistroCalibracion> {
  final _formularioRegistro = GlobalKey<FormState>();

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
  final TextEditingController _temperaturaCentigradosController = TextEditingController();
  final TextEditingController _temperaturaFahrenheitController = TextEditingController();
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

  final List<Widget> _listaCorridas = [];
  late Corrida _corridaActual;
  late final List<Corrida> _corridasRegistradas = [];

  late CalibracionEquipo _calibracionEquipo;

  CalibracionService calibracionService = CalibracionServiceImpl();

  File? fileCertificado;
  late Uint8List? fileBytes;

  Future<void> _seleccionarFecha(BuildContext context, int tipoFecha) async {
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
        if (tipoFecha == 1) {
          _fechaController.text = formato.format(picked);
          selectedFecha = picked;
        } else {
          _fechaProximaController.text = formato.format(picked);
          selectedFechaProxima = picked;
        }
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
  final bool _editingPresionKPa = false;

  static const double factor = 6.28981; // m³/h a bbl/h
  static const double factorPulsos = 0.158987; // bbl → m³

  static const double factorPresion = 14.22334; // PSI → kg/cm²

  void _onCaudalM3Changed(String value) {
    if (_editingBbl) return; // evita recursividad
    setState(() => _editingM3 = true);
    if (value.isNotEmpty) {
      double m3 = double.tryParse(value) ?? 0;
      double bbl = m3 * factor;
      _caudalBblController.text = bbl.toStringAsFixed(2);
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
      double m3 = bbl / factor;
      _caudalM3Controller.text = m3.toStringAsFixed(2);
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
      double pbbl = pm3 / factor;
      _kFactorPulsosBblController.text = pbbl.toStringAsFixed(2);
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
      double pm3 = pbbl * factor;
      _kFactorPulsosM3Controller.text = pm3.toStringAsFixed(2);
    } else {
      _kFactorPulsosM3Controller.clear();
    }
    setState(() => _editingPulsosBbl = false);
  }

  void _onPresionChanged(String value) {
    if (_editingPresionPSI) return; // evita recursividad
    setState(() => _editingPresion = true);
    if (value.isNotEmpty) {
      double kgcm2 = double.tryParse(value) ?? 0;
      double psi = (kgcm2 * factorPresion) / 10000;
      _presionPSIController.text = psi.toStringAsFixed(3);
      double kPa = (kgcm2 / 0.101972) / 1000;
      _presionKPaController.text = kPa.toStringAsFixed(3);
    } else {
      _presionPSIController.clear();
      _presionKPaController.clear();
    }
    setState(() => _editingPresion = false);
  }

  void _onPresionPSIChanged(String value) {
    if (_editingPresion) return; // evita recursividad
    setState(() => _editingPresionPSI = true);
    if (value.isNotEmpty) {
      double psi = double.tryParse(value) ?? 0;
      double kgcm2 = (psi / factorPresion) * 10000;
      _presionController.text = kgcm2.toStringAsFixed(3);
      double kPa = (kgcm2 / 0.101972) / 1000;
      _presionKPaController.text = kPa.toStringAsFixed(3);
    } else {
      _presionController.clear();
      _presionKPaController.clear();
    }
    setState(() => _editingPresionPSI = false);
  }

  void _onPresionKPaChanged(String value) {
    if (_editingPresionPSI) return; // evita recursividad
    setState(() => _editingPresion = true);
    if (value.isNotEmpty) {
      double kPa = double.tryParse(value) ?? 0;
      double kgcm2 = kPa * 101.972;
      _presionController.text = kgcm2.toStringAsFixed(3);
      double psi = (kgcm2 * factorPresion) / 10000;
      _presionPSIController.text = psi.toStringAsFixed(3);
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
      double fahrenheit = (celsius * 9 / 5) + 32;
      _temperaturaFahrenheitController.text = fahrenheit.toStringAsFixed(2);
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
      double celsius = (fahrenheit - 32) * 5 / 9;
      _temperaturaCentigradosController.text = celsius.toStringAsFixed(2);
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
    _futureDirecciones = direccionService.obtenerAllDirecciones();
    _futureLaboratorios = laboratorioService.obtenerAllLaboratorios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
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
            return Form(
              key: _formularioRegistro,
              child: SingleChildScrollView(
                child: Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onPrimary,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(60),
                            topRight: Radius.circular(60),
                            bottomLeft: Radius.circular(60),
                            bottomRight: Radius.circular(60),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(30),
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 15),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Center(
                                  child: Text(
                                    "Selección equipo",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.tertiary,
                                    ),
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
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onPrimary,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(60),
                            topRight: Radius.circular(60),
                            bottomLeft: Radius.circular(60),
                            bottomRight: Radius.circular(60),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(30),
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 15),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Center(
                                  child: Text(
                                    "Datos calibración",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.tertiary,
                                    ),
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
                                    ),
                                    _buildTextFormField(
                                      context,
                                      hintText: "No. Certificado",
                                      validatorText:
                                          'Favor de escribir el número de certificado',
                                      controllerText: _certificadoController,
                                    ),
                                    _buildFileFormField(
                                      context,
                                      hintText: "Archivo certificado",
                                      validatorText:
                                          'Favor de seleccionar el archivo del certificado',
                                      controllerText: _archivoController,
                                    ),
                                    _buildDateFormField(
                                      context,
                                      hintText: "Fecha calibración",
                                      validatorText:
                                          'Favor de escribir la fecha',
                                      controllerText: _fechaController,
                                      tipoFecha: 1,
                                    ),
                                    _buildDateFormField(
                                      context,
                                      hintText: "Fecha de próxima calibración",
                                      validatorText:
                                          'Favor de escribir la fecha',
                                      controllerText: _fechaProximaController,
                                      tipoFecha: 2,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onPrimary,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(60),
                            topRight: Radius.circular(60),
                            bottomLeft: Radius.circular(60),
                            bottomRight: Radius.circular(60),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(30),
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 15),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Center(
                                  child: Text(
                                    "Corridas",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.tertiary,
                                    ),
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
                                    ),
                                    _buildTextFormField(
                                      context,
                                      hintText: "Repetibilidad (%)",
                                      validatorText:
                                          'Favor de escribir la repetibilidad',
                                      controllerText: _repetibilidadController,
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
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.tertiary,
                                          ),
                                          children: [
                                            TableCell(
                                              child: Container(
                                                alignment: Alignment.center,
                                                padding: const EdgeInsets.all(
                                                  2.0,
                                                ),
                                                child: const Text(
                                                  'Caudal',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Container(
                                                alignment: Alignment.center,
                                                padding: const EdgeInsets.all(
                                                  2.0,
                                                ),
                                                child: const Text(
                                                  'Caudal',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Container(
                                                alignment: Alignment.center,
                                                padding: const EdgeInsets.all(
                                                  2.0,
                                                ),
                                                child: const Text(
                                                  'Temperatura',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Container(
                                                alignment: Alignment.center,
                                                padding: const EdgeInsets.all(
                                                  2.0,
                                                ),
                                                child: const Text(
                                                  'Presión',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Container(
                                                alignment: Alignment.center,
                                                padding: const EdgeInsets.all(
                                                  2.0,
                                                ),
                                                child: const Text(
                                                  'Meter',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Container(
                                                alignment: Alignment.center,
                                                padding: const EdgeInsets.all(
                                                  2.0,
                                                ),
                                                child: const Text(
                                                  'Frecuencia',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Container(
                                                alignment: Alignment.center,
                                                padding: const EdgeInsets.all(
                                                  2.0,
                                                ),
                                                child: const Text(
                                                  'K Factor',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Container(
                                                alignment: Alignment.center,
                                                padding: const EdgeInsets.all(
                                                  2.0,
                                                ),
                                                child: const Text(
                                                  'K Factor',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Container(
                                                alignment: Alignment.center,
                                                padding: const EdgeInsets.all(
                                                  2.0,
                                                ),
                                                child: const Text(
                                                  'Repetibilidad',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Container(
                                                alignment: Alignment.center,
                                                padding: const EdgeInsets.all(
                                                  2.0,
                                                ),
                                                child: const Text(
                                                  'X',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        TableRow(
                                          decoration: BoxDecoration(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.tertiary,
                                          ),
                                          children: [
                                            TableCell(
                                              child: Container(
                                                alignment: Alignment.center,
                                                padding: const EdgeInsets.all(
                                                  2.0,
                                                ),
                                                child: const Text(
                                                  'm3/hr',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Container(
                                                alignment: Alignment.center,
                                                padding: const EdgeInsets.all(
                                                  2.0,
                                                ),
                                                child: const Text(
                                                  'bbl/hr',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Container(
                                                alignment: Alignment.center,
                                                padding: const EdgeInsets.all(
                                                  2.0,
                                                ),
                                                child: const Text(
                                                  '°C',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Container(
                                                alignment: Alignment.center,
                                                padding: const EdgeInsets.all(
                                                  2.0,
                                                ),
                                                child: const Text(
                                                  'kg/cm2',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Container(
                                                alignment: Alignment.center,
                                                padding: const EdgeInsets.all(
                                                  2.0,
                                                ),
                                                child: const Text(
                                                  'Factor',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Container(
                                                alignment: Alignment.center,
                                                padding: const EdgeInsets.all(
                                                  2.0,
                                                ),
                                                child: const Text(
                                                  'Hz',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Container(
                                                alignment: Alignment.center,
                                                padding: const EdgeInsets.all(
                                                  2.0,
                                                ),
                                                child: const Text(
                                                  'Pulsos/m3',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Container(
                                                alignment: Alignment.center,
                                                padding: const EdgeInsets.all(
                                                  2.0,
                                                ),
                                                child: const Text(
                                                  'Pulsos/bbl',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Container(
                                                alignment: Alignment.center,
                                                padding: const EdgeInsets.all(
                                                  2.0,
                                                ),
                                                child: const Text(
                                                  '%',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Container(
                                                alignment: Alignment.center,
                                                padding: const EdgeInsets.all(
                                                  2.0,
                                                ),
                                                child: const Text(
                                                  'X',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        ...(_corridasRegistradas.isNotEmpty
                                            ? _corridasRegistradas
                                                  .map(
                                                    (corrida) => TableRow(
                                                      decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .tertiaryContainer,
                                                      ),
                                                      children: [
                                                        TableCell(
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            padding:
                                                                const EdgeInsets.all(
                                                                  2.0,
                                                                ),
                                                            child: Text(
                                                              corrida.caudalM3Hr
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 10,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        TableCell(
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            padding:
                                                                const EdgeInsets.all(
                                                                  2.0,
                                                                ),
                                                            child: Text(
                                                              corrida
                                                                  .caudalBblHr
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 10,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        TableCell(
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            padding:
                                                                const EdgeInsets.all(
                                                                  2.0,
                                                                ),
                                                            child: Text(
                                                              corrida
                                                                  .temperaturaC
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 10,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        TableCell(
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            padding:
                                                                EdgeInsets.all(
                                                                  2.0,
                                                                ),
                                                            child: Text(
                                                              corrida
                                                                  .presionKgCm2
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 10,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        TableCell(
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            padding:
                                                                EdgeInsets.all(
                                                                  2.0,
                                                                ),
                                                            child: Text(
                                                              corrida
                                                                  .meterFactor
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 10,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        TableCell(
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            padding:
                                                                EdgeInsets.all(
                                                                  2.0,
                                                                ),
                                                            child: Text(
                                                              corrida
                                                                  .frecuenciaHz
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 10,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        TableCell(
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            padding:
                                                                EdgeInsets.all(
                                                                  2.0,
                                                                ),
                                                            child: Text(
                                                              corrida
                                                                  .kFactorPulseM3
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 10,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        TableCell(
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            padding:
                                                                EdgeInsets.all(
                                                                  2.0,
                                                                ),
                                                            child: Text(
                                                              corrida
                                                                  .kFactorPulseBbl
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 10,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        TableCell(
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            padding:
                                                                EdgeInsets.all(
                                                                  2.0,
                                                                ),
                                                            child: Text(
                                                              corrida
                                                                  .repetibilidad
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 10,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        TableCell(
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            padding:
                                                                EdgeInsets.all(
                                                                  2.0,
                                                                ),
                                                            child: IconButton(
                                                              icon: Icon(
                                                                Icons.delete,
                                                                size: 8,
                                                              ),
                                                              onPressed: () {
                                                                setState(() {
                                                                  int index =
                                                                      _corridasRegistradas.indexWhere(
                                                                    (c) =>
                                                                        c.idCorrida ==
                                                                        corrida
                                                                            .idCorrida,
                                                                  );
                                                                  _corridasRegistradas
                                                                      .removeWhere(
                                                                        (c) =>
                                                                        
                                                                            c.idCorrida ==
                                                                            corrida.idCorrida,
                                                                      );
                                                                  _listaCorridas.removeAt(index);
                                                                });
                                                                calcularLinealidad();
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                  .toList()
                                            : [
                                                TableRow(
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .tertiaryContainer,
                                                  ),
                                                  children: List.generate(
                                                    10,
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
                                child: ElevatedButton(
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
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onPrimary,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(60),
                            topRight: Radius.circular(60),
                            bottomLeft: Radius.circular(60),
                            bottomRight: Radius.circular(60),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(30),
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 15),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Center(
                                  child: Text(
                                    "Extras",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.tertiary,
                                    ),
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
                                    _buildTextFormField(
                                      context,
                                      hintText: "Linealidad (%)",
                                      validatorText:
                                          'Favor de escribir la linealidad',
                                      controllerText: _linealidadController,
                                    ),
                                    _buildTextFormField(
                                      context,
                                      hintText: "Reproducibilidad (%)",
                                      validatorText:
                                          'Favor de escribir la reproducibilidad',
                                      controllerText:
                                          _reproducibilidadController,
                                    ),
                                    _buildTextFormField(
                                      context,
                                      hintText: "Observaciones",
                                      validatorText:
                                          'Favor de escribir las observaciones',
                                      controllerText: _observacionesController,
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
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  void _guardarCalibracion() async {
    if (_corridasRegistradas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
          content: Text('Debe registrar al menos 4 corridas'),
        ),
      );
      return;
    } else {
      if (!_formularioRegistro.currentState!.validate()) {
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
          SnackBar(
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
            content: Text('Calibración registrada con éxito'),
          ),
        );
        //limpiar formulario
        setState(() {
          _formularioRegistro.currentState!.reset();
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
          SnackBar(
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
            content: Text('Error al registrar la calibración'),
          ),
        );
      }
    }
  }

  void _agregarCorrida() {
    _corridaActual = Corrida(
      _listaCorridas.length + 1,
      double.tryParse(_caudalM3Controller.text) ?? 0,
      double.tryParse(_caudalBblController.text) ?? 0,
      double.tryParse(_temperaturaCentigradosController.text) ?? 0,
      double.tryParse(_presionController.text) ?? 0,
      double.tryParse(_presionPSIController.text) ?? 0,
      double.tryParse(_meterFactorController.text) ?? 0,
      double.tryParse(_kFactorPulsosM3Controller.text) ?? 0,
      double.tryParse(_kFactorPulsosBblController.text) ?? 0,
      double.tryParse(_repetibilidadController.text) ?? 0,
      double.tryParse(_frecuenciaController.text) ?? 0,
      0,
    );

    setState(() {
      _listaCorridas.add(TablaCalibracion(corrida: _corridaActual));
      _corridasRegistradas.add(_corridaActual);
      // limpiar inputs al terminar
      /*_caudalM3Controller.clear();
      _caudalBblController.clear();
      _temperaturaCentigradosController.clear();
      _presionController.clear();
      _presionPSIController.clear();
      _meterFactorController.clear();
      _kFactorPulsosM3Controller.clear();
      _kFactorPulsosBblController.clear();
      _frecuenciaController.clear();
      _repetibilidadController.clear();*/
    });

    calcularLinealidad();

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
  }) {
    return Container(
      padding: EdgeInsets.all(5),
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
        onTap: () => _seleccionarFecha(context, tipoFecha),
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
            value: value,
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
      value: value,
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
      value: value,
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
      value: value,
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
      value: value,
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
      value: value,
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
      value: value,
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
            value: value,
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
        //print("Archivo: ${file.name}, bytes: ${fileBytes.length}");
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

  double calcularLinealidad() {
    if (_corridasRegistradas.isEmpty) {
      _linealidadController.text = '0.00';
      return 0.0;
    }

    List<double> valores = _corridasRegistradas
        .map((c) => c.getMeterFactor)
        .toList();
    // 1. Promedio
    double promedio = valores.reduce((a, b) => a + b) / valores.length;

    if (promedio == 0) {
      _linealidadController.text = '0.00';
      return 0.0;
    }

    // 2. Calcular desviaciones absolutas respecto al promedio
    List<double> desviaciones = valores
        .map((v) => (v - promedio).abs())
        .toList();

    // 3. Obtener la máxima desviación
    double maxDesviacion = desviaciones.reduce((a, b) => a > b ? a : b);

    // 4. Porcentaje de linealidad
    double porcentajeLinealidad = (maxDesviacion / promedio) * 100;

    _linealidadController.text = porcentajeLinealidad.toStringAsFixed(2);

    return porcentajeLinealidad;
  }
}
