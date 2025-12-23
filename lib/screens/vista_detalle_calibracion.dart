import 'package:calibraciones/common/barrel/services.dart';
import 'package:calibraciones/common/barrel/models.dart';
import 'package:calibraciones/common/components/components.dart';
import 'package:calibraciones/common/utils/conversiones.dart';
import 'package:calibraciones/models/_ruta_equipo.dart';
import 'package:calibraciones/screens/components/grafica_otros.dart';
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
  late LaboratorioCalibracion? laboratorio;
  final LaboratorioCalibracionService laboratorioService =
      LaboratorioCalibracionServiceImpl();
  String nombreLaboratorio = '';
  late GraficaCorridas graficaCorridas;
  late GraficaOtros graficaOtros;
  late Equipo? equipo;
  final EquipoService equipoService = EquipoServiceImpl();

  bool _isLoading = true;

  List<FlSpot> puntosG1 = [];
  List<FlSpot> puntosG2 = [];
  double minimoXG1 = 0;
  double maximoXG1 = 0;
  double minimoYG1 = 0;
  double maximoYG1 = 0;
  double margenXG1 = 0;
  double margenYG1 = 0;

  double incertidumbreMaxima = 0;

  double minimoXG2 = 0;
  double maximoXG2 = 0;
  double minimoYG2 = 0;
  double maximoYG2 = 1;
  double margenXG2 = 0;
  double margenYG2 = 0;
  DataService dataService = DataService();
  late Future<List<Direccion>> _futureDirecciones;
  RutaEquipo? rutaEquipo;
  int tipoDetalle = 0;

  @override
  void initState() {
    super.initState();
  }

  // 💡 USAMOS didChangeDependencies
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // 1. Carga de argumentos SÍNCRONA (solo si aún estamos cargando)
    if (_isLoading) {
      final args = ModalRoute.of(context)!.settings.arguments;
      if (args != null) {
        calibracionEquipo = args as CalibracionEquipo;

        // 2. Ejecutar la carga ASÍNCRONA
        _cargarDatosIniciales();
      }
    }
  }

  Future<void> _cargarDatosIniciales() async {
    // 💡 Ejecución Asíncrona: Esperamos a que ambos se completen.
    await Future.wait([
      recuperaJSON(),
      buscarLaboratorio(), // Estas funciones ahora solo hacen el fetch, sin setState
      buscarEquipo(),
    ]);

    // 3. Después de que los argumentos y la carga asíncrona están listos,
    //    procedemos al procesamiento de datos y graficación.
    _procesarDatosYGraficas();

    // 4. Finalmente, marcamos que la carga ha terminado.
    setState(() {
      _isLoading = false; // Detenemos la carga
    });
  }

  Future<void> buscarEquipo() async {
    final resultado = await equipoService.obtenerEquipoPorId(
      calibracionEquipo.tagEquipo,
    );
    // Asignación directa, el setState() final se hace en _cargarDatosIniciales
    equipo = resultado;
  }

  Future<void> buscarLaboratorio() async {
    final resultado = await laboratorioService.obtenerLaboratorioPorId(
      calibracionEquipo.idLaboratorioCalibracion,
    );
    // Asignación directa, el setState() final se hace en _cargarDatosIniciales
    laboratorio = resultado;
  }

  Future<void> recuperaJSON() async {
    // Aquí puedes implementar la lógica para recuperar el JSON si es necesario
    _futureDirecciones = DataService().updateAndCacheData();
    rutaEquipo = buscarRutaAscendente(
      await _futureDirecciones,
      calibracionEquipo.tagEquipo,
    );
  }

  void _procesarDatosYGraficas() {
    // Toda la lógica de inicialización de `corridasAPuntos()`, `lecturasAPuntos()` y `graficaOtros`
    // que estaba en didChangeDependencies, va aquí.
    // ...

    if (calibracionEquipo.datosEspecificos is DatosCalibracionFlujo) {
      corridasAPuntos();
      graficaCorridas = GraficaCorridas(
        spotsKFactor: puntosG1,
        spotsMeterFactor: puntosG2,
        kFactorMaxX: maximoXG1,
        kFactorMinX: minimoXG1,
        kFactorMaxY: maximoYG1,
        kFactorMinY: minimoYG1,
        meterFactorMaxX: maximoXG2,
        meterFactorMinX: minimoXG2,
        meterFactorMaxY: maximoYG2,
        meterFactorMinY: minimoYG2,
      );
      tipoDetalle = 1;
    } else if (calibracionEquipo.datosEspecificos
        is DatosCalibracionTemperatura) {
      lecturasAPuntos();
      graficaOtros = GraficaOtros(
        spots: puntosG1,
        maximoX: maximoXG1 + margenXG1,
        minimoX: minimoXG1 - margenXG1,
        maximoY: maximoYG1 + margenYG1,
        minimoY: minimoYG1 - margenYG1,
        tipo: false,
      );

      tipoDetalle = 2;
    } else if (calibracionEquipo.datosEspecificos is DatosCalibracionPresion) {
      lecturasAPuntos();
      graficaOtros = GraficaOtros(
        spots: puntosG1,
        maximoX: maximoXG1 + margenXG1,
        minimoX: minimoXG1 - margenXG1,
        maximoY: maximoYG1 + margenYG1,
        minimoY: minimoYG1 - margenYG1,
        tipo: true,
      );
      tipoDetalle = 3;
    } else if (calibracionEquipo.datosEspecificos is DatosCalibracionDensidad) {
      tipoDetalle = 4;
    }
  }

  void corridasAPuntos() {
    final datosFlujo =
        calibracionEquipo.datosEspecificos as DatosCalibracionFlujo;
    puntosG1 = datosFlujo.corridas
        .map((corrida) => FlSpot(corrida.caudalM3Hr, corrida.kFactorPulseM3))
        .toList();

    puntosG2 = datosFlujo.corridas
        .map((corrida) => FlSpot(corrida.caudalM3Hr, corrida.meterFactor))
        .toList();

    // 💡 Implementar manejo de lista vacía
    if (puntosG1.isEmpty) {
      minimoXG1 = 0;
      maximoXG1 = 2000;
      minimoYG1 = 0;
      maximoYG1 = 1;
      return; // Salir de la función
    }

    // Lógica de límites solo si hay datos
    minimoXG1 = puntosG1.map((spot) => spot.x).reduce((a, b) => a < b ? a : b);
    //Porcentaje simetrico
    margenXG1 = (minimoXG1 * 0.15);
    minimoXG1 = minimoXG1 - margenXG1; // Un 10% menos para margen
    maximoXG1 = puntosG1.map((spot) => spot.x).reduce((a, b) => a > b ? a : b);
    maximoXG1 = maximoXG1 + margenXG1; // Un 10% más para margen
    minimoYG1 = puntosG1.map((spot) => spot.y).reduce((a, b) => a < b ? a : b);

    //Porcentaje simetrico
    margenYG1 = (minimoYG1 * 0.001);
    minimoYG1 = minimoYG1 - margenYG1; // Un 15% menos para margen
    maximoYG1 = puntosG1.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
    maximoYG1 = maximoYG1 + margenYG1; // Un 15% más para margen

    minimoXG2 = minimoXG1;
    maximoXG2 = maximoXG1;

    minimoYG2 = puntosG2.map((spot) => spot.y).reduce((a, b) => a < b ? a : b);
    maximoYG2 = puntosG2.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
    margenYG2 = (minimoYG2 * 0.05);
    minimoYG2 = minimoYG2 - margenYG2;
    margenYG2 = (maximoYG2 * 0.05);
    maximoYG2 = maximoYG2 + margenYG2;
  }

  void lecturasAPuntos() {
    if (calibracionEquipo.datosEspecificos is DatosCalibracionTemperatura) {
      final datos =
          calibracionEquipo.datosEspecificos as DatosCalibracionTemperatura;
      puntosG1 = datos.lecturas
          .map((lectura) => FlSpot(lectura.ibcCelsius, lectura.errorCelsius))
          .toList();

      incertidumbreMaxima = datos.lecturas
          .map((lectura) => lectura.incertidumbreCelsius)
          .reduce((a, b) => a > b ? a : b);
    } else if (calibracionEquipo.datosEspecificos is DatosCalibracionPresion) {
      final datos =
          calibracionEquipo.datosEspecificos as DatosCalibracionPresion;
      puntosG1 = datos.lecturas
          .map((lectura) => FlSpot(lectura.ibcKgCm2, lectura.errorKgCm2))
          .toList();
      incertidumbreMaxima = datos.lecturas
          .map((lectura) => lectura.incertidumbreKgCm2)
          .reduce((a, b) => a > b ? a : b);
    }

    // 💡 Implementar manejo de lista vacía
    //if (puntosG1.isEmpty) {
    minimoXG1 = 0;
    maximoXG1 = 120;
    minimoYG1 = -0.1;
    maximoYG1 = 0.1;
    //  return; // Salir de la función
    //}

    // Lógica de límites solo si hay datos
    minimoXG1 = puntosG1.map((spot) => spot.x).reduce((a, b) => a < b ? a : b);
    maximoXG1 = puntosG1.map((spot) => spot.x).reduce((a, b) => a > b ? a : b);
    margenXG1 = (maximoXG1 * 0.25);
    //minimoXG1 = minimoXG1 - margenXG1;
    //maximoXG1 = maximoXG1 + margenXG1;

    minimoYG1 = puntosG1.map((spot) => spot.y).reduce((a, b) => a < b ? a : b);
    maximoYG1 = puntosG1
        .map((spot) => spot.y)
        .reduce((a, b) => a.abs() > b.abs() ? a : b);
    margenYG1 = (maximoYG1.abs() * 5);
    //minimoYG1 = minimoYG1 - margenYG1;
    //maximoYG1 = maximoYG1 + margenYG1;
  }

  @override
  Widget build(BuildContext context) {
    //Ver como corregir este
    final colors = Theme.of(context).colorScheme;
    if (_isLoading) {
      // 💡 Muestra un indicador de carga si los datos no están listos
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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
                    _buildInfoRow("Laboratorio", laboratorio!.nombre),
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
                      equipo!.tipoSensor.toString(),
                    ),
                    _buildInfoRow("Estado", equipo!.estado),
                    _buildInfoRow("Marca", equipo!.marca),
                    _buildInfoRow("Modelo", equipo!.modelo),
                    _buildInfoRow("Tipo de medición", equipo!.tipoMedicion),
                    _buildInfoRow(
                      "Incertidumbre",
                      '± ${equipo!.incertidumbre} % ${equipo!.magnitudIncertidumbre}',
                    ),
                    //Redondeo de intervalo de calibracion a meses
                    _buildInfoRow(
                      "Intervalo de calibración",
                      '${((equipo!.intervaloCalibracion) / 30).round()} meses',
                    ),
                    _buildInfoRow(
                      "Intervalo de verificación",
                      '${((equipo!.intervaloVerificacion) / 30).round()} meses',
                    ),
                  ],
                ),
              ),
            ),

            (tipoDetalle < 4 && tipoDetalle > 0)
                ? Card(
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
                            (tipoDetalle == 1)
                                ? "Gráfica de corridas"
                                : "Gráfica de lecturas",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: colors.primary,
                            ),
                          ),
                          const Divider(),
                          const SizedBox(height: 12),
                          (tipoDetalle == 1) ? graficaCorridas : graficaOtros,
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink(),

            const SizedBox(height: 16),

            // ======== TABLA DE CORRIDAS =========
            (tipoDetalle < 4 && tipoDetalle > 0)
                ? Card(
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
                            (tipoDetalle == 1)
                                ? "Tabla de Corridas"
                                : (tipoDetalle == 2)
                                ? "Tabla de Lecturas de Temperatura"
                                : "Tabla de Lecturas de Presión",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: colors.primary,
                            ),
                          ),
                          const Divider(),
                          const SizedBox(height: 8),
                          (tipoDetalle == 1)
                              ? buildTablaCorridas(context)
                              : (tipoDetalle == 2)
                              ? buildTablaTemperatura(context)
                              : buildTablaPresion(context),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink(),

            const SizedBox(height: 16),

            // ======== OBSERVACIONES =========
            (tipoDetalle == 1)
                ? buildObservaciones(context)
                : (tipoDetalle == 2 || tipoDetalle == 3)
                ? buildExtras(context)
                : (tipoDetalle == 4)
                ? buildDatosDensidad(context)
                : SizedBox.shrink(),
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

  Widget buildTablaCorridas(BuildContext context) {
    final datosFlujo =
        calibracionEquipo.datosEspecificos as DatosCalibracionFlujo;
    final colors = Theme.of(context).colorScheme;
    return Table(
      border: TableBorder.symmetric(
        inside: const BorderSide(color: Colors.black, width: 1),
        outside: const BorderSide(color: Colors.black, width: 2),
      ),
      children: [
        TableRow(
          decoration: BoxDecoration(color: colors.tertiary),
          children: [
            tablaCalibracion.cabeceraTabla(context, 'Caudal'),
            tablaCalibracion.cabeceraTabla(context, 'Caudal'),
            tablaCalibracion.cabeceraTabla(context, 'Temperatura'),
            tablaCalibracion.cabeceraTabla(context, 'Presión'),
            tablaCalibracion.cabeceraTabla(context, 'Meter'),
            tablaCalibracion.cabeceraTabla(context, 'Frecuencia'),
            tablaCalibracion.cabeceraTabla(context, 'K Factor'),
            tablaCalibracion.cabeceraTabla(context, 'K Factor'),
            tablaCalibracion.cabeceraTabla(context, 'Repetibilidad'),
          ],
        ),
        TableRow(
          decoration: BoxDecoration(color: colors.tertiary),
          children: [
            tablaCalibracion.cabeceraTabla(context, 'm³/hr'),
            tablaCalibracion.cabeceraTabla(context, 'bbl/hr'),
            tablaCalibracion.cabeceraTabla(context, '°C'),
            tablaCalibracion.cabeceraTabla(context, 'kg/cm²'),
            tablaCalibracion.cabeceraTabla(context, 'Factor'),
            tablaCalibracion.cabeceraTabla(context, 'Hz'),
            tablaCalibracion.cabeceraTabla(context, 'Pulsos/m³'),
            tablaCalibracion.cabeceraTabla(context, 'Pulsos/bbl'),
            tablaCalibracion.cabeceraTabla(context, '%'),
          ],
        ),
        ...(datosFlujo.corridas.isNotEmpty
            ? datosFlujo.corridas
                  .map(
                    (corrida) => TableRow(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiaryContainer,
                      ),
                      children: [
                        tablaCalibracion.celdaTabla(
                          context,
                          convertidor.formatoMiles(corrida.caudalM3Hr, 2),
                        ),
                        tablaCalibracion.celdaTabla(
                          context,
                          convertidor.formatoMiles(corrida.caudalBblHr, 2),
                        ),
                        tablaCalibracion.celdaTabla(
                          context,
                          convertidor.formatoMiles(corrida.temperaturaC, 2),
                        ),
                        tablaCalibracion.celdaTabla(
                          context,
                          convertidor.formatoMiles(corrida.presionKgCm2, 2),
                        ),
                        tablaCalibracion.celdaTabla(
                          context,
                          convertidor.formatoMiles(corrida.meterFactor, 5),
                        ),
                        tablaCalibracion.celdaTabla(
                          context,
                          convertidor.formatoMiles(corrida.frecuenciaHz, 2),
                        ),
                        tablaCalibracion.celdaTabla(
                          context,
                          convertidor.formatoMiles(corrida.kFactorPulseM3, 3),
                        ),
                        tablaCalibracion.celdaTabla(
                          context,
                          convertidor.formatoMiles(corrida.kFactorPulseBbl, 3),
                        ),
                        tablaCalibracion.celdaTabla(
                          context,
                          convertidor.formatoMiles(corrida.repetibilidad, 3),
                        ),
                      ],
                    ),
                  )
                  .toList()
            : [
                TableRow(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                  ),
                  children: List.generate(
                    9,
                    (index) =>
                        Padding(padding: EdgeInsets.all(2.0), child: Text('')),
                  ),
                ),
              ]),
      ],
    );
  }

  Widget buildTablaTemperatura(BuildContext context) {
    if (calibracionEquipo.datosEspecificos == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final datosTemperatura =
        calibracionEquipo.datosEspecificos as DatosCalibracionTemperatura;
    final colors = Theme.of(context).colorScheme;
    return Table(
      border: TableBorder.symmetric(
        inside: const BorderSide(color: Colors.black, width: 1),
        outside: const BorderSide(color: Colors.black, width: 2),
      ),
      children: [
        TableRow(
          decoration: BoxDecoration(color: colors.tertiary),
          children: [
            tablaCalibracion.cabeceraTabla(context, 'L. Patrón'),
            tablaCalibracion.cabeceraTabla(context, 'L. Patrón'),
            tablaCalibracion.cabeceraTabla(context, 'L. IBC'),
            tablaCalibracion.cabeceraTabla(context, 'L. IBC'),
            tablaCalibracion.cabeceraTabla(context, 'Error'),
            tablaCalibracion.cabeceraTabla(context, 'Error'),
            tablaCalibracion.cabeceraTabla(context, 'Incertidumbre'),
            tablaCalibracion.cabeceraTabla(context, 'Incertidumbre'),
          ],
        ),
        TableRow(
          decoration: BoxDecoration(color: colors.tertiary),
          children: [
            tablaCalibracion.cabeceraTabla(context, '°C'),
            tablaCalibracion.cabeceraTabla(context, '°F'),
            tablaCalibracion.cabeceraTabla(context, '°C'),
            tablaCalibracion.cabeceraTabla(context, '°F'),
            tablaCalibracion.cabeceraTabla(context, '°C'),
            tablaCalibracion.cabeceraTabla(context, '°F'),
            tablaCalibracion.cabeceraTabla(context, '°C'),
            tablaCalibracion.cabeceraTabla(context, '°F'),
          ],
        ),
        ...(datosTemperatura.lecturas.isNotEmpty
            ? datosTemperatura.lecturas
                  .map(
                    (lectura) => TableRow(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiaryContainer,
                      ),
                      children: [
                        tablaCalibracion.celdaTabla(
                          context,
                          convertidor.formatoMiles(lectura.patronCelsius, 3),
                        ),
                        tablaCalibracion.celdaTabla(
                          context,
                          convertidor.formatoMiles(lectura.patronFahrenheit, 3),
                        ),
                        tablaCalibracion.celdaTabla(
                          context,
                          convertidor.formatoMiles(lectura.ibcCelsius, 3),
                        ),
                        tablaCalibracion.celdaTabla(
                          context,
                          convertidor.formatoMiles(lectura.ibcFahrenheit, 3),
                        ),
                        tablaCalibracion.celdaTabla(
                          context,
                          convertidor.formatoMiles(lectura.errorCelsius, 3),
                        ),
                        tablaCalibracion.celdaTabla(
                          context,
                          convertidor.formatoMiles(lectura.errorFahrenheit, 3),
                        ),
                        tablaCalibracion.celdaTabla(
                          context,
                          convertidor.formatoMiles(
                            lectura.incertidumbreCelsius,
                            3,
                          ),
                        ),
                        tablaCalibracion.celdaTabla(
                          context,
                          convertidor.formatoMiles(
                            lectura.incertidumbreFahrenheit,
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
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                  ),
                  children: List.generate(
                    8,
                    (index) =>
                        Padding(padding: EdgeInsets.all(2.0), child: Text('')),
                  ),
                ),
              ]),
      ],
    );
  }

  Widget buildTablaPresion(BuildContext context) {
    if (calibracionEquipo.datosEspecificos == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final datosPresion =
        calibracionEquipo.datosEspecificos as DatosCalibracionPresion;
    final colors = Theme.of(context).colorScheme;
    return Table(
      border: TableBorder.symmetric(
        inside: const BorderSide(color: Colors.black, width: 1),
        outside: const BorderSide(color: Colors.black, width: 2),
      ),
      children: [
        TableRow(
          decoration: BoxDecoration(color: colors.tertiary),
          children: [
            tablaCalibracion.cabeceraTabla(context, 'Patrón'),
            tablaCalibracion.cabeceraTabla(context, 'Patrón'),
            tablaCalibracion.cabeceraTabla(context, 'Patrón'),
            tablaCalibracion.cabeceraTabla(context, 'IBC'),
            tablaCalibracion.cabeceraTabla(context, 'IBC'),
            tablaCalibracion.cabeceraTabla(context, 'IBC'),
            tablaCalibracion.cabeceraTabla(context, 'Error'),
            tablaCalibracion.cabeceraTabla(context, 'Error'),
            tablaCalibracion.cabeceraTabla(context, 'Error'),
            tablaCalibracion.cabeceraTabla(context, 'Incer.'),
            tablaCalibracion.cabeceraTabla(context, 'Incer.'),
            tablaCalibracion.cabeceraTabla(context, 'Incer.'),
          ],
        ),
        TableRow(
          decoration: BoxDecoration(color: colors.tertiary),
          children: [
            tablaCalibracion.cabeceraTabla(context, 'kg/cm²'),
            tablaCalibracion.cabeceraTabla(context, 'psi'),
            tablaCalibracion.cabeceraTabla(context, 'kPa'),
            tablaCalibracion.cabeceraTabla(context, 'kg/cm²'),
            tablaCalibracion.cabeceraTabla(context, 'psi'),
            tablaCalibracion.cabeceraTabla(context, 'kPa'),
            tablaCalibracion.cabeceraTabla(context, 'kg/cm²'),
            tablaCalibracion.cabeceraTabla(context, 'psi'),
            tablaCalibracion.cabeceraTabla(context, 'kPa'),
            tablaCalibracion.cabeceraTabla(context, 'kg/cm²'),
            tablaCalibracion.cabeceraTabla(context, 'psi'),
            tablaCalibracion.cabeceraTabla(context, 'kPa'),
          ],
        ),
        ...(datosPresion.lecturas.isNotEmpty
            ? datosPresion.lecturas
                  .map(
                    (lectura) => TableRow(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiaryContainer,
                      ),
                      children: [
                        tablaCalibracion.celdaTabla(
                          context,
                          convertidor.formatoMiles(lectura.patronKgCm2, 2),
                        ),
                        tablaCalibracion.celdaTabla(
                          context,
                          convertidor.formatoMiles(lectura.patronPSI, 2),
                        ),
                        tablaCalibracion.celdaTabla(
                          context,
                          convertidor.formatoMiles(lectura.patronkPa, 2),
                        ),

                        tablaCalibracion.celdaTabla(
                          context,
                          convertidor.formatoMiles(lectura.ibcKgCm2, 2),
                        ),
                        tablaCalibracion.celdaTabla(
                          context,
                          convertidor.formatoMiles(lectura.ibcPSI, 2),
                        ),
                        tablaCalibracion.celdaTabla(
                          context,
                          convertidor.formatoMiles(lectura.ibckPa, 2),
                        ),

                        tablaCalibracion.celdaTabla(
                          context,
                          convertidor.formatoMiles(lectura.errorKgCm2, 2),
                        ),
                        tablaCalibracion.celdaTabla(
                          context,
                          convertidor.formatoMiles(lectura.errorPSI, 2),
                        ),
                        tablaCalibracion.celdaTabla(
                          context,
                          convertidor.formatoMiles(lectura.errorkPa, 2),
                        ),

                        tablaCalibracion.celdaTabla(
                          context,
                          convertidor.formatoMiles(
                            lectura.incertidumbreKgCm2,
                            2,
                          ),
                        ),
                        tablaCalibracion.celdaTabla(
                          context,
                          convertidor.formatoMiles(lectura.incertidumbrePSI, 2),
                        ),
                        tablaCalibracion.celdaTabla(
                          context,
                          convertidor.formatoMiles(lectura.incertidumbrekPa, 2),
                        ),
                      ],
                    ),
                  )
                  .toList()
            : [
                TableRow(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                  ),
                  children: List.generate(
                    12,
                    (index) =>
                        Padding(padding: EdgeInsets.all(2.0), child: Text('')),
                  ),
                ),
              ]),
      ],
    );
  }

  Widget buildDatosDensidad(BuildContext context) {
    if (calibracionEquipo.datosEspecificos == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final colors = Theme.of(context).colorScheme;
    final datosEspecificos =
        calibracionEquipo.datosEspecificos as DatosCalibracionDensidad;
    final unidad = equipo!.magnitudIncertidumbre;

    // Función auxiliar (simulando la que usaría el usuario para las filas de datos)
    DataRow buildDataRow(
      String label,
      double valueBefore,
      double valueAfter, {
      bool isKeyMetric = false,
    }) {
      final labelStyle = isKeyMetric
          ? const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange,
            )
          : const TextStyle();

      final valueStyle = isKeyMetric
          ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)
          : const TextStyle(fontSize: 12);

      return DataRow(
        cells: [
          DataCell(Text(label.replaceAll('**', ''), style: labelStyle)),
          DataCell(
            Text(
              "${convertidor.formatoMiles(valueBefore, 3)} $unidad",
              style: valueStyle,
            ),
          ),
          DataCell(
            Text(
              "${convertidor.formatoMiles(valueAfter, 3)} $unidad",
              style: valueStyle.copyWith(
                color: isKeyMetric ? colors.secondary : null,
              ), // Color del tema
            ),
          ),
        ],
      );
    }

    // Lista de DataRow para construir la tabla
    final List<DataRow> rows = [
      buildDataRow(
        "Patrón operación",
        datosEspecificos.lectura.patronOperacion,
        datosEspecificos.lectura.patronCorregidoOperacion,
      ),
      buildDataRow(
        "Patrón referencia",
        datosEspecificos.lectura.patronReferencia,
        datosEspecificos.lectura.patronCorregidoReferencia,
      ),
      buildDataRow(
        "IBC operación",
        datosEspecificos.lectura.ibcOperacion,
        datosEspecificos.lectura.ibcCorregidoOperacion,
      ),
      buildDataRow(
        "IBC referencia",
        datosEspecificos.lectura.ibcReferencia,
        datosEspecificos.lectura.ibcCorregidoReferencia,
      ),
      // Resaltar métricas clave
      buildDataRow(
        "**Error medida**",
        datosEspecificos.lectura.errorReferencia,
        datosEspecificos.lectura.errorCorregidoReferencia,
        isKeyMetric: true,
      ),
      buildDataRow(
        "**Incertidumbre**",
        datosEspecificos.lectura.incertidumbreReferencia,
        datosEspecificos.lectura.incertidumbreCorregidoReferencia,
        isKeyMetric: true,
      ),
    ];

    return Card(
      color: colors.onPrimary,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Lecturas de Densidad",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colors.primary,
              ),
            ),
            const Divider(),
            const SizedBox(height: 8),

            // El widget DataTable
            SizedBox(
              width: double.infinity,
              child: DataTable(
                columnSpacing: 16.0,
                dataRowMinHeight: 30.0,
                dataRowMaxHeight: 40.0,
                headingRowColor: WidgetStateProperty.all(
                  colors.surfaceContainerHighest.withValues(alpha: 0.5),
                ),
                columns: const [
                  DataColumn(
                    label: Text(
                      "Concepto",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Antes",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Después",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                rows: rows,
              ),
            ),

            // --- Aquí se agrega el Factor de Corrección ---
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),

            // Mostrar el Factor de Corrección de forma destacada
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Factor de Corrección Aplicado:",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: colors.tertiary,
                  ),
                ),
                Text(
                  convertidor.formatoMiles(
                    datosEspecificos.lectura.factorCorreccion,
                    6,
                  ), // Muestra más decimales para un factor
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildObservaciones(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      color: colors.onPrimary,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
            _buildInfoRow("Linealidad", '${calibracionEquipo.linealidad}%'),
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
    );
  }

  Widget buildExtras(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      color: colors.onPrimary,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Extras",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colors.primary,
              ),
            ),
            const Divider(),
            const SizedBox(height: 8),
            _buildInfoRow(
              "Error de medida máximo",
              "${convertidor.formatoMiles(maximoYG1, 3)} ${equipo!.magnitudIncertidumbre}",
            ),
            _buildInfoRow(
              "Incertidumbre de medida máximo",
              "${convertidor.formatoMiles(incertidumbreMaxima, 3)} ${equipo!.magnitudIncertidumbre}",
            ),
          ],
        ),
      ),
    );
  }
}
