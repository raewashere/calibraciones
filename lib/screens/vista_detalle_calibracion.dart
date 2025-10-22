import 'package:calibraciones/common/barrel/services.dart';
import 'package:calibraciones/common/barrel/models.dart';
import 'package:calibraciones/common/components/components.dart';
import 'package:calibraciones/common/utils/conversiones.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';

class VistaDetalleCalibracion extends StatefulWidget {
  const VistaDetalleCalibracion({super.key});

  @override
  State<StatefulWidget> createState() => VistaDetalleCalibracionState();
}

class VistaDetalleCalibracionState extends State<VistaDetalleCalibracion> {
  final Conversiones convertidor = Conversiones();
  final TablaCalibracion tablaCalibracion = TablaCalibracion();
  final Mensajes mensajes = Mensajes();
  DateFormat formato = DateFormat("dd/MM/yyyy");
  late CalibracionEquipo calibracionEquipo;
  late Future<LaboratorioCalibracion> _laboratorioFuture;
  final LaboratorioCalibracionService laboratorioService =
      LaboratorioCalibracionServiceImpl();

  static const List<FlSpot> datosFlujoKFactor = [
    FlSpot(1127.50, 0.9451),
    FlSpot(1276.08, 0.9450),
    FlSpot(1376.45, 0.9448),
    FlSpot(1468.40, 0.9449),
    FlSpot(1616.42, 0.9442),
    FlSpot(1744.61, 0.9445),
  ];

  // 2. Determinar los límites de los ejes

  // Eje X (Flujo): Mínimo es 1127.50, Máximo es 1744.61
  static const double flujoMin = 1000.0; // Un poco antes del primer punto
  static const double flujoMax = 1800.0; // Un poco después del último punto

  // Eje Y (K Factor): Mínimo es 0.9442, Máximo es 0.9451
  static const double kFactorMin =
      0.9440; // Un valor bajo para que se vea la curva
  static const double kFactorMax = 0.9455; // Un valor alto

