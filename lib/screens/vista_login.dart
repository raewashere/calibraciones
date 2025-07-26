import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VistaLogin extends StatefulWidget {
  const VistaLogin({super.key});

  @override
  State<StatefulWidget> createState() => VistaLoginState();
}

class VistaLoginState extends State<VistaLogin> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> prueba() async {
    Navigator.pushReplacementNamed(context, '/inicio');
  }

  Future<void> _signIn() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (_auth.currentUser!.emailVerified) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Bienvenido de nuevo')));

        Navigator.pushReplacementNamed(context, '/inicio');
      } else {
        await _auth.currentUser?.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Aun no has, verificado tu cuenta, revisa el correo que te enviamos',
            ),
          ),
        );
      }

      //print('User signed in: ${userCredential.user?.email}');
    } on FirebaseAuthException catch (e) {
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(mensajeError)));
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
                              decoration: BoxDecoration(
                                border: Border(bottom: BorderSide()),
                              ),
                              child: TextField(
                                controller: _emailController,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Correo electrónico",
                                  hintStyle: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.surface,
                                  ),
                                  border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.tertiary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border(bottom: BorderSide()),
                              ),
                              child: TextField(
                                controller: _passwordController,
                                obscureText: true,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Contraseña",
                                  hintStyle: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.surface,
                                  ),
                                  border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.tertiary,
                                    ),
                                  ),
                                ),
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
