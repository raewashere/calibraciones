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
  //late CalibracionEquipo calibracionEquipo;
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
      equipo.tagEquipo,
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
        equipo = args as Equipo;
        //corridasAPuntos();
        /*graficaCorridas = GraficaCorridas(
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
        );*/

        _isDataInitialized = true; // Marcamos como inicializado
      }
    }
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
              'Detalle de Equipo',
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
                      "Información del equipo",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colors.primary,
                      ),
                    ),
                    const Divider(),
                    const SizedBox(height: 8),
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
                    _buildInfoRow("TAG", equipo.tagEquipo),
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
                    )
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
                      "Gráfica de desviación",
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
