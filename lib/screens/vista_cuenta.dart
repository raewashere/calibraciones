import 'package:calibraciones/models/_usuario.dart';
import 'package:calibraciones/services/implementation/usuario_service_impl.dart';
import 'package:calibraciones/services/usuario_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';

class VistaCuenta extends StatefulWidget {
  const VistaCuenta({super.key});

  @override
  State<StatefulWidget> createState() => VistaCuentaState();
}

class VistaCuentaState extends State<VistaCuenta> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final User? usuarioActual = FirebaseAuth.instance.currentUser;
  final UsuarioService controlador = UsuarioServiceImpl();
  late Future<Usuario?> usuario;
  Usuario? login;
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _primerApellidoController =
      TextEditingController();
  final TextEditingController _segundoApellidoController =
      TextEditingController();

  Future<Usuario?> datosUsuario() async {
    if (usuarioActual == null) {
      return null; // Si no hay usuario actual, retorna null
    }

    // Obtiene los datos del usuario actual
    final data = await controlador.obtenerUsuario(usuarioActual?.email);
    setState(() {
      login = data;
    });
    return data;
  }

  @override
  void initState() {
    super.initState();
    usuario = datosUsuario();
  }

  Future<void> _logout() async {
    try {
      _auth.signOut();
      Navigator.pushReplacementNamed(context, '/login');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Saliendo de la aplicacion")));
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

  Future<void> cambiarContrasenia() async {
    try {
      _auth.sendPasswordResetEmail(email: "${usuarioActual?.email}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Se ha enviado un enlace a tu correo para reestablecer tu contrasenia",
          ),
        ),
      );
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
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              color: Theme.of(context).colorScheme.secondary,
              margin: EdgeInsets.all(16),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ProfilePicture(
                          name:
                              ////Cambiar Raymundo Torres por Cargando...
                              login != null
                              ? '${login?.nombre} ${login?.primerApellido}'
                              : 'Raymundo Torres',
                          radius: 31,
                          fontsize: 21,
                        ),
                        Padding(padding: EdgeInsets.all(5)),
                        //Cambiar Raymundo Torres por Cargando...
                        Text(
                          login != null
                              ? 'Bienvenido ${login?.nombre}'
                              : 'Raymundo Torres',
                          style: TextStyle(
                            fontSize: Theme.of(
                              context,
                            ).textTheme.titleLarge?.fontSize,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(
                          Icons.email,
                          color: Theme.of(
                            context,
                          ).colorScheme.secondaryContainer,
                        ),
                        Padding(padding: EdgeInsets.all(5)),
                        Text(
                          'correo@gmail.com',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSecondary,
                            fontSize: Theme.of(
                              context,
                            ).textTheme.titleMedium?.fontSize,
                          ),
                        ),
                        //Text('${usuarioActual?.email}'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              textColor: Theme.of(context).colorScheme.tertiary,
              leading: Icon(
                Icons.dataset,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                "Gestion de cuenta",
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              subtitle: Text(
                "Modifica tus datos",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              //onTap: _abrirFormularioCambioDatos,
            ),
            ListTile(
              textColor: Theme.of(context).colorScheme.tertiary,
              leading: Icon(
                Icons.password,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                "Recuperar contraseña",
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              onTap: cambiarContrasenia,
            ),
            ListTile(
              textColor: Theme.of(context).colorScheme.tertiary,
              leading: Icon(
                Icons.exit_to_app,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                "Salir",
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              onTap: _logout,
            ),
          ],
        ),
      ),
    );
  }

/*  Future<void> _abrirFormularioCambioDatos() async {
    _nombreController.text = login!.nombre;
    _primerApellidoController.text = login!.primerApellido;
    _segundoApellidoController.text = login!.segundoApellido;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cambio de datos'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Nombre'),
                controller: _nombreController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Primer apellido'),
                controller: _primerApellidoController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Segundo Apellido'),
                controller: _segundoApellidoController,
              ),
              // Agrega más campos según sea necesario
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el formulario
              },
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                login?.nombre = _nombreController.text;
                login?.primerApellido = _primerApellidoController.text;
                login?.segundoApellido = _segundoApellidoController.text;
                UsuarioService controladorUsuario = UsuarioServiceImpl();
                bool correcto = await controladorUsuario.actualizarUsuario(
                  login!,
                );
                if (!correcto) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.tertiaryContainer,
                      content: Text('Hubo un error al actualizar'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.tertiaryContainer,
                      content: Text('Se actualizó correctamente'),
                    ),
                  );
                }
                // Lógica para guardar los datos del formulario
                Navigator.of(
                  context,
                ).pop(); // Cierra el formulario después de guardar
              },
              child: Text(
                'Guardar',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }*/
}
