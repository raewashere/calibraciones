import 'package:calibraciones/models/_direccion.dart';
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
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _primerController = TextEditingController();
  final TextEditingController _segundoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordValidatorController =
      TextEditingController();

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

  bool habilitaGerencia = false;

  bool validarEmail(String email) {
    final RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  @override
  void initState() {
    super.initState();
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
                                          trenMedicionSeleccionado = value;
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
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration: const Duration(seconds: 2),
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Theme.of(
                                          context,
                                        ).colorScheme.tertiaryContainer,
                                        content: Text('Datos laboratorio'),
                                      ),
                                    );
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
                                    _buildTextFormField(
                                      context,
                                      hintText: "Laboratorio de calibración",
                                      validatorText:
                                          'Favor de escribir el laboratorio de calibración',
                                      controllerText: _nombreController,
                                    ),
                                    _buildTextFormField(
                                      context,
                                      hintText: "Producto",
                                      validatorText:
                                          'Favor de escribir el producto',
                                      controllerText: _primerController,
                                    ),
                                    _buildTextFormField(
                                      context,
                                      hintText: "Fecha",
                                      validatorText:
                                          'Favor de escribir la fecha',
                                      controllerText: _primerController,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              Center(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_formularioRegistro.currentState!
                                        .validate()) {
                                      if (_nombreController.text.length <= 50) {
                                        if (_primerController.text.length <=
                                            30) {
                                          if (_segundoController.text.length <=
                                              30) {
                                            if (_emailController.text.length <=
                                                30) {
                                              if (validarEmail(
                                                _emailController.text,
                                              )) {
                                                if (_passwordController.text ==
                                                    _passwordValidatorController
                                                        .text) {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      duration: const Duration(
                                                        seconds: 2,
                                                      ),
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                      backgroundColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .tertiaryContainer,
                                                      content: Text(
                                                        'Enviando información, validar registro',
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      duration: const Duration(
                                                        seconds: 2,
                                                      ),
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                      backgroundColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .tertiaryContainer,
                                                      content: Text(
                                                        'Verificar que las contraseñas son iguales',
                                                      ),
                                                    ),
                                                  );
                                                }
                                              } else {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    duration: const Duration(
                                                      seconds: 2,
                                                    ),
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .tertiaryContainer,
                                                    content: Text(
                                                      'El correo introducido no es correcto',
                                                    ),
                                                  ),
                                                );
                                              }
                                            } else {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  duration: const Duration(
                                                    seconds: 2,
                                                  ),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .tertiaryContainer,
                                                  content: Text(
                                                    'Campo de correo electrónico limitado a 30 caracteres',
                                                  ),
                                                ),
                                              );
                                            }
                                          } else {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                duration: const Duration(
                                                  seconds: 2,
                                                ),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                backgroundColor: Theme.of(
                                                  context,
                                                ).colorScheme.tertiaryContainer,
                                                content: Text(
                                                  'Campo de segundo apellido limitado a 30 caracteres',
                                                ),
                                              ),
                                            );
                                          }
                                        } else {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              duration: const Duration(
                                                seconds: 2,
                                              ),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              backgroundColor: Theme.of(
                                                context,
                                              ).colorScheme.tertiaryContainer,
                                              content: Text(
                                                'Campo de primer apellido limitado a 30 caracteres',
                                              ),
                                            ),
                                          );
                                        }
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            duration: const Duration(
                                              seconds: 2,
                                            ),
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor: Theme.of(
                                              context,
                                            ).colorScheme.tertiaryContainer,
                                            content: Text(
                                              'Campo de nombre limitado a 30 caracteres',
                                            ),
                                          ),
                                        );
                                      }
                                    }
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
                                    "Tabla corridas",
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
                                      controllerText: _nombreController,
                                    ),
                                    _buildTextFormField(
                                      context,
                                      hintText: "Caudal (bbl/hr)",
                                      validatorText: '',
                                      controllerText: _primerController,
                                    ),
                                    _buildTextFormField(
                                      context,
                                      hintText: "Temp. (°C)",
                                      validatorText:
                                          'Favor de escribir temp. (°C)',
                                      controllerText: _segundoController,
                                    ),
                                    _buildTextFormField(
                                      context,
                                      hintText: "Presión (kg/cm3)",
                                      validatorText:
                                          'Favor de escribir tu correo electrónico',
                                      controllerText: _emailController,
                                    ),
                                    _buildTextFormField(
                                      context,
                                      hintText: "Meter Factor",
                                      obscureText: true,
                                      validatorText:
                                          'Favor de escribir tu contraseña',
                                      controllerText: _passwordController,
                                    ),
                                    _buildTextFormField(
                                      context,
                                      hintText: "K Factor (Pulsos/m3)",
                                      obscureText: true,
                                      validatorText:
                                          'Favor de escribir tu contraseña',
                                      controllerText: _passwordController,
                                    ),
                                    _buildTextFormField(
                                      context,
                                      hintText: "K Factor (Pulsos/bbl)",
                                      obscureText: true,
                                      validatorText:
                                          'Favor de escribir tu contraseña',
                                      controllerText: _passwordController,
                                    ),
                                    _buildTextFormField(
                                      context,
                                      hintText: "Frecuencia (Hz)",
                                      obscureText: true,
                                      validatorText:
                                          'Favor de escribir tu contraseña',
                                      controllerText: _passwordController,
                                    ),
                                    _buildTextFormField(
                                      context,
                                      hintText: "Repetibilidad",
                                      obscureText: true,
                                      validatorText:
                                          'Favor de escribir la repetibilidad',
                                      controllerText: _passwordController,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              Center(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_formularioRegistro.currentState!
                                        .validate()) {
                                      if (_nombreController.text.length <= 50) {
                                        if (_primerController.text.length <=
                                            30) {
                                          if (_segundoController.text.length <=
                                              30) {
                                            if (_emailController.text.length <=
                                                30) {
                                              if (validarEmail(
                                                _emailController.text,
                                              )) {
                                                if (_passwordController.text ==
                                                    _passwordValidatorController
                                                        .text) {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      duration: const Duration(
                                                        seconds: 2,
                                                      ),
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                      backgroundColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .tertiaryContainer,
                                                      content: Text(
                                                        'Enviando información, validar registro',
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      duration: const Duration(
                                                        seconds: 2,
                                                      ),
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                      backgroundColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .tertiaryContainer,
                                                      content: Text(
                                                        'Verificar que las contraseñas son iguales',
                                                      ),
                                                    ),
                                                  );
                                                }
                                              } else {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    duration: const Duration(
                                                      seconds: 2,
                                                    ),
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .tertiaryContainer,
                                                    content: Text(
                                                      'El correo introducido no es correcto',
                                                    ),
                                                  ),
                                                );
                                              }
                                            } else {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  duration: const Duration(
                                                    seconds: 2,
                                                  ),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .tertiaryContainer,
                                                  content: Text(
                                                    'Campo de correo electrónico limitado a 30 caracteres',
                                                  ),
                                                ),
                                              );
                                            }
                                          } else {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                duration: const Duration(
                                                  seconds: 2,
                                                ),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                backgroundColor: Theme.of(
                                                  context,
                                                ).colorScheme.tertiaryContainer,
                                                content: Text(
                                                  'Campo de segundo apellido limitado a 30 caracteres',
                                                ),
                                              ),
                                            );
                                          }
                                        } else {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              duration: const Duration(
                                                seconds: 2,
                                              ),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              backgroundColor: Theme.of(
                                                context,
                                              ).colorScheme.tertiaryContainer,
                                              content: Text(
                                                'Campo de primer apellido limitado a 30 caracteres',
                                              ),
                                            ),
                                          );
                                        }
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            duration: const Duration(
                                              seconds: 2,
                                            ),
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor: Theme.of(
                                              context,
                                            ).colorScheme.tertiaryContainer,
                                            content: Text(
                                              'Campo de nombre limitado a 30 caracteres',
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                                    foregroundColor: Theme.of(
                                      context,
                                    ).colorScheme.onSecondary,
                                  ),
                                  child: const Text('Agregar Corrida'),
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
                                      hintText: "Linealidad",
                                      validatorText:
                                          'Favor de escribir la linealidad',
                                      controllerText: _nombreController,
                                    ),
                                    _buildTextFormField(
                                      context,
                                      hintText: "Reproducibilidad",
                                      validatorText:
                                          'Favor de escribir la reproducibilidad',
                                      controllerText: _primerController,
                                    ),
                                    _buildTextFormField(
                                      context,
                                      hintText: "Observaciones",
                                      validatorText:
                                          'Favor de escribir tu observaciones',
                                      controllerText: _segundoController,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              Center(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_formularioRegistro.currentState!
                                        .validate()) {
                                      if (_nombreController.text.length <= 50) {
                                        if (_primerController.text.length <=
                                            30) {
                                          if (_segundoController.text.length <=
                                              30) {
                                            if (_emailController.text.length <=
                                                30) {
                                              if (validarEmail(
                                                _emailController.text,
                                              )) {
                                                if (_passwordController.text ==
                                                    _passwordValidatorController
                                                        .text) {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      duration: const Duration(
                                                        seconds: 2,
                                                      ),
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                      backgroundColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .tertiaryContainer,
                                                      content: Text(
                                                        'Enviando información, validar registro',
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      duration: const Duration(
                                                        seconds: 2,
                                                      ),
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                      backgroundColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .tertiaryContainer,
                                                      content: Text(
                                                        'Verificar que las contraseñas son iguales',
                                                      ),
                                                    ),
                                                  );
                                                }
                                              } else {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    duration: const Duration(
                                                      seconds: 2,
                                                    ),
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .tertiaryContainer,
                                                    content: Text(
                                                      'El correo introducido no es correcto',
                                                    ),
                                                  ),
                                                );
                                              }
                                            } else {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  duration: const Duration(
                                                    seconds: 2,
                                                  ),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .tertiaryContainer,
                                                  content: Text(
                                                    'Campo de correo electrónico limitado a 30 caracteres',
                                                  ),
                                                ),
                                              );
                                            }
                                          } else {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                duration: const Duration(
                                                  seconds: 2,
                                                ),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                backgroundColor: Theme.of(
                                                  context,
                                                ).colorScheme.tertiaryContainer,
                                                content: Text(
                                                  'Campo de segundo apellido limitado a 30 caracteres',
                                                ),
                                              ),
                                            );
                                          }
                                        } else {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              duration: const Duration(
                                                seconds: 2,
                                              ),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              backgroundColor: Theme.of(
                                                context,
                                              ).colorScheme.tertiaryContainer,
                                              content: Text(
                                                'Campo de primer apellido limitado a 30 caracteres',
                                              ),
                                            ),
                                          );
                                        }
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            duration: const Duration(
                                              seconds: 2,
                                            ),
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor: Theme.of(
                                              context,
                                            ).colorScheme.tertiaryContainer,
                                            content: Text(
                                              'Campo de nombre limitado a 30 caracteres',
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                                    foregroundColor: Theme.of(
                                      context,
                                    ).colorScheme.onSecondary,
                                  ),
                                  child: const Text('Terminar registro'),
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

  Widget _buildTextFormField(
    BuildContext context, {
    required String hintText,
    required String validatorText,
    required TextEditingController controllerText,
    bool obscureText = false,
  }) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(border: Border(bottom: BorderSide())),
      child: TextFormField(
        controller: controllerText,
        obscureText: obscureText,
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.surface),
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return validatorText;
          }
          return null;
        },
      ),
    );
  }

  InputDecoration _inputDecoration(String label) =>
      InputDecoration(labelText: label, border: const OutlineInputBorder());

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
}
