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
      backgroundColor: colors.surface,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: colors.primary,
        iconTheme: IconThemeData(color: colors.onPrimary),
        title: Row(
          children: [
            Image.asset(
              'assets/images/pemex_logo_blanco.png',
              height: 40,
              width: 40,
            ),
            const SizedBox(width: 8),
            Text(
              'Detalle de Calibración',
              style: TextStyle(
                color: colors.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ======== INFORMACIÓN GENERAL =========
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Información de la Calibración",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colors.primary,
                      ),
                    ),
                    const Divider(),
                    const SizedBox(height: 8),
                    _buildInfoRow("Certificado", "12345"),
                    _buildInfoRow("Fecha de calibración", "2023-10-01"),
                    _buildInfoRow("Laboratorio", "Laboratorio XYZ"),
                    _buildInfoRow(
                      "Dirección",
                      "Logística y Salvaguardia Estratégica",
                    ),
                    _buildInfoRow("Subdirección", "Transporte"),
                    _buildInfoRow(
                      "Gerencia",
                      "Transporte, Mantenimiento y Servicio de Ductos",
                    ),
                    _buildInfoRow("Instalación", "ERM Pajaritos"),
                    const SizedBox(height: 12),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Abriendo certificado...'),
                              backgroundColor: colors.tertiaryContainer,
                            ),
                          );
                        },
                        icon: const Icon(Icons.picture_as_pdf),
                        label: const Text('Ver Certificado'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.primary,
                          foregroundColor: colors.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Información de la Calibración",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colors.primary,
                      ),
                    ),
                    const Divider(),
                    const SizedBox(height: 8),
                    _buildInfoRow("TAG", "EQ-12345"),
                    _buildInfoRow("Estado", "Operando"),
                    _buildInfoRow("Marca", "Marca XYZ"),
                    _buildInfoRow("Modelo", "Modelo ABC"),
                    _buildInfoRow("Tipo de medición", "Dinámica"),
                    _buildInfoRow("Tipo de equipo", "Sensor de presión"),
                    _buildInfoRow("Computadora de flujo", "OMNI 3000"),
                    _buildInfoRow("Incertidumbre", "±0.5%"),
                    _buildInfoRow("Intervalo de calibración", "12 meses"),
                    _buildInfoRow("Intervalo de verificación", "6 meses"),

                    const SizedBox(height: 12),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Abriendo certificado...'),
                              backgroundColor: colors.tertiaryContainer,
                            ),
                          );
                        },
                        icon: const Icon(Icons.picture_as_pdf),
                        label: const Text('Ver Certificado'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.primary,
                          foregroundColor: colors.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ======== TABLA DE CORRIDAS =========
            Card(
              color: colors.onPrimary,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Table(
                      border: TableBorder.symmetric(
                        inside: const BorderSide(color: Colors.black, width: 1),
                        outside: const BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                          children: [
                            TableCell(
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(2.0),
                                child: const Text(
                                  'Caudal',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(2.0),
                                child: const Text(
                                  'Caudal',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(2.0),
                                child: const Text(
                                  'Temperatura',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(2.0),
                                child: const Text(
                                  'Presión',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(2.0),
                                child: const Text(
                                  'Meter',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(2.0),
                                child: const Text(
                                  'Frecuencia',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(2.0),
                                child: const Text(
                                  'K Factor',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(2.0),
                                child: const Text(
                                  'K Factor',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(2.0),
                                child: const Text(
                                  'Repetibilidad',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                          children: [
                            TableCell(
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(2.0),
                                child: const Text(
                                  'm3/hr',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(2.0),
                                child: const Text(
                                  'bbl/hr',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(2.0),
                                child: const Text(
                                  '°C',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(2.0),
                                child: const Text(
                                  'kg/cm2',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(2.0),
                                child: const Text(
                                  'Factor',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(2.0),
                                child: const Text(
                                  'Hz',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(2.0),
                                child: const Text(
                                  'Pulsos/m3',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(2.0),
                                child: const Text(
                                  'Pulsos/bbl',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(2.0),
                                child: const Text(
                                  '%',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        /*...(_corridasRegistradas.isNotEmpty
                            ? _corridasRegistradas
                                  .map(
                                    (corrida) => TableRow(
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.tertiaryContainer,
                                      ),
                                      children: [
                                        TableCell(
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text(
                                              corrida.caudalM3Hr.toString(),
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text(
                                              corrida.caudalBblHr.toString(),
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text(
                                              corrida.temperaturaC.toString(),
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.all(2.0),
                                            child: Text(
                                              corrida.presionKgCm2.toString(),
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.all(2.0),
                                            child: Text(
                                              corrida.meterFactor.toString(),
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.all(2.0),
                                            child: Text(
                                              corrida.frecuenciaHz.toString(),
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.all(2.0),
                                            child: Text(
                                              corrida.kFactorPulseM3.toString(),
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.all(2.0),
                                            child: Text(
                                              corrida.kFactorPulseBbl
                                                  .toString(),
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.all(2.0),
                                            child: Text(
                                              corrida.repetibilidad.toString(),
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList()
                            : [
                                TableRow(
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.tertiaryContainer,
                                  ),
                                  children: List.generate(
                                    9,
                                    (index) => Padding(
                                      padding: EdgeInsets.all(2.0),
                                      child: Text(''),
                                    ),
                                  ),
                                ),
                              ]),
                              */
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ======== OBSERVACIONES =========
            Card(
              color: colors.onPrimary,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Observaciones",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colors.primary,
                      ),
                    ),
                    const Divider(),
                    const SizedBox(height: 8),
                    _buildInfoRow("Linealidad", "0.01%"),
                    _buildInfoRow("Reproducibilidad", "0.02%"),
                    const SizedBox(height: 8),
                    Text(
                      "No se encontraron observaciones durante la calibración.",
                      style: TextStyle(fontSize: 16, color: colors.secondary),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// --- Helper para filas de información ---
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              "$label:",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(flex: 6, child: Text(value)),
        ],
      ),
    );
  }
}
