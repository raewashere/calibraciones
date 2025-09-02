import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VistaLogin extends StatefulWidget {
  const VistaLogin({super.key});

  @override
  State<StatefulWidget> createState() => VistaLoginState();
}

class VistaLoginState extends State<VistaLogin> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  Future<void> prueba() async {
    Navigator.pushReplacementNamed(context, '/inicio');
  }

  InputDecoration _inputDecoration(String label) =>
      InputDecoration(labelText: label, border: const OutlineInputBorder());

    InputDecoration _inputDecorationPassword(String label) =>
      InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      );

  Future<void> _signIn() async {
    try {
      final AuthResponse res = await supabase.auth.signInWithPassword(
        password: _passwordController.text,
        email: _emailController.text,
      );

      if (!mounted) return;
      //final Session? session = res.session;
      final User? user = res.user;
      //Navigator.pushReplacementNamed(context, '/inicio');

      if (user != null && user.emailConfirmedAt != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bienvenido de nuevo'),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
          ),
        );

        Navigator.pushReplacementNamed(context, '/inicio');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
            content: Text('Por favor verifica tu correo electrónico'),
          ),
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
        mensajeError =
            'Error al iniciar sesión. Por favor, inténtelo de nuevo.';
      }
      // Mostrar un SnackBar con el mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
          content: Text(mensajeError),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
        child: SingleChildScrollView(
          // Envuelve en SingleChildScrollView
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
                    Center(
                      child: Text(
                        "Calibraciones",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 36,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Text(
                        "Registro de calibraciones equipos de medición",
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
                              child: TextField(
                                controller: _emailController,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                decoration: _inputDecoration(
                                  "Correo electrónico",
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: TextField(
                                controller: _passwordController,
                                obscureText: _obscureText,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                decoration: _inputDecorationPassword("Contraseña"),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40),
                      TextButton(
                        child: Text(
                          "¿Olvidaste tu contraseña?",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/contrasenia');
                        },
                      ),
                      SizedBox(height: 40),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ElevatedButton(
                              onPressed: _signIn,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.secondary,
                                foregroundColor: Theme.of(
                                  context,
                                ).colorScheme.onSecondary,
                              ),
                              child: const Text('Iniciar sesion'),
                            ),
                            const SizedBox(height: 30),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/registro');
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
    );
  }
}
