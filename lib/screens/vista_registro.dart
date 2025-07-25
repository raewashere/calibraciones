import 'package:calibraciones/models/_usuario.dart';
import 'package:calibraciones/services/usuario_controlador.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VistaRegistro extends StatefulWidget {
  const VistaRegistro({super.key});

  @override
  State<StatefulWidget> createState() => VistaRegistroState();
}

class VistaRegistroState extends State<VistaRegistro> {
  //final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formularioRegistro = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _primerController = TextEditingController();
  final TextEditingController _segundoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordValidatorController =
      TextEditingController();

  bool validarEmail(String email) {
    final RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
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
                                              const SnackBar(
                                                content: Text(
                                                  'Enviando información, validar registro',
                                                ),
                                              ),
                                            );
                                            Usuario nuevoUsuario =   Usuario(
                                                1,
                                                "correo",
                                                "Raymundo",
                                                "Torres",
                                                "Díaz",
                                                "0000000000",
                                                "0000000000",
                                                "admin",
                                                true,
                                                [],
                                              );
                                            UsuarioControlador
                                            controladorUsuario =
                                                UsuarioControlador();
                                            bool correcto =
                                                await controladorUsuario
                                                    .registraUsuario(
                                                      nuevoUsuario,
                                                    );
                                            if (!correcto) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Hubo un error al registrarte',
                                                  ),
                                                ),
                                              );
                                            } else {
                                              /*_auth
                                                  .createUserWithEmailAndPassword(
                                                      email:
                                                          _emailController.text,
                                                      password:
                                                          _passwordController
                                                              .text);

                                              _auth.currentUser
                                                  ?.sendEmailVerification();*/
                                              Navigator.pushReplacementNamed(
                                                context,
                                                '/login',
                                              );
                                            }
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
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Campo de primer apellido limitado a 30 caracteres',
                                        ),
                                      ),
                                    );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
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
}
