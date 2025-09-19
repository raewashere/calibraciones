import 'package:calibraciones/screens/components/tabla_calibracion.dart';
import 'package:flutter/material.dart';

class VistaDetalleCalibracion extends StatefulWidget {
  const VistaDetalleCalibracion({super.key});

  @override
  State<StatefulWidget> createState() => VistaDetalleCalibracionState();
}

class VistaDetalleCalibracionState extends State<VistaDetalleCalibracion> {
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
              'Detalle de Calibración',
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
          ],
        ),
        backgroundColor: colors.primary,
      ),
      backgroundColor: colors.onPrimary,
      body: SingleChildScrollView(
        child: Container(
          width: double.maxFinite,
          decoration: BoxDecoration(color: colors.secondary),
          child: Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: colors.secondaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: colors.onPrimary,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                      bottomLeft: Radius.circular(60),
                      bottomRight: Radius.circular(60),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 15),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              "Información de la Calibración",
                              style: TextStyle(
                                fontSize: 20,
                                color: colors.tertiary,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              "Certificado de calibración: 12345",
                              style: TextStyle(
                                fontSize: 16,
                                color: colors.secondary,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              "Fecha de calibración: 2023-10-01",
                              style: TextStyle(
                                fontSize: 16,
                                color: colors.secondary,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              "Laboratorio de calibración: Laboratorio XYZ",
                              style: TextStyle(
                                fontSize: 16,
                                color: colors.secondary,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              "Direccion: Logistica y Salvaguardia Estrategica",
                              style: TextStyle(
                                fontSize: 16,
                                color: colors.secondary,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              "Subdireccion: Transporte",
                              style: TextStyle(
                                fontSize: 16,
                                color: colors.secondary,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              "Gerencia: Transporte, Mantenimiento y Servicio de Ductos",
                              style: TextStyle(
                                fontSize: 16,
                                color: colors.secondary,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              "Instalación: ERM Pajaritos",
                              style: TextStyle(
                                fontSize: 16,
                                color: colors.secondary,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () {
                                // Aquí puedes agregar la lógica para descargar el certificado
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: const Duration(seconds: 2),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.tertiaryContainer,
                                    content: Text('Abriendo certificado...'),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.primary,
                              ),
                              child: Text(
                                'Ver Certificado',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        // Aquí puedes agregar más widgets para mostrar los detalles de la calibración
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: colors.onPrimary,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                      bottomLeft: Radius.circular(60),
                      bottomRight: Radius.circular(60),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 15),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              "Equipo Calibrado",
                              style: TextStyle(
                                fontSize: 20,
                                color: colors.tertiary,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              "TAG del equipo: EQ-12345",
                              style: TextStyle(
                                fontSize: 16,
                                color: colors.secondary,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              "Estado del equipo: Operando",
                              style: TextStyle(
                                fontSize: 16,
                                color: colors.secondary,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              "Marca del equipo: Marca XYZ",
                              style: TextStyle(
                                fontSize: 16,
                                color: colors.secondary,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              "Modelo del equipo: Modelo ABC",
                              style: TextStyle(
                                fontSize: 16,
                                color: colors.secondary,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              "Tipo de medición: Dinámica",
                              style: TextStyle(
                                fontSize: 16,
                                color: colors.secondary,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              "Tipo de equipo: Sensor de presión",
                              style: TextStyle(
                                fontSize: 16,
                                color: colors.secondary,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              "Computadora de flujo: OMNI 3000",
                              style: TextStyle(
                                fontSize: 16,
                                color: colors.secondary,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              "Incertidumbre de medición: ±0.5%",
                              style: TextStyle(
                                fontSize: 16,
                                color: colors.secondary,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              "Intervalo de calibración: 12 meses",
                              style: TextStyle(
                                fontSize: 16,
                                color: colors.secondary,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              "Intervalo de verificación: 6 meses",
                              style: TextStyle(
                                fontSize: 16,
                                color: colors.secondary,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        // Aquí puedes agregar más widgets para mostrar los detalles de la calibración
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: colors.onPrimary,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                      bottomLeft: Radius.circular(60),
                      bottomRight: Radius.circular(60),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 15),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              "Corridas de Calibración",
                              style: TextStyle(
                                fontSize: 20,
                                color: colors.tertiary,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Center(),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Center(),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Center(),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Center(),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: colors.onPrimary,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                      bottomLeft: Radius.circular(60),
                      bottomRight: Radius.circular(60),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 15),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              "Observaciones",
                              style: TextStyle(
                                fontSize: 20,
                                color: colors.tertiary,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              "Lineablidad: 0.01%",
                              style: TextStyle(
                                fontSize: 16,
                                color: colors.secondary,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              "Reproducibilidad: 0.02%",
                              style: TextStyle(
                                fontSize: 16,
                                color: colors.secondary,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              "No se encontraron observaciones durante la calibración.",
                              style: TextStyle(
                                fontSize: 16,
                                color: colors.secondary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Aquí puedes agregar más widgets para mostrar los detalles de la calibración
              ],
            ),
          ),
        ),
      ),
    );
  }
}
