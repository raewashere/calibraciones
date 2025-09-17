import 'package:calibraciones/models/_direccion.dart';
import 'package:calibraciones/models/_equipo.dart';
import 'package:calibraciones/models/_gerencia.dart';
import 'package:calibraciones/models/_instalacion.dart';
import 'package:calibraciones/models/_patin_medicion.dart';
import 'package:calibraciones/models/_subdireccion.dart';
import 'package:calibraciones/models/_tren_medicion.dart';
import 'package:calibraciones/services/direccion_service.dart';
import 'package:calibraciones/services/implementation/direccion_service_impl.dart';
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
      double pbbl = pm3 * factor;
      _kFactorPulsosM3Controller.text = pbbl.toStringAsFixed(2);
    } else {
      _kFactorPulsosM3Controller.clear();
    }
    setState(() => _editingPulsosM3 = false);
  }

  void _onPulsosBblChanged(String value) {
    if (_editingPulsosM3) return; // evita recursividad
    setState(() => _editingPulsosBbl = true);
    if (value.isNotEmpty) {
      double pbbl = double.tryParse(value) ?? 0;
      double pm3 = pbbl / factor;
      _kFactorPulsosBblController.text = pm3.toStringAsFixed(2);
    } else {
      _kFactorPulsosBblController.clear();
    }
    setState(() => _editingPulsosBbl = false);
  }

  void _onPresionChanged(String value) {
    if (_editingPresionPSI) return; // evita recursividad
    setState(() => _editingPresion = true);
    if (value.isNotEmpty) {
      double psi = double.tryParse(value) ?? 0;
      double kgcm2 = psi / factorPresion;
      _presionController.text = kgcm2.toStringAsFixed(2);
    } else {
      _presionController.clear();
    }
    setState(() => _editingPresion = false);
  }

  void _onPresionPSIChanged(String value) {
    if (_editingPresion) return; // evita recursividad
    setState(() => _editingPresionPSI = true);
    if (value.isNotEmpty) {
      double kgcm2 = double.tryParse(value) ?? 0;
      double psi = kgcm2 * factorPresion;
      _presionPSIController.text = psi.toStringAsFixed(2);
    } else {
      _presionPSIController.clear();
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
                                            print(
                                              'No hay gerencias, solo instalaciones directas',
                                            );
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
                                  child: const Text('Siguiente paso 1'),
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
                                    _buildTextFormField(
                                      context,
                                      hintText: "Laboratorio de calibración",
                                      validatorText:
                                          'Favor de escribir el laboratorio de calibración',
                                      controllerText: _laboratorioController,
                                      focusNode: _focusNodeLaboratorio,
                                    ),
                                    _buildTextFormField(
                                      context,
                                      hintText: "Producto",
                                      validatorText:
                                          'Favor de escribir el producto',
                                      controllerText: _productoController,
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
                                  child: const Text('Registrar corridas'),
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
                                  child: const Text('Agregar corrida'),
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
      decoration: BoxDecoration(border: Border(bottom: BorderSide())),
      child: TextFormField(
        focusNode: focusNode,
        controller: controllerText,
        obscureText: obscureText,
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
        decoration: _inputDecoration(hintText),
        /*decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.surface),
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
        ),*/
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
      decoration: BoxDecoration(border: Border(bottom: BorderSide())),
      child: TextFormField(
        focusNode: focusNode,
        readOnly: true,
        controller: controllerText,
        obscureText: obscureText,
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
        decoration: InputDecoration(
          suffixIcon: Icon(Icons.calendar_today),
          hintText: hintText,
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.surface),
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
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
}
