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
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class VistaRegistroCalibracion extends StatefulWidget {
  const VistaRegistroCalibracion({super.key});

  @override
  State<StatefulWidget> createState() => VistaRegistroCalibracionState();
}

class VistaRegistroCalibracionState extends State<VistaRegistroCalibracion> {
  final _formularioRegistro = GlobalKey<FormState>();

  //Datos laboratorio
  final TextEditingController _laboratorioController = TextEditingController();
  final TextEditingController _productoController = TextEditingController();
  final TextEditingController _certificadoController = TextEditingController();
  final TextEditingController _archivoController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();

  //Datos corridas
  final TextEditingController _caudalM3Controller = TextEditingController();
  final TextEditingController _caudalBblController = TextEditingController();
  final TextEditingController _temperaturaController = TextEditingController();
  final TextEditingController _presionController = TextEditingController();
  final TextEditingController _presionPSIController = TextEditingController();
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
  late List<Corrida> _corridasRegistradas = [];

  late CalibracionEquipo _calibracionEquipo;

  CalibracionService calibracionService = CalibracionServiceImpl();

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
        _fechaController.text =
            "${picked.day}/${picked.month}/${picked.year}"; // formato básico
      });
    }
  }

  final FocusNode _focusNodeLaboratorio = FocusNode();
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
  bool _editingPulsosM3 = false;
  bool _editingPulsosBbl = false;
  bool _editingPresion = false;
  bool _editingPresionPSI = false;

  static const double factor = 6.28981; // m³/h a bbl/h
  static const double factorPulsos = 0.158987; // bbl → m³

  static const double factorPresion = 14.22334; // PSI → kg/cm²

  void _onCaudalM3Changed(String value) {
    if (_editingBbl) return; // evita recursividad
    setState(() => _editingM3 = true);
    if (value.isNotEmpty) {
      double m3 = double.tryParse(value) ?? 0;
      double bbl = m3 * factor;
      _caudalBblController.text = bbl.toStringAsFixed(5);
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
      _caudalM3Controller.text = m3.toStringAsFixed(5);
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
      double pbbl = pm3 * factor;
      _kFactorPulsosBblController.text = pbbl.toStringAsFixed(5);
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
      double pm3 = pbbl / factor;
      _kFactorPulsosM3Controller.text = pm3.toStringAsFixed(5);
    } else {
      _kFactorPulsosM3Controller.clear();
    }
    setState(() => _editingPulsosBbl = false);
  }

  void _onPresionChanged(String value) {
    if (_editingPresionPSI) return; // evita recursividad
    setState(() => _editingPresion = true);
    if (value.isNotEmpty) {
      double psi = double.tryParse(value) ?? 0;
      double kgcm2 = (psi * factorPresion);
      _presionPSIController.text = kgcm2.toStringAsFixed(5);
    } else {
      _presionPSIController.clear();
    }
    setState(() => _editingPresion = false);
  }

  void _onPresionPSIChanged(String value) {
    if (_editingPresion) return; // evita recursividad
    setState(() => _editingPresionPSI = true);
    if (value.isNotEmpty) {
      double kgcm2 = double.tryParse(value) ?? 0;
      double psi = (kgcm2 / factorPresion);
      _presionController.text = psi.toStringAsFixed(5);
    } else {
      _presionController.clear();
    }
    setState(() => _editingPresionPSI = false);
  }

  bool validarEmail(String email) {
    final RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  @override
  void initState() {
    super.initState();
    //_focusNode.dispose();
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
                              Center(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    FocusScope.of(
                                      context,
                                    ).requestFocus(_focusNodeLaboratorio);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                                    foregroundColor: Theme.of(
                                      context,
                                    ).colorScheme.onSecondary,
                                  ),
                                  child: const Text('Siguiente paso'),
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
                                      hintText: "Fecha",
                                      validatorText:
                                          'Favor de escribir la fecha',
                                      controllerText: _fechaController,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              Center(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    FocusScope.of(
                                      context,
                                    ).requestFocus(_focusNodeCaudal);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                                    foregroundColor: Theme.of(
                                      context,
                                    ).colorScheme.onSecondary,
                                  ),
                                  child: const Text('Siguiente paso'),
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
                                    _buildTextFormField(
                                      context,
                                      hintText: "Caudal (m3/hr)",
                                      validatorText:
                                          'Favor de escribir el caudal',
                                      controllerText: _caudalM3Controller,
                                      focusNode: _focusNodeCaudal,
                                      onChanged: _onCaudalM3Changed,
                                    ),
                                    _buildTextFormField(
                                      context,
                                      hintText: "Caudal (bbl/hr)",
                                      validatorText:
                                          'Favor de escribir el caudal',
                                      controllerText: _caudalBblController,
                                      onChanged: _onCaudalBblChanged,
                                    ),
                                    _buildTextFormField(
                                      context,
                                      hintText: "Temperatura (°C)",
                                      validatorText:
                                          'Favor de escribir la temperatura',
                                      controllerText: _temperaturaController,
                                    ),
                                    _buildTextFormField(
                                      context,
                                      hintText: "Presión (kg/cm2)",
                                      validatorText:
                                          'Favor de escribir la presión',
                                      controllerText: _presionController,
                                      onChanged: _onPresionChanged,
                                    ),
                                    _buildTextFormField(
                                      context,
                                      hintText: "Presión (PSI)",
                                      validatorText:
                                          'Favor de escribir la presión',
                                      controllerText: _presionPSIController,
                                      onChanged: _onPresionPSIChanged,
                                    ),
                                    _buildTextFormField(
                                      context,
                                      hintText: "Meter Factor",
                                      validatorText:
                                          'Favor de escribir el Meter Factor',
                                      controllerText: _meterFactorController,
                                    ),
                                    _buildTextFormField(
                                      context,
                                      hintText: "K Factor (pulsos/m3)",
                                      validatorText:
                                          'Favor de escribir el K Factor (pulsos/m3)',
                                      controllerText:
                                          _kFactorPulsosM3Controller,
                                      onChanged: _onPulsosM3Changed,
                                    ),
                                    _buildTextFormField(
                                      context,
                                      hintText: "K Factor (pulsos/bbl)",
                                      validatorText:
                                          'Favor de escribir el K Factor (pulsos/bbl)',
                                      controllerText:
                                          _kFactorPulsosBblController,
                                      onChanged: _onPulsosBblChanged,
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
                                    _listaCorridas.isNotEmpty
                                        ? Column(children: _listaCorridas)
                                        : Padding(
                                            padding: EdgeInsets.all(20),
                                            child: Text(
                                              'No hay corridas registradas',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.primary,
                                              ),
                                            ),
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
    if (_corridasRegistradas.length < 1) {
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
        DateTime.now().add(Duration(days: 90)),
        DateTime.now().add(Duration(days: 180)), //fecha proxima calibracion
        double.tryParse(_linealidadController.text) ?? 0,
        double.tryParse(_reproducibilidadController.text) ?? 0,
        _observacionesController.text,
        '', //documento certificado
        _corridasRegistradas,
        equipoSeleccionado!.getTagEquipo,
        laboratorioSeleccionado!.getIdLaboratorioCalibracion,
        0,
      );

      bool exito = await calibracionService.registrarCalibracionEquipo(
        _calibracionEquipo,
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
          _fechaController.clear();
          _linealidadController.clear();
          _reproducibilidadController.clear();
          _observacionesController.clear();
          _caudalM3Controller.clear();
          _caudalBblController.clear();
          _temperaturaController.clear();
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

  void _agregarCorrida() async {
    _corridaActual = Corrida(
      _listaCorridas.length + 1,
      double.tryParse(_caudalM3Controller.text) ?? 0,
      double.tryParse(_caudalBblController.text) ?? 0,
      double.tryParse(_temperaturaController.text) ?? 0,
      double.tryParse(_presionController.text) ?? 0,
      double.tryParse(_presionPSIController.text) ?? 0,
      double.tryParse(_meterFactorController.text) ?? 0,
      double.tryParse(_kFactorPulsosM3Controller.text) ?? 0,
      double.tryParse(_kFactorPulsosBblController.text) ?? 0,
      double.tryParse(_frecuenciaController.text) ?? 0,
      double.tryParse(_repetibilidadController.text) ?? 0,
      0,
    );
    _listaCorridas.add(TablaCalibracion(corrida: _corridaActual));
    _corridasRegistradas.add(_corridaActual);

    if (_listaCorridas.length < 1) {
      setState(() {
        _caudalM3Controller.clear();
        _caudalBblController.clear();
        _temperaturaController.clear();
        _presionController.clear();
        _presionPSIController.clear();
        _meterFactorController.clear();
        _kFactorPulsosM3Controller.clear();
        _kFactorPulsosBblController.clear();
        _frecuenciaController.clear();
        _repetibilidadController.clear();
      });
      FocusScope.of(context).requestFocus(_focusNodeCaudal);
    }
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
        onTap: () => _seleccionarFecha(context),
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

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _archivoController.text =
            result.files.single.name;
      });
    }
  }

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
        onTap: () => _pickFile(),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Por favor selecciona un archivo PDF";
          }
          return null;
        },
      ),
    );
  }
}
