import 'package:calibraciones/models/_usuario.dart';
import 'package:calibraciones/screens/components/mensajes.dart';
import 'package:calibraciones/services/implementation/usuario_service_impl.dart';
import 'package:calibraciones/services/usuario_service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VistaLogin extends StatefulWidget {
  const VistaLogin({super.key});

  @override
  State<StatefulWidget> createState() => VistaLoginState();
}

class VistaLoginState extends State<VistaLogin> {
  final Mensajes mensajes = Mensajes();
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  UsuarioService usuarioService = UsuarioServiceImpl();

  Future<void> prueba() async {
    Navigator.pushReplacementNamed(context, '/inicio');
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

  Future<void> _signIn() async {
    try {
      Usuario? usuario = await usuarioService.obtenerUsuario(
        _emailController.text,
      );
      if (usuario?.getVerificacionAdmin == false) {
        ScaffoldMessenger.of(context).showSnackBar(
          mensajes.info(
            context,
            'Tu cuenta está en revisión por un administrador',
          ),
        );
        return;
      }

      final AuthResponse res = await supabase.auth.signInWithPassword(
        password: _passwordController.text,
        email: _emailController.text,
      );

      if (!mounted) return;
      //final Session? session = res.session;
      final User? user = res.user;
      //Navigator.pushReplacementNamed(context, '/inicio');

      if (user != null && user.emailConfirmedAt != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(mensajes.info(context, 'Bienvenido'));

        Navigator.pushReplacementNamed(context, '/inicio');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          mensajes.info(context, 'Por favor verifica tu correo electrónico'),
        );
      }

      //print('User signed in: ${userCredential.user?.email}');
    } on AuthException catch (e) {
      String mensajeError;

      // Verificar el tipo de error
      if (e.code == 'user-not-found') {
        mensajeError = 'No existe una cuenta con este correo electrónico.';
      } else if (e.code == 'wrong-password') {
        mensajeError = 'La contraseña es incorrecta.';
      } else if (e.code == 'invalid-email') {
        mensajeError = 'El correo electrónico no tiene un formato válido.';
      } else {
        if (e.code == 'unconfirmed-email') {
          mensajeError = 'Por favor verifica tu correo electrónico';
        } else {
          mensajeError =
              'Error al iniciar sesión. Por favor, inténtelo de nuevo.';
        }
      }
      // Mostrar un SnackBar con el mensaje de error
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(mensajes.error(context, mensajeError));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: theme.colorScheme.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 10,
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/pemex_logo_blanco.png',
                      width: 120,
                      height: 120,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Calibraciones",
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Registro y gestión de calibraciones de equipos de medición",
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      offset: const Offset(0, 6),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10),

                    TextField(
                      controller: _emailController,
                      style: TextStyle(color: theme.colorScheme.primary),
                      decoration: _inputDecoration("Correo electrónico"),
                    ),
                    const SizedBox(height: 20),

                    TextField(
                      controller: _passwordController,
                      obscureText: _obscureText,
                      style: TextStyle(color: theme.colorScheme.primary),
                      decoration: _inputDecorationPassword("Contraseña"),
                    ),

                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/contrasenia');
                        },
                        child: Text(
                          "¿Olvidaste tu contraseña?",
                          style: TextStyle(
                            color: theme.colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    ElevatedButton(
                      onPressed: _signIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.secondary,
                        foregroundColor: theme.colorScheme.onSecondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('Iniciar sesión'),
                    ),
                    const SizedBox(height: 20),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/registro');
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: theme.colorScheme.secondary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: Text(
                        'Registrarse',
                        style: TextStyle(color: theme.colorScheme.secondary),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
