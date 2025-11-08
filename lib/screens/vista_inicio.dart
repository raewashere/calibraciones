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
  late final List<Widget> vistas;

  @override
  void initState() {
    super.initState();
    vistas = [
      VistaBienvenida(onSeleccion: cambiarVista),
      const VistaRegistroCalibracion(),
      const VistaReporteCalibracion(),
      const VistaEquipo(),
      const VistaCuenta(),
    ];
  }

  void cambiarVista(int nuevaVista) {
    setState(() {
      seleccionActual = nuevaVista;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: colors.onPrimary),
        actionsIconTheme: IconThemeData(color: colors.onPrimary),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/pemex_logo_blanco.png',
                width: 50, height: 50),
            const SizedBox(width: 8),
            Text(
              'Calibraciones',
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
                color: colors.onPrimary,
              ),
            ),
          ],
        ),
        backgroundColor: colors.primary,
      ),

      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.1, 0), // desde la derecha
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: vistas[seleccionActual],
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: colors.onSecondary,
        selectedItemColor: colors.tertiaryContainer,
        backgroundColor: colors.secondary,
        currentIndex: seleccionActual,
        onTap: (value) {
          setState(() {
            seleccionActual = value;
          });
        },
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tune),
            label: 'Registro',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.table_view),
            label: 'Reporte',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monitor_rounded),
            label: 'Equipos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Cuenta',
          ),
        ],
      ),
    );
  }
}
