import 'package:calibraciones/screens/vista_bienvenida.dart';
import 'package:calibraciones/screens/vista_cuenta.dart';
import 'package:calibraciones/screens/vista_equipo.dart';
import 'package:calibraciones/screens/vista_registro_calibracion.dart';
import 'package:calibraciones/screens/vista_reporte_calibracion.dart';
import 'package:flutter/material.dart';

class VistaInicio extends StatefulWidget {
  const VistaInicio({super.key});

  @override
  State<StatefulWidget> createState() => VistaInicioState();
}

class VistaInicioState extends State<VistaInicio> {
  int seleccionActual = 0;

  final List vistas = [
    VistaBienvenida(),
    VistaRegistroCalibracion(),
    VistaReporteCalibracion(),
    VistaEquipo(),
    VistaCuenta(),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: colors.onPrimary),
        actionsIconTheme: IconThemeData(color: colors.onPrimary),
        title: Row(
          children: [
            Image.asset(
              'assets/images/pemex_logo_blanco.png', // o Image.network(...)
              height: 50,
              width: 50,
            ),
            const SizedBox(width: 8),
            Text(
              'Calibraciones',
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
          ],
        ),
        backgroundColor: colors.primary,
      ),
      body: vistas[seleccionActual],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: colors.primaryContainer,
        backgroundColor: colors.primaryContainer,
        currentIndex: seleccionActual,
        onTap: (value) {
          setState(() {
            seleccionActual = value;
          });
        },
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
            backgroundColor: colors.onPrimary,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tune),
            label: 'Registra calibración',
            backgroundColor: colors.onPrimary,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.table_view),
            label: 'Reporte calibraciones',
            backgroundColor: colors.onPrimary,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monitor_rounded),
            label: 'Equipos',
            backgroundColor: colors.onPrimary,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Cuenta',
            backgroundColor: colors.onPrimary,
          ),
        ],
      ),
    );
  }
}
