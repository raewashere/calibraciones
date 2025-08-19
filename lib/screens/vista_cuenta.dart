import 'package:calibraciones/dto/dto_instalacion.dart';
import 'package:calibraciones/models/_usuario.dart';
import 'package:calibraciones/services/implementation/instalacion_service_impl.dart';
import 'package:calibraciones/services/implementation/usuario_service_impl.dart';
import 'package:calibraciones/services/instalacion_service.dart';
import 'package:calibraciones/services/usuario_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VistaCuenta extends StatefulWidget {
  const VistaCuenta({super.key});

  @override
  State<StatefulWidget> createState() => VistaCuentaState();
}

class VistaCuentaState extends State<VistaCuenta> {
  final SupabaseClient supabase = Supabase.instance.client;
  final User? usuarioActual = Supabase.instance.client.auth.currentUser;
  final UsuarioService controlador = UsuarioServiceImpl();
  final InstalacionService servicioInstalacion = InstalacionServiceImpl();
  Usuario? login;
  DtoInstalacion? instalacion;

  Future<void> datosUsuario() async {
    if (usuarioActual == null) {
      return; // Si no hay usuario actual, retorna
    }

    // Obtiene los datos del usuario actual
    final data = await controlador.obtenerUsuario(usuarioActual?.email);

    setState(() {
      login = data;
    });

    final instalacionData = await servicioInstalacion.obtenerInstalacionPorId(
      login?.idInstalacion ?? 0,
    );
    setState(() {
      instalacion = instalacionData;
    });

    print(instalacion.toString());
  }

  @override
  void initState() {
    super.initState();
    datosUsuario();
  }

  Future<void> _logout() async {
    try {
      supabase.auth.signOut();
      Navigator.pushReplacementNamed(context, '/login');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
          content: Text("Saliendo de la aplicacion"),
        ),
      );
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

  Future<void> cambiarContrasenia() async {
    await supabase.auth.resetPasswordForEmail(usuarioActual!.email!);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
          content: Text(
            'PIN de recuperación enviado a ${usuarioActual!.email!}',
          ),
        ),
      );
      Navigator.pushNamed(
        context,
        '/recuperacion_contrasenia',
        arguments: login?.correoElectronico,
      );
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
                              login != null
                              ? '${login?.nombre} ${login?.primerApellido}'
                              : '',
                          radius: 31,
                          fontsize: 21,
                        ),
                        Padding(padding: EdgeInsets.all(5)),
                        Text(
                          login != null
                              ? 'Bienvenido ${login?.nombre}'
                              : 'Cargando...',
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
                          '${login?.correoElectronico}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSecondary,
                            fontSize: Theme.of(
                              context,
                            ).textTheme.titleMedium?.fontSize,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Theme.of(
                            context,
                          ).colorScheme.secondaryContainer,
                        ),
                        Padding(padding: EdgeInsets.all(5)),
                        Expanded(
                          child: Text(
                            instalacion?.getNombreInstalacion() ?? 'Cargando...',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontSize: Theme.of(
                                context,
                              ).textTheme.titleMedium?.fontSize,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
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
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/modificacion_datos',
                  arguments: login,
                );
              },
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
}
