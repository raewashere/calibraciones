import 'package:flutter/material.dart';

class VistaBienvenida extends StatelessWidget {
  const VistaBienvenida({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16),
            ListTile(
              textColor: Theme.of(context).colorScheme.tertiary,
              leading: Icon(
                Icons.pallet,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                "Bienvenido",
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              subtitle: Text(
                "Gestiona equipo de medición y registra sus calibraciones",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            SizedBox(height: 16),
            ListTile(
              textColor: Theme.of(context).colorScheme.tertiary,
              leading: Icon(
                Icons.tune,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                "Registro de calibraciones",
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              subtitle: Text(
                "Registra calibraciones de los equipos de medición",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/registro_calibracion');
              },
            ),
            SizedBox(height: 16),
            ListTile(
              textColor: Theme.of(context).colorScheme.tertiary,
              leading: Icon(
                Icons.table_view,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                "Reporte de calibraciones",
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              subtitle: Text(
                "Accede a información de calibraciones previas",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/reporte_calibraciones');
              },
            ),
            SizedBox(height: 16),
            ListTile(
              textColor: Theme.of(context).colorScheme.tertiary,
              leading: Icon(
                Icons.stacked_bar_chart,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                "Equipo de medición",
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              subtitle: Text(
                "Modifica información sobre los equipos de medición",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/equipos');
              }
            ),
            SizedBox(height: 16),
            ListTile(
              textColor: Theme.of(context).colorScheme.tertiary,
              leading: Icon(
                Icons.account_circle,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                "Cuenta",
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              subtitle: Text(
                "Actualiza contraseña y otros datos",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/cuenta');
              }
            ),
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
