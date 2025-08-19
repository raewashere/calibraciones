import 'package:calibraciones/dto/dto_direccion.dart';
import 'package:calibraciones/dto/dto_gerencia.dart';
import 'package:calibraciones/dto/dto_instalacion.dart';
import 'package:calibraciones/dto/dto_subdireccion_logistica.dart';
import 'package:calibraciones/models/_usuario.dart';
import 'package:calibraciones/services/direccion_service.dart';
import 'package:calibraciones/services/implementation/direccion_service_impl.dart';
import 'package:calibraciones/services/implementation/usuario_service_impl.dart';
import 'package:calibraciones/services/usuario_service.dart';
import 'package:flutter/material.dart';

class VistaModificacionDatos extends StatefulWidget {
  const VistaModificacionDatos({super.key});

  @override
  State<StatefulWidget> createState() => VistaModificacionDatosState();
}

class VistaModificacionDatosState extends State<VistaModificacionDatos> {
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

  Usuario? usuario;
  UsuarioService usuarioService = UsuarioServiceImpl();

  List<DtoDireccion> direcciones = [];
  DtoDireccion? direccionSeleccionada;

  List<DtoSubdireccionLogistica> subdirecciones = [];
  DtoSubdireccionLogistica? subdireccionSeleccionada;

  List<DtoGerencia> gerencias = [];
  DtoGerencia? gerenciaSeleccionada;

  List<DtoInstalacion> instalaciones = [];
  DtoInstalacion? instalacionSeleccionada;

  DireccionService direccionService = DireccionServiceImpl();

  bool validarEmail(String email) {
    final RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  @override
  void initState() {
    super.initState();
    direccionService.obtenerDireccionRegistro().then((value) {
      setState(() {
        direcciones = [value];
      });
    });
  }

   @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null && args is Usuario) {
      usuario = args; // lo guardas en tu variable
      _nombreController.text = usuario!.nombre;
      _primerController.text = usuario!.primerApellido;
      _segundoController.text = usuario!.segundoApellido;
      _emailController.text = usuario!.correoElectronico;
      _telefonoController.text = usuario!.telefono;
    }
  }

  InputDecoration _inputDecoration(String label) =>
      InputDecoration(labelText: label, border: const OutlineInputBorder());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Modifica tus datos',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
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
                          "Modifica la información que se encuentra en tu perfil",
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
                                                    .actualizarDatosUsuario(
                                                      usuario!.getFolioUsuario,
                                                      _emailController.text,
                                                      _nombreController.text,
                                                      _primerController.text,
                                                      _segundoController.text,
                                                      _telefonoController.text,
                                                      
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
                                                    seconds: 5,
                                                  ),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .tertiaryContainer,
                                                  content: Text(
                                                    'Datos de usuario actualizados correctamente',
                                                  ),
                                                ),
                                              );
                                              Navigator.pushReplacementNamed(
                                                context,
                                                '/inicio',
                                              );
                                            }
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
                            child: const Text('Modificar datos'),
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
      child: TextFormField(
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
      ),
    );
  }
}
