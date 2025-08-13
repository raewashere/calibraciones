import 'package:calibraciones/models/_direccion.dart';
import 'package:calibraciones/models/_subdireccion.dart';
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

  late Future<List<Direccion>> _futureDirecciones;
  Direccion? selectedDireccion;
  DireccionService direccionService = DireccionServiceImpl();

  List<Subdireccion> subdirecciones = [];
  late Subdireccion subdireccion;
  Subdireccion? selectedSubdireccion;

  bool validarEmail(String email) {
    final RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  @override
  void initState() {
    super.initState();
    //_futureDirecciones = direccionService.obtenerAllDirecciones();
    _futureDirecciones = Future.delayed(
      const Duration(seconds: 2),
      () => [],
    );
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
            selectedDireccion ??= lista[0];
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
                                    DropdownButton<Direccion>(
                                      hint: Text("Dirección"),
                                      value: selectedDireccion,
                                      items: lista
                                          .map<DropdownMenuItem<Direccion>>((
                                            Direccion direccion,
                                          ) {
                                            return DropdownMenuItem<Direccion>(
                                              alignment: Alignment.topLeft,
                                              value: direccion,
                                              child: Text(direccion.nombre),
                                            );
                                          })
                                          .toList(),
                                      onChanged: (Direccion? direcccion) {
                                        if (direcccion != null) {
                                          setState(() {
                                            selectedDireccion = direcccion;
                                            
                                            subdirecciones = direcccion
                                                .getSubdirecciones();
                                            selectedSubdireccion = subdirecciones.isNotEmpty
                                                ? subdirecciones[0]
                                                : null;
                                          });
                                        }
                                      },
                                    ),
                                    DropdownButton(
                                      value: selectedSubdireccion,
                                      hint: Text("Subdirección"),
                                      items: subdirecciones
                                          .map<DropdownMenuItem<Subdireccion>>((
                                            Subdireccion subdireccion,
                                          ) {
                                            return DropdownMenuItem<
                                              Subdireccion
                                            >(
                                              alignment: Alignment.topLeft,
                                              value: subdireccion,
                                              child: Text(subdireccion.nombre),
                                            );
                                          })
                                          .toList(),
                                      onChanged: (Subdireccion? subdireccion) {
                                        if (subdireccion != null) {
                                          setState(() {
                                            selectedSubdireccion = subdireccion;
                                          });
                                        }
                                      },
                                    ),
                                    /*DropdownButton(
                                      hint: Text("Gerencia"),
                                      items: lista
                                          .map<DropdownMenuItem<Direccion>>((
                                            Direccion direccion,
                                          ) {
                                            return DropdownMenuItem<Direccion>(
                                              alignment: Alignment.topLeft,
                                              value: direccion,
                                              child: Text(direccion.nombre),
                                            );
                                          })
                                          .toList(),
                                      onChanged: (Direccion? newObra) {
                                        if (newObra != null) {
                                          setState(() {
                                            selectedDireccion = newObra;
                                          });
                                        }
                                      },
                                    ),*/
                                    DropdownButton(
                                      hint: Text("Instalación"),
                                      items: lista
                                          .map<DropdownMenuItem<Direccion>>((
                                            Direccion direccion,
                                          ) {
                                            return DropdownMenuItem<Direccion>(
                                              alignment: Alignment.topLeft,
                                              value: direccion,
                                              child: Text(direccion.nombre),
                                            );
                                          })
                                          .toList(),
                                      onChanged: (Direccion? newObra) {
                                        if (newObra != null) {
                                          setState(() {
                                            selectedDireccion = newObra;
                                          });
                                        }
                                      },
                                    ),
                                    DropdownButton(
                                      hint: Text(
                                        "Sistema de transporte / Ducto",
                                      ),
                                      items: lista
                                          .map<DropdownMenuItem<Direccion>>((
                                            Direccion direccion,
                                          ) {
                                            return DropdownMenuItem<Direccion>(
                                              alignment: Alignment.topLeft,
                                              value: direccion,
                                              child: Text(direccion.nombre),
                                            );
                                          })
                                          .toList(),
                                      onChanged: (Direccion? newObra) {
                                        if (newObra != null) {
                                          setState(() {
                                            selectedDireccion = newObra;
                                          });
                                        }
                                      },
                                    ),
                                    DropdownButton(
                                      hint: Text("TAG"),
                                      items: lista
                                          .map<DropdownMenuItem<Direccion>>((
                                            Direccion direccion,
                                          ) {
                                            return DropdownMenuItem<Direccion>(
                                              alignment: Alignment.topLeft,
                                              value: direccion,
                                              child: Text(direccion.nombre),
                                            );
                                          })
                                          .toList(),
                                      onChanged: (Direccion? newObra) {
                                        if (newObra != null) {
                                          setState(() {
                                            selectedDireccion = newObra;
                                          });
                                        }
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
                                                    const SnackBar(
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
                                                  const SnackBar(
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
                                                const SnackBar(
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
                                              const SnackBar(
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
                                            const SnackBar(
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
                                          const SnackBar(
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
                                                    const SnackBar(
                                                      content: Text(
                                                        'Enviando información, validar registro',
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    const SnackBar(
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
                                                  const SnackBar(
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
                                                const SnackBar(
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
                                              const SnackBar(
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
                                            const SnackBar(
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
                                          const SnackBar(
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
                                                    const SnackBar(
                                                      content: Text(
                                                        'Enviando información, validar registro',
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    const SnackBar(
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
                                                  const SnackBar(
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
                                                const SnackBar(
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
                                              const SnackBar(
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
                                            const SnackBar(
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
                                          const SnackBar(
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
}
