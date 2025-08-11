import 'package:calibraciones/models/_direccion.dart';
import 'package:calibraciones/models/_instalacion.dart';
import 'package:calibraciones/models/_subdireccion.dart';
import 'package:calibraciones/models/_usuario.dart';
import 'package:calibraciones/services/direccion_service.dart';
import 'package:calibraciones/services/implementation/direccion_service_impl.dart';
import 'package:calibraciones/services/implementation/usuario_service_impl.dart';
import 'package:calibraciones/services/usuario_service.dart';
import 'package:flutter/material.dart';

class VistaRegistro extends StatefulWidget {
  const VistaRegistro({super.key});

  @override
  State<StatefulWidget> createState() => VistaRegistroState();
}

class VistaRegistroState extends State<VistaRegistro> {
  final _formularioRegistro = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _primerController = TextEditingController();
  final TextEditingController _segundoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordValidatorController =
      TextEditingController();
  bool respuestaRegistro = false;
  UsuarioService usuarioService = UsuarioServiceImpl();

  List<Direccion> direcciones = [];
  Direccion ? direccionSeleccionada;

  List<Subdireccion> subdirecciones = [];
  Subdireccion ? subdireccionSeleccionada;

  List<Instalacion> instalaciones = [];
  Instalacion ? instalacionSeleccionada;

  DireccionService direccionService = DireccionServiceImpl();

  bool validarEmail(String email) {
    final RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }
  
  @override
  void initState() {
    super.initState();
    direccionService.obtenerAllDirecciones().then((value) {
      setState(() {
        direcciones = value;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Elabora tu registro'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Form(
        key: _formularioRegistro,
        child: SingleChildScrollView(
          // Envuelve en SingleChildScrollView
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Image.asset(
                          'assets/images/pemex_logo_blanco.png',
                          scale: 2.5,
                        ),
                      ),
                      Center(
                        child: Text(
                          "Llena el formulario para hacer uso de la aplicación",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
                        SizedBox(height: 40),
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onPrimary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: <Widget>[
                              _buildDropdownButtonDireccion(
                                context,
                                hintText: "Dirección",
                                items: direcciones,
                                value: direccionSeleccionada,
                                onChanged: (value) {
                                  setState(() {
                                    direccionSeleccionada = value;
                                    subdirecciones = value!.getSubdirecciones();
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
                                    subdireccionSeleccionada = value;
                                    instalaciones = value!.getInstalaciones;
                                  });
                                },
                              ),
                              SizedBox(height: 10),
                              _buildDropdownButtonInstalaciones(
                                context,
                                hintText: "Instalación",
                                items: instalaciones,
                                value: instalacionSeleccionada,
                                onChanged: (value) {
                                  setState(() {
                                    instalacionSeleccionada = value;
                                  });
                                },
                              ),
                              SizedBox(height: 10),
                              _buildTextFormField(
                                context,
                                hintText: "Nombre(s)",
                                validatorText:
                                    'Favor de escribir tu(s) nombre(s)',
                                controllerText: _nombreController,
                              ),
                              _buildTextFormField(
                                context,
                                hintText: "Primer apellido",
                                validatorText:
                                    'Favor de escribir tu primer apellido',
                                controllerText: _primerController,
                              ),
                              _buildTextFormField(
                                context,
                                hintText: "Segundo apellido",
                                validatorText:
                                    'Favor de escribir tu segundo apellido',
                                controllerText: _segundoController,
                              ),
                              _buildTextFormField(
                                context,
                                hintText: "Correo electrónico",
                                validatorText:
                                    'Favor de escribir tu correo electrónico',
                                controllerText: _emailController,
                              ),
                              _buildTextFormField(
                                context,
                                hintText: "Teléfono",
                                validatorText: 'Favor de escribir tu teléfono',
                                controllerText: _telefonoController,
                              ),
                              _buildTextFormField(
                                context,
                                hintText: "Contraseña",
                                obscureText: true,
                                validatorText:
                                    'Favor de escribir tu contraseña',
                                controllerText: _passwordController,
                              ),
                              _buildTextFormField(
                                context,
                                hintText: "Repetir contraseña",
                                obscureText: true,
                                validatorText: 'Favor de repetir tu contraseña',
                                controllerText: _passwordValidatorController,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 40),
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formularioRegistro.currentState!
                                  .validate()) {
                                if (_nombreController.text.length <= 50) {
                                  if (_primerController.text.length <= 30) {
                                    if (_segundoController.text.length <= 30) {
                                      if (_emailController.text.length <= 30) {
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
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                backgroundColor: Theme.of(
                                                  context,
                                                ).colorScheme.tertiaryContainer,
                                                content: Text(
                                                  'Enviando información, validar registro',
                                                ),
                                              ),
                                            );
                                            respuestaRegistro =
                                                await usuarioService
                                                    .registrarUsuario(
                                                      _emailController.text,
                                                      _nombreController.text,
                                                      _primerController.text,
                                                      _segundoController.text,
                                                      _telefonoController.text,
                                                      _passwordController.text,
                                                      'usuario',
                                                      false,
                                                    );
                                            print(
                                              'Respuesta del registro: $respuestaRegistro',
                                            );
                                            if (!respuestaRegistro) {
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
                                                    'Hubo un error al registrar el usuario, por favor intente de nuevo',
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
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .tertiaryContainer,
                                                  content: Text(
                                                    'Usuario registrado correctamente, por favor verifica tu correo electrónico, y espera validación del administrador',
                                                  ),
                                                ),
                                              );
                                              Navigator.pushReplacementNamed(
                                                context,
                                                '/login',
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
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              backgroundColor: Theme.of(
                                                context,
                                              ).colorScheme.tertiaryContainer,
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
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor: Theme.of(
                                              context,
                                            ).colorScheme.tertiaryContainer,
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
                                          duration: const Duration(seconds: 2),
                                          behavior: SnackBarBehavior.floating,
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
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration: const Duration(seconds: 2),
                                        behavior: SnackBarBehavior.floating,
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
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      duration: const Duration(seconds: 2),
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
                            child: const Text('Registrarse'),
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

  Widget _buildDropdownButtonDireccion(
    BuildContext context, {
    required String hintText,
    required List<Direccion> items,
    required Direccion? value,
    required ValueChanged<Direccion?> onChanged,
  }) {
    return DropdownButtonFormField<Direccion>(
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.surface),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
        ),
      ),
      value: value,
      dropdownColor: Theme.of(context).colorScheme.tertiaryContainer,
      items: items.map((Direccion item) {
        return DropdownMenuItem<Direccion>(value: item, child: Text(item.getNombre));
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        /*if (value == null) {
          return 'Por favor selecciona una opción';
        }*/
        return null;
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
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.surface),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
        ),
      ),
      value: value,
      dropdownColor: Theme.of(context).colorScheme.tertiaryContainer,
      items: items.map((Subdireccion item) {
        return DropdownMenuItem<Subdireccion>(value: item, child: Text(item.getNombre));
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
/*if (value == null) {
          return 'Por favor selecciona una opción';
        }*/
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
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.surface),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
        ),
      ),
      value: value,
      dropdownColor: Theme.of(context).colorScheme.tertiaryContainer,
      items: items.map((Instalacion item) {
        return DropdownMenuItem<Instalacion>(value: item, child: Text(item.getNombreInstalacion));
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
                /*if (value == null) {
          return 'Por favor selecciona una opción';
        }*/
        return null;
      },
    );
  }
}