  final GraficaCorridas graficaCorridas = const GraficaCorridas(
    spots: datosFlujoKFactor,
    maxX: flujoMax,
    minX: flujoMin,
    maxY: kFactorMax,
    minY: kFactorMin,
  );

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final args = ModalRoute.of(context)!.settings.arguments;
      if (args != null) {
        setState(() {
          calibracionEquipo = args as CalibracionEquipo;
          _laboratorioFuture = laboratorioService.obtenerLaboratorioPorId(
            calibracionEquipo.idLaboratorioCalibracion,
          );
        });
      }
    });
  }

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
                    _buildInfoRow(
                      "Certificado",
                      calibracionEquipo.certificadoCalibracion,
                    ),
                    _buildInfoRow(
                      "Fecha de calibración",
                      formato.format(calibracionEquipo.fechaCalibracion),
                    ),
                    _buildInfoRow(
                      "Laboratorio",
                      _laboratorioFuture.then((lab) => lab.nombre).toString(),
                    ),
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
                            mensajes.info(context, 'Abriendo certificado...'),
                          );
                          abrirPdf(
                            'https://zkviewvpmswfgpiwpoez.supabase.co/storage/v1/object/public/${calibracionEquipo.rutaCertificado}',
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
                      "Información de equipo",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colors.primary,
                      ),
                    ),
                    const Divider(),
                    const SizedBox(height: 8),
                    _buildInfoRow("TAG", calibracionEquipo.tagEquipo),
                    _buildInfoRow("Estado", "Operando"),
                    _buildInfoRow("Marca", "Marca XYZ"),
                    _buildInfoRow("Modelo", "Modelo ABC"),
                    _buildInfoRow("Tipo de medición", "Dinámica"),
                    _buildInfoRow("Tipo de equipo", "Sensor de presión"),
                    _buildInfoRow("Computadora de flujo", "OMNI 3000"),
                    _buildInfoRow("Incertidumbre", "±0.5%"),
                    _buildInfoRow("Intervalo de calibración", "12 meses"),
                    _buildInfoRow("Intervalo de verificación", "6 meses"),
                  ],
                ),
              ),
            ),

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
                      "Gráfica de corridas",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colors.primary,
                      ),
                    ),
                    const Divider(),
                    const SizedBox(height: 12),
                    graficaCorridas,
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
                          decoration: BoxDecoration(color: colors.tertiary),
                          children: [
                            tablaCalibracion.cabeceraTabla(context, 'Caudal'),
                            tablaCalibracion.cabeceraTabla(context, 'Caudal'),
                            tablaCalibracion.cabeceraTabla(
                              context,
                              'Temperatura',
                            ),
                            tablaCalibracion.cabeceraTabla(context, 'Presión'),
                            tablaCalibracion.cabeceraTabla(context, 'Meter'),
                            tablaCalibracion.cabeceraTabla(
                              context,
                              'Frecuencia',
                            ),
                            tablaCalibracion.cabeceraTabla(context, 'K Factor'),
                            tablaCalibracion.cabeceraTabla(context, 'K Factor'),
                            tablaCalibracion.cabeceraTabla(
                              context,
                              'Repetibilidad',
                            ),
                          ],
                        ),
                        TableRow(
                          decoration: BoxDecoration(color: colors.tertiary),
                          children: [
                            tablaCalibracion.cabeceraTabla(context, 'm³/hr'),
                            tablaCalibracion.cabeceraTabla(context, 'bbl/hr'),
                            tablaCalibracion.cabeceraTabla(context, '°C'),
                            tablaCalibracion.cabeceraTabla(context, 'Kg/m2'),
                            tablaCalibracion.cabeceraTabla(context, 'Factor'),
                            tablaCalibracion.cabeceraTabla(context, 'Hz'),
                            tablaCalibracion.cabeceraTabla(
                              context,
                              'Pulsos/m³',
                            ),
                            tablaCalibracion.cabeceraTabla(
                              context,
                              'Pulsos/bbl',
                            ),
                            tablaCalibracion.cabeceraTabla(context, '%'),
                          ],
                        ),
                        ...(calibracionEquipo.corridas.isNotEmpty
                            ? calibracionEquipo.corridas
                                  .map(
                                    (corrida) => TableRow(
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.tertiaryContainer,
                                      ),
                                      children: [
                                        tablaCalibracion.celdaTabla(
                                          context,
                                          convertidor.formatoMiles(
                                            corrida.caudalM3Hr,2
                                          ),
                                        ),
                                        tablaCalibracion.celdaTabla(
                                          context,
                                          convertidor.formatoMiles(
                                            corrida.caudalBblHr,2
                                          ),
                                        ),
                                        tablaCalibracion.celdaTabla(
                                          context,
                                          convertidor.formatoMiles(
                                            corrida.temperaturaC,2
                                          ),
                                        ),
                                        tablaCalibracion.celdaTabla(
                                          context,
                                          convertidor.formatoMiles(
                                            corrida.presionKgCm2,2
                                          ),
                                        ),
                                        tablaCalibracion.celdaTabla(
                                          context,
                                          convertidor.formatoMiles(
                                            corrida.meterFactor,5
                                          ),
                                        ),
                                        tablaCalibracion.celdaTabla(
                                          context,
                                          convertidor.formatoMiles(
                                            corrida.frecuenciaHz,2
                                          ),
                                        ),
                                        tablaCalibracion.celdaTabla(
                                          context,
                                          convertidor.formatoMiles(
                                            corrida.kFactorPulseM3,3
                                          ),
                                        ),
                                        tablaCalibracion.celdaTabla(
                                          context,
                                          convertidor.formatoMiles(
                                            corrida.kFactorPulseBbl,3
                                          ),
                                        ),
                                        tablaCalibracion.celdaTabla(
                                          context,
                                          convertidor.formatoMiles(
                                            corrida.repetibilidad,3
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

  void abrirPdf(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'No se pudo abrir $url';
    }
  }
}
