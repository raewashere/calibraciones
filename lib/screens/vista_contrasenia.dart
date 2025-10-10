import 'package:calibraciones/services/implementation/usuario_service_impl.dart';
import 'package:calibraciones/services/usuario_service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VistaContrasenia extends StatefulWidget {
  const VistaContrasenia({super.key});

  @override
  State<StatefulWidget> createState() => VistaContraseniaState();
}

class VistaContraseniaState extends State<VistaContrasenia> {
  final SupabaseClient supabase = Supabase.instance.client;
  final _formularioCorreo = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  InputDecoration _inputDecoration(String label) =>
      InputDecoration(labelText: label, border: const OutlineInputBorder());

  UsuarioService usuarioService = UsuarioServiceImpl();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Recupera tu clave',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Form(
        key: _formularioCorreo,
        child: SingleChildScrollView(
          // Envuelve el contenido en SingleChildScrollView
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              children: <Widget>[
                SizedBox(height: 5),
                Padding(
                  padding: EdgeInsets.all(50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Image.asset(
                          'assets/images/pemex_logo_blanco.png',
                          scale: 1.5,
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: Text(
                          "Escribe tu correo electrónico, si está ligado a una cuenta te llegará un enlace para restablecer tu contraseña",
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
                              Container(
                                padding: EdgeInsets.all(10),
                                child: TextFormField(
                                  controller: _emailController,
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                  decoration: _inputDecoration(
                                    "Correo electrónico",
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Favor de escribir tu correo electrónico';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 40),
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ElevatedButton(
                                onPressed: () async {
                                  if (_formularioCorreo.currentState!
                                      .validate()) {
                                    try {
                                      final usuario = await usuarioService
                                          .obtenerUsuario(
                                            _emailController.text,
                                          );
                                      if (usuario == null) {
                                        if (!mounted) return;
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
                                              'No se encontró una cuenta ligada a ${_emailController.text}',
                                            ),
                                          ),
                                        );
                                        return;
                                      }

                                      await supabase.auth.resetPasswordForEmail(
                                        _emailController.text,
                                      );
                                      if (!mounted) return;
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
                                            'Se ha enviado un enlace de recuperación a ${_emailController.text}',
                                          ),
                                        ),
                                      );

                                      Navigator.pushNamed(
                                        context,
                                        '/recuperacion_contrasenia',
                                        arguments: _emailController.text,
                                      );
                                    } on AuthException catch (e) {
                                      if (!mounted) return;
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          duration: const Duration(seconds: 3),
                                          behavior: SnackBarBehavior.floating,
                                          backgroundColor: Theme.of(
                                            context,
                                          ).colorScheme.error,
                                          content: Text('Error: ${e.message}'),
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
                                child: const Text('Enviar PIN de recuperación'),
                              ),
                              const SizedBox(height: 30),
                            ],
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
}
