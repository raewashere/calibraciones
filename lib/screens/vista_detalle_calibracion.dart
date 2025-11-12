import 'package:calibraciones/common/barrel/services.dart';
import 'package:calibraciones/common/barrel/models.dart';
import 'package:calibraciones/common/components/components.dart';
import 'package:calibraciones/common/utils/conversiones.dart';
import 'package:calibraciones/models/_ruta_equipo.dart';
import 'package:calibraciones/services/data_service.dart';
import 'package:calibraciones/services/equipo_service.dart';
import 'package:calibraciones/services/implementation/equipo_service_impl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

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
  late LaboratorioCalibracion laboratorio;
  final LaboratorioCalibracionService laboratorioService =
      LaboratorioCalibracionServiceImpl();
  String nombreLaboratorio = '';
  late GraficaCorridas graficaCorridas;
  bool _isDataInitialized = false;
  late Equipo equipo;
  final EquipoService equipoService = EquipoServiceImpl();

  List<FlSpot> spotsKFactor = [];
  List<FlSpot> spotsMeterFactor = [];
  double kFactorMinX = 0;
  double kFactorMaxX = 2000;
  double kFactorMinY = 0;
  double kFactorMaxY = 1;
  double meterFactorMinX = 0;
  double meterFactorMaxX = 2000;
  double meterFactorMinY = 0;
  double meterFactorMaxY = 1;

  DataService dataService = DataService();
  late Future<List<Direccion>> _futureDirecciones;
  RutaEquipo? rutaEquipo;

  @override
  void initState() {
    super.initState();
    recuperaJSON();
  }

  void recuperaJSON() async {
    // Aquí puedes implementar la lógica para recuperar el JSON si es necesario
    _futureDirecciones = DataService().updateAndCacheData();
    rutaEquipo = buscarRutaAscendente(
      await _futureDirecciones,
      calibracionEquipo.tagEquipo,
    );
  }

  // 💡 USAMOS didChangeDependencies
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // 💡 IMPORTANTE: Nos aseguramos de inicializar los datos UNA SOLA VEZ
    // (ya que didChangeDependencies puede ser llamado varias veces).
    if (!_isDataInitialized) {
      final args = ModalRoute.of(context)!.settings.arguments;
      if (args != null) {
        // Asignación directa: No necesitamos setState() porque esto se ejecuta ANTES del primer build
        calibracionEquipo = args as CalibracionEquipo;
        corridasAPuntos();
        graficaCorridas = GraficaCorridas(
          spotsKFactor: spotsKFactor,
          spotsMeterFactor: spotsMeterFactor,
          kFactorMaxX: kFactorMaxX,
          kFactorMinX: kFactorMinX,
          kFactorMaxY: kFactorMaxY,
          kFactorMinY: kFactorMinY,
          meterFactorMaxX: meterFactorMaxX,
          meterFactorMinX: meterFactorMinX,
          meterFactorMaxY: meterFactorMaxY,
          meterFactorMinY: meterFactorMinY,
        );

        buscarLaboratorio();
        buscarEquipo();

        _isDataInitialized = true; // Marcamos como inicializado
      }
    }
  }

  Future<void> buscarEquipo() async {
    final resultado = await equipoService.obtenerEquipoPorId(
      calibracionEquipo.tagEquipo,
    );
    setState(() {
      equipo = resultado;
    });
  }

  Future<void> buscarLaboratorio() async {
    final resultado = await laboratorioService.obtenerLaboratorioPorId(
      calibracionEquipo.idLaboratorioCalibracion,
    );
    setState(() {
      laboratorio = resultado;
    });
  }

  void corridasAPuntos() {
    spotsKFactor = calibracionEquipo.corridas
        .map((corrida) => FlSpot(corrida.caudalM3Hr, corrida.kFactorPulseM3))
        .toList();

    spotsMeterFactor = calibracionEquipo.corridas
        .map((corrida) => FlSpot(corrida.caudalM3Hr, corrida.meterFactor))
        .toList();

    // 💡 Implementar manejo de lista vacía
    if (spotsKFactor.isEmpty) {
      kFactorMinX = 0;
      kFactorMaxX = 2000;
      kFactorMinY = 0;
      kFactorMaxY = 1;
      return; // Salir de la función
    }

    // Lógica de límites solo si hay datos
    kFactorMinX = spotsKFactor
        .map((spot) => spot.x)
        .reduce((a, b) => a < b ? a : b);
    kFactorMinX = kFactorMinX - (kFactorMinX * 0.1); // Un 10% menos para margen
    kFactorMaxX = spotsKFactor
        .map((spot) => spot.x)
        .reduce((a, b) => a > b ? a : b);
    kFactorMaxX = kFactorMaxX + (kFactorMaxX * 0.1); // Un 10% más para margen
    kFactorMinY = spotsKFactor
        .map((spot) => spot.y)
        .reduce((a, b) => a < b ? a : b);
    kFactorMinY = kFactorMinY - 1.5; // Un 15% menos para margen
    kFactorMaxY = spotsKFactor
        .map((spot) => spot.y)
        .reduce((a, b) => a > b ? a : b);
    kFactorMaxY = kFactorMaxY + 1.5; // Un 15% más para margen

    meterFactorMinX = kFactorMinX;
    meterFactorMaxX = kFactorMaxX;

    meterFactorMinY = spotsMeterFactor
        .map((spot) => spot.y)
        .reduce((a, b) => a < b ? a : b);
    meterFactorMinY = meterFactorMinY - 0.001;
    meterFactorMaxY = spotsMeterFactor
        .map((spot) => spot.y)
        .reduce((a, b) => a > b ? a : b);
    meterFactorMaxY = meterFactorMaxY + 0.001;
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
                    _buildInfoRow("Laboratorio", laboratorio.nombre),
                    _buildInfoRow(
                      "Dirección",
                      rutaEquipo != null
                          ? rutaEquipo!.direccion.nombre
                          : 'No disponible',
                    ),
                    _buildInfoRow(
                      "Subdirección",
                      rutaEquipo != null
                          ? rutaEquipo!.subdireccion.nombre
                          : 'No disponible',
                    ),
                    _buildInfoRow(
                      "Gerencia",
                      rutaEquipo != null
                          ? rutaEquipo!.gerencia.nombre
                          : 'No disponible',
                    ),
                    _buildInfoRow(
                      "Instalación",
                      rutaEquipo != null
                          ? rutaEquipo!.instalacion.nombreInstalacion
                          : 'No disponible',
                    ),
                    _buildInfoRow(
                      "Patín de medición",
                      rutaEquipo != null
                          ? rutaEquipo!.patin.nombrePatin
                          : 'No disponible',
                    ),
                    _buildInfoRow(
                      "Tren de medición",
                      rutaEquipo != null
                          ? rutaEquipo!.tren.tagTren
                          : 'No disponible',
                    ),
                    _buildInfoRow(
                      "Producto",
                      calibracionEquipo.producto.producto,
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            mensajes.info(context, 'Abriendo certificado...'),
                          );
                          abrirPdf(
                            'https://zkviewvpmswfgpiwpoez.supabase.co/storage/v1/object/public/certificados/${calibracionEquipo.rutaCertificado}',
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
                    _buildInfoRow(
                      "Tipo de sensor",
                      equipo.idTipoSensor.toString(),
                    ),
                    _buildInfoRow("Estado", equipo.estado),
                    _buildInfoRow("Marca", equipo.marca),
                    _buildInfoRow("Modelo", equipo.modelo),
                    _buildInfoRow("Tipo de medición", equipo.tipoMedicion),
                    _buildInfoRow(
                      "Incertidumbre",
                      '± ${equipo.incertidumbre} % ${equipo.magnitudIncertidumbre}',
                    ),
                    //Redondeo de intervalo de calibracion a meses
                    _buildInfoRow(
                      "Intervalo de calibración",
                      '${(equipo.intervaloCalibracion / 30).round()} meses',
                    ),
                    _buildInfoRow(
                      "Intervalo de verificación",
                      '${(equipo.intervaloVerificacion / 30).round()} meses',
                    ),
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
                                            corrida.caudalM3Hr,
                                            2,
                                          ),
                                        ),
                                        tablaCalibracion.celdaTabla(
                                          context,
                                          convertidor.formatoMiles(
                                            corrida.caudalBblHr,
                                            2,
                                          ),
                                        ),
                                        tablaCalibracion.celdaTabla(
                                          context,
                                          convertidor.formatoMiles(
                                            corrida.temperaturaC,
                                            2,
                                          ),
                                        ),
                                        tablaCalibracion.celdaTabla(
                                          context,
                                          convertidor.formatoMiles(
                                            corrida.presionKgCm2,
                                            2,
                                          ),
                                        ),
                                        tablaCalibracion.celdaTabla(
                                          context,
                                          convertidor.formatoMiles(
                                            corrida.meterFactor,
                                            5,
                                          ),
                                        ),
                                        tablaCalibracion.celdaTabla(
                                          context,
                                          convertidor.formatoMiles(
                                            corrida.frecuenciaHz,
                                            2,
                                          ),
                                        ),
                                        tablaCalibracion.celdaTabla(
                                          context,
                                          convertidor.formatoMiles(
                                            corrida.kFactorPulseM3,
                                            3,
                                          ),
                                        ),
                                        tablaCalibracion.celdaTabla(
                                          context,
                                          convertidor.formatoMiles(
                                            corrida.kFactorPulseBbl,
                                            3,
                                          ),
                                        ),
                                        tablaCalibracion.celdaTabla(
                                          context,
                                          convertidor.formatoMiles(
                                            corrida.repetibilidad,
                                            3,
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
                    _buildInfoRow(
                      "Linealidad",
                      '${calibracionEquipo.linealidad}%',
                    ),
                    _buildInfoRow(
                      "Reproducibilidad",
                      '${calibracionEquipo.reproducibilidad}%',
                    ),
                    const SizedBox(height: 8),
                    Text(
                      calibracionEquipo.observaciones.isNotEmpty
                          ? calibracionEquipo.observaciones
                          : 'Ninguna',
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
