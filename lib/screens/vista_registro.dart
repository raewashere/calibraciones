import 'package:calibraciones/dto/dto_direccion.dart';
import 'package:calibraciones/dto/dto_gerencia.dart';
import 'package:calibraciones/dto/dto_instalacion.dart';
import 'package:calibraciones/dto/dto_subdireccion_logistica.dart';
import 'package:calibraciones/screens/components/mensajes.dart';
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
  final Mensajes mensajes = Mensajes();
  final _formularioRegistro = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _primerController = TextEditingController();
  final TextEditingController _segundoController = TextEditingController();
  final TextEditingController _fichaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordValidatorController =
      TextEditingController();
  bool respuestaRegistro = false;
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

  bool _obscureText = true;

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

  InputDecoration _inputDecoration(String label) =>
      InputDecoration(labelText: label, border: const OutlineInputBorder());

  InputDecoration _inputDecorationPassword(String label) => InputDecoration(
    labelText: label,
    border: const OutlineInputBorder(),
    suffixIcon: IconButton(
      icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
      onPressed: () {
        setState(() {
          _obscureText = !_obscureText;
        });
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Elabora tu registro',
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
                          scale: 1.5,
                        ),
                      ),
                      Center(
                        child: Text(
                          "Llena el formulario para hacer uso de la aplicación",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 16,
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
                                    subdirecciones = value!
                                        .getSubdireccionesLogisticas();
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
                                    gerencias = value!.getGerencias();
                                  });
                                },
                              ),
                              SizedBox(height: 10),
                              _buildDropdownButtonGerencia(
                                context,
                                hintText: "Gerencia",
                                items: gerencias,
                                value: gerenciaSeleccionada,
                                onChanged: (value) {
                                  setState(() {
                                    gerenciaSeleccionada = value;
                                    instalaciones = value!.getInstalaciones();
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
                                validator: (value) {
                                  if (value == null || value.isEmpty)
                                    return 'Este campo es obligatorio';
                                  if (value.length > 50)
                                    return 'Máximo 50 caracteres';
                                  return null;
                                },
                              ),
                              _buildTextFormField(
                                context,
                                hintText: "Primer apellido",
                                validatorText:
                                    'Favor de escribir tu primer apellido',
                                controllerText: _primerController,
                                validator: (value) {
                                  if (value == null || value.isEmpty)
                                    return 'Este campo es obligatorio';
                                  if (value.length > 30)
                                    return 'Máximo 30 caracteres';
                                  return null;
                                },
                              ),
                              _buildTextFormField(
                                context,
                                hintText: "Segundo apellido",
                                validatorText:
                                    'Favor de escribir tu segundo apellido',
                                controllerText: _segundoController,
                                validator: (value) {
                                  if (value == null || value.isEmpty)
                                    return 'Este campo es obligatorio';
                                  if (value.length > 30)
                                    return 'Máximo 30 caracteres';
                                  return null;
                                },
                              ),
                              _buildTextFormField(
                                context,
                                hintText: "Ficha empleado",
                                validatorText:
                                    'Favor de escribir tu ficha de empleado',
                                controllerText: _fichaController,
                                validator: (value) {
                                  if (value == null || value.isEmpty)
                                    return 'Este campo es obligatorio';
                                  if (value.length > 10)
                                    return 'Máximo 10 caracteres';
                                  return null;
                                },
                              ),
                              _buildTextFormField(
                                context,
                                hintText: "Correo electrónico",
                                validatorText:
                                    'Favor de escribir tu correo electrónico',
                                controllerText: _emailController,
                                validator: (value) {
                                  if (value == null || value.isEmpty)
                                    return 'El campo no puede estar vacío';
                                  if (value.length > 30)
                                    return 'Máximo 30 caracteres';
                                  if (!_esEmailValido(value))
                                    return 'Correo inválido';
                                  return null;
                                },
                              ),
                              _buildTextFormField(
                                context,
                                hintText: "Teléfono",
                                validatorText: 'Favor de escribir tu teléfono',
                                controllerText: _telefonoController,
                                validator: (value) {
                                  if (value == null || value.isEmpty)
                                    return 'Este campo es obligatorio';
                                  if (value.length > 10)
                                    return 'Máximo 10 caracteres';
                                  return null;
                                },
                              ),
                              _buildTextFormFieldPassword(
                                context,
                                hintText: "Contraseña",
                                obscureText: _obscureText,
                                validatorText:
                                    'Favor de escribir tu contraseña',
                                controllerText: _passwordController,
                              ),
                              _buildTextFormFieldPassword(
                                context,
                                hintText: "Repetir contraseña",
                                obscureText: _obscureText,
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
                              if (!_validarFormulario(context)) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                mensajes.info(
                                  context,
                                  'Enviando información, por favor espera...',
                                ),
                              );

                              final respuesta = await usuarioService
                                  .registrarUsuario(
                                    _fichaController.text,
                                    _emailController.text,
                                    _nombreController.text,
                                    _primerController.text,
                                    _segundoController.text,
                                    _telefonoController.text,
                                    _passwordController.text,
                                    direccionSeleccionada!.getNombreDireccion(),
                                    subdireccionSeleccionada!
                                        .getNombreSubdireccion(),
                                    gerenciaSeleccionada!.getNombreGerencia(),
                                    instalacionSeleccionada!.getIdInstalacion(),
                                    instalacionSeleccionada!
                                        .getNombreInstalacion(),
                                  );

                              if (!mounted) return;

                              if (!respuesta) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  mensajes.error(
                                    context,
                                    'Error al registrar el usuario. Intente nuevamente.',
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  mensajes.info(
                                    context,
                                    'Usuario registrado correctamente. Revisa tu correo.',
                                  ),
                                );

                                Navigator.pushReplacementNamed(
                                  context,
                                  '/login',
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.secondary,
                              foregroundColor: Theme.of(
                                context,
                              ).colorScheme.onSecondary,
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 30,
                              ),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
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
    String? Function(String?)? validator,
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

  Widget _buildTextFormFieldPassword(
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
        decoration: _inputDecorationPassword(hintText),
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
    required List<DtoDireccion> items,
    required DtoDireccion? value,
    required ValueChanged<DtoDireccion?> onChanged,
  }) {
    return DropdownButtonFormField<DtoDireccion>(
      isExpanded: true,
      decoration: _inputDecoration(hintText),
      value: value,
      dropdownColor: Theme.of(context).colorScheme.tertiaryContainer,
      items: items.map((DtoDireccion item) {
        return DropdownMenuItem<DtoDireccion>(
          value: item,
          child: Text(item.getNombreDireccion()),
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

  Widget _buildDropdownButtonSubdireccion(
    BuildContext context, {
    required String hintText,
    required List<DtoSubdireccionLogistica> items,
    required DtoSubdireccionLogistica? value,
    required ValueChanged<DtoSubdireccionLogistica?> onChanged,
  }) {
    return DropdownButtonFormField<DtoSubdireccionLogistica>(
      isExpanded: true,
      decoration: _inputDecoration(hintText),
      value: value,
      dropdownColor: Theme.of(context).colorScheme.tertiaryContainer,
      items: items.map((DtoSubdireccionLogistica item) {
        return DropdownMenuItem<DtoSubdireccionLogistica>(
          value: item,
          child: Text(item.getNombreSubdireccion()),
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
    required List<DtoGerencia> items,
    required DtoGerencia? value,
    required ValueChanged<DtoGerencia?> onChanged,
  }) {
    return DropdownButtonFormField<DtoGerencia>(
      isExpanded: true,
      decoration: _inputDecoration(hintText),
      value: value,
      dropdownColor: Theme.of(context).colorScheme.tertiaryContainer,
      items: items.map((DtoGerencia item) {
        return DropdownMenuItem<DtoGerencia>(
          value: item,
          child: Text(item.getNombreGerencia()),
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
    required List<DtoInstalacion> items,
    required DtoInstalacion? value,
    required ValueChanged<DtoInstalacion?> onChanged,
  }) {
    return DropdownButtonFormField<DtoInstalacion>(
      isExpanded: true,
      decoration: _inputDecoration(hintText),
      value: value,
      dropdownColor: Theme.of(context).colorScheme.tertiaryContainer,
      items: items.map((DtoInstalacion item) {
        return DropdownMenuItem<DtoInstalacion>(
          value: item,
          child: Text(item.getNombreInstalacion()),
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

  bool _esEmailValido(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  bool _validarFormulario(BuildContext context) {
    if (!_formularioRegistro.currentState!.validate()) return false;

    if (_passwordController.text != _passwordValidatorController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(mensajes.error(context, 'Las contraseñas no coinciden'));
      return false;
    }

    if (!_esEmailValido(_emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        mensajes.error(context, 'El correo electrónico no es válido'),
      );
      return false;
    }

    return true;
  }
}
