import 'dart:async';

import 'package:calibraciones/screens/components/mensajes.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/services.dart';

class VistaRecuperacionContrasenia extends StatefulWidget {
  const VistaRecuperacionContrasenia({super.key});

  @override
  State<VistaRecuperacionContrasenia> createState() =>
      _VistaRecuperacionContraseniaState();
}

class _VistaRecuperacionContraseniaState
    extends State<VistaRecuperacionContrasenia> {
  final Mensajes mensajes = Mensajes();
  final _formKey = GlobalKey<FormState>();
  final _tokenController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final supabase = Supabase.instance.client;

  String email = '';
  bool _obscureText = true;

  bool _showButton = false;
  bool _isLoading = false;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _iniciarCooldown(); // espera inicial de 60s al cargar la vista
  }

  void _iniciarCooldown() {
    setState(() => _showButton = false);

    _timer?.cancel(); // cancelar si hay un timer previo
    _timer = Timer(const Duration(seconds: 60), () {
      if (mounted) {
        setState(() => _showButton = true);
      }
    });
  }

  Future<void> _reenviarPin() async {
    setState(() => _isLoading = true);

    await supabase.auth.resetPasswordForEmail(email);

    if (!mounted) return;
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(mensajes.info(context, 'Reenviando nuevo PIN'));

    // reiniciar cooldown después de usar el botón
    _iniciarCooldown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _updatePassword() async {
    if (_tokenController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(mensajes.error(context, 'El token no puede estar vacío'));
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await supabase.auth.verifyOTP(
        type: OtpType.recovery, // para recuperación de contraseña
        token: _tokenController.text,
        email: email, // el email del usuario
      );

      // Token is valid, proceed to update password
      await supabase.auth.updateUser(
        UserAttributes(password: _passwordController.text),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        mensajes.info(context, 'Contraseña actualizada con éxito'),
      );
      Navigator.pushReplacementNamed(context, '/login');
      // Show success message
    } on AuthException catch (e) {
      if (mounted) {
        if (e.message.contains("old")) {
          _reenviarPin();
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            mensajes.error(
              context,
              'La contraseña nueva no puede ser la misma que la anterior',
            ),
          );
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(mensajes.error(context, 'Error: ${e.message}'));
        }
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null && args is String) {
      email = args; // lo guardas en tu variable
    }
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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: Text(
          'Restablecer contraseña',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            color: colorScheme.primary,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/pemex_logo_blanco.png',
                        scale: 1.5,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Escribe el token que recibiste por correo y tu nueva contraseña",
                        style: TextStyle(
                          color: colorScheme.onPrimary,
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _tokenController,
                        keyboardType: TextInputType.number, // teclado numérico
                        inputFormatters: [
                          FilteringTextInputFormatter
                              .digitsOnly, // solo dígitos
                          LengthLimitingTextInputFormatter(
                            6,
                          ), // máximo 6 caracteres
                        ],
                        decoration: _inputDecoration("Token"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa el token';
                          }
                          if (value.length != 6) {
                            return 'Debe tener exactamente 6 dígitos';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        decoration: _inputDecorationPassword(
                          'Nueva contraseña',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa la nueva contraseña';
                          }
                          if (value.length < 6) {
                            return 'Debe tener al menos 6 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureText,
                        decoration: _inputDecorationPassword(
                          'Confirmar contraseña',
                        ),
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return 'Las contraseñas no coinciden';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _updatePassword,
                        child: _isLoading
                            ? CircularProgressIndicator()
                            : Text(
                                'Actualizar contraseña',
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSecondary,
                                ),
                              ),
                      ),
                      const SizedBox(height: 20),

                      //MOSTRAR 60 SEGUNDOS DESPUES
                      _showButton
                          ? ElevatedButton(
                              onPressed: () async {
                                _reenviarPin();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  mensajes.info(
                                    context,
                                    'Reenviando nuevo PIN',
                                  ),
                                );
                              },
                              child: _isLoading
                                  ? CircularProgressIndicator()
                                  : Text(
                                      'Reenviar PIN de recuperación',
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSecondary,
                                      ),
                                    ),
                            )
                          : const Text(
                              "Espere 60 segundos para reenviar el PIN",
                            ),
                    ],
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
