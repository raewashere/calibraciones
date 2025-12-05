import 'package:calibraciones/common/barrel/services.dart';
import 'package:calibraciones/common/barrel/models.dart';
import 'package:calibraciones/common/components/components.dart';
import 'package:calibraciones/common/utils/conversiones.dart';
import 'package:calibraciones/dto/dto_equipo.dart';
import 'package:calibraciones/models/_producto.dart';
import 'package:calibraciones/models/_ruta_equipo.dart';
import 'package:calibraciones/screens/components/limites_grafica.dart';
import 'package:calibraciones/services/data_service.dart';
import 'package:calibraciones/services/equipo_service.dart';
import 'package:calibraciones/services/implementation/equipo_service_impl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VistaDetalleEquipo extends StatefulWidget {
  const VistaDetalleEquipo({super.key});

  @override
  State<StatefulWidget> createState() => VistaDetalleEquipoState();
}

class VistaDetalleEquipoState extends State<VistaDetalleEquipo> {
  final Conversiones convertidor = Conversiones();
  final TablaCalibracion tablaCalibracion = TablaCalibracion();
  final Mensajes mensajes = Mensajes();
  DateFormat formato = DateFormat("dd/MM/yy");
  //late CalibracionEquipo calibracionEquipo;
  late LaboratorioCalibracion laboratorio;
  final LaboratorioCalibracionService laboratorioService =
      LaboratorioCalibracionServiceImpl();
  String nombreLaboratorio = '';
  //late GraficaCorridas graficaCorridas;
  bool _isDataInitialized = false;
  late DtoEquipo equipo;
  late Equipo equipoCompleto;
  final EquipoService equipoService = EquipoServiceImpl();
  final CalibracionService calibracionService = CalibracionServiceImpl();
  late List<CalibracionEquipo> _futureCalibraciones = [];

  final List<Color> coloresPuntos = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.brown,
    Colors.cyan,
    Colors.pink,
    Colors.teal,
    Colors.amber,
  ];

  final List<Color> coloresPuntosSombras = [
    Colors.red.shade700,
    Colors.blue.shade700,
    Colors.green.shade700,
    Colors.orange.shade700,
    Colors.purple.shade700,
    Colors.brown.shade700,
    Colors.cyan.shade700,
    Colors.pink.shade700,
    Colors.teal.shade700,
    Colors.amber.shade700,
  ];

  double _currentMinX = 0;
  double _currentMaxX = 2000;
  double _currentMinY = 0;
  double _currentMaxY = 1;

  DataService dataService = DataService();
  late Future<List<Direccion>> _futureDirecciones;
  RutaEquipo? rutaEquipo;

  List<Producto> _listaProductos = [];
  Producto? productoSeleccionado;

  final Map<int, bool> _calibracionesSeleccionadas = {};

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
        equipo = args as DtoEquipo;
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
        buscarEquipo();
        buscarCalibracionesEquipo();
        _isDataInitialized = true; // Marcamos como inicializado
      }
    }
  }

  Future<void> buscarEquipo() async {
    final resultado = await equipoService.obtenerEquipoPorId(equipo.tagEquipo);
    setState(() {
      equipoCompleto = resultado;
    });
  }

  Future<void> buscarCalibracionesEquipo() async {
    // 1. Cargar todas las calibraciones del equipo y guardarlas en el estado.
    final List<CalibracionEquipo> todasLasCalibraciones =
        await calibracionService.obtenerCalibracionesEquipo(equipo.tagEquipo);

    // Usamos el Set para extraer productos únicos, como ya lo ajustamos.
    final Set<Producto> productosUnicos = todasLasCalibraciones
        .map((c) => c.producto)
        .toSet();

    setState(() {
      // 2. Guardar la lista COMPLETA de calibraciones del equipo.
      _futureCalibraciones = todasLasCalibraciones;

      // 3. Guardar la lista ÚNICA de productos disponibles.
      _listaProductos = productosUnicos.toList();

      // 4. Seleccionar el primer producto si existe.
      if (_listaProductos.isNotEmpty) {
        productoSeleccionado = _listaProductos.first;
      } else {
        productoSeleccionado = null;
      }

      // Opcional: Limpiar las selecciones de checkboxes antiguas
      _calibracionesSeleccionadas.clear();
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
                    _buildInfoRow("TAG", equipo.tagEquipo),
                    _buildInfoRow(
                      "Tipo de sensor",
                      equipoCompleto.idTipoSensor.toString(),
                    ),
                    _buildInfoRow("Estado", equipoCompleto.estado),
                    _buildInfoRow("Marca", equipoCompleto.marca),
                    _buildInfoRow("Modelo", equipoCompleto.modelo),
                    _buildInfoRow(
                      "Tipo de medición",
                      equipoCompleto.tipoMedicion,
                    ),
                    _buildInfoRow(
                      "Incertidumbre",
                      '± ${equipoCompleto.incertidumbre} % ${equipoCompleto.magnitudIncertidumbre}',
                    ),
                    //Redondeo de intervalo de calibracion a meses
                    _buildInfoRow(
                      "Intervalo de calibración",
                      '${(equipoCompleto.intervaloCalibracion / 30).round()} meses',
                    ),
                    _buildInfoRow(
                      "Intervalo de verificación",
                      '${(equipoCompleto.intervaloVerificacion / 30).round()} meses',
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
                      "Ubicación del equipo",
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
                    _buildDropdownButtonProducto(
                      context,
                      hintText: "Producto",
                      items: _listaProductos,
                      value: productoSeleccionado,
                      onChanged: (value) {
                        // Limpiamos las selecciones anteriores
                        // Comentar en caso de querer mantener las selecciones
                        _calibracionesSeleccionadas.clear();

                        setState(() {
                          productoSeleccionado = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildCalibrationsCheckboxes(),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 400,
                      child: LineChart(
                        LineChartData(
                          // LLamada a la nueva función de transformación
                          lineBarsData: generarCurvasCorridas(
                            _futureCalibraciones,
                            _calibracionesSeleccionadas,
                          ),

                          // Configuración de los ejes (TitlesData)
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
                                getTitlesWidget: (value, meta) {
                                  final text = value.toStringAsFixed(0);
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      text,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                },
                                interval: 15, // Mostrar cada número entero
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                // Aumentamos el espacio reservado para las etiquetas con decimales
                                reservedSize: 50,
                                getTitlesWidget: (value, meta) => Text(
                                  value.toStringAsFixed(2),
                                  style: const TextStyle(fontSize: 8),
                                ),
                                interval: 0.02,
                              ),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          // ... otras configuraciones del gráfico (Grid, Border, etc.)
                          gridData: const FlGridData(show: true),
                          borderData: FlBorderData(show: true),

                          /*minX: 1,
                          maxX: 5, // Si asumes que todas tienen 5 corridas*/
                          minX: _currentMinX, // El valor X del primer punto
                          maxX: _currentMaxX, // El valor X máximo
                          minY: _currentMinY, // El valor Y mínimo (K Factor)
                          maxY: _currentMaxY, // El valor Y máximo
                        ),
                      ),
                    ),
                    // graficaCorridas,
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

  InputDecoration _inputDecoration(String label) =>
      InputDecoration(labelText: label, border: const OutlineInputBorder());

  Widget _buildDropdownButtonProducto(
    BuildContext context, {
    required String hintText,
    required List<Producto> items,
    required Producto? value,
    required ValueChanged<Producto?> onChanged,
  }) {
    return DropdownButtonFormField<Producto>(
      isExpanded: true,
      decoration: _inputDecoration(hintText),
      initialValue: value,
      dropdownColor: Theme.of(context).colorScheme.tertiaryContainer,
      items: items.map((Producto item) {
        return DropdownMenuItem<Producto>(
          value: item,
          child: Text(item.getProducto),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null) {
          return 'Por favor selecciona una opción';
        }
        return null;
      },
    );
  }

  Widget _buildCalibrationsCheckboxes() {
    if (productoSeleccionado == null || _futureCalibraciones.isEmpty) {
      return const Center(
        child: Text('Selecciona un producto y carga las calibraciones.'),
      );
    }

    // 1. Filtrar las calibraciones (la lógica de filtrado se mantiene)
    final List<CalibracionEquipo> calibracionesFiltradas = _futureCalibraciones
        .where(
          (cal) => cal.producto.idProducto == productoSeleccionado!.idProducto,
        )
        .toList();

    if (calibracionesFiltradas.isEmpty) {
      return const Center(
        child: Text('No hay calibraciones disponibles para este producto.'),
      );
    }

    // 2. Usar Wrap para colocar los ítems horizontalmente y permitir salto de línea
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 12.0, // Espacio horizontal entre los chips/checkboxes
        runSpacing: 4.0, // Espacio vertical entre las líneas
        children: calibracionesFiltradas.map((calibracion) {
          final int calibracionId = calibracion.idCalibracionEquipo;

          // Inicializar el estado
          if (!_calibracionesSeleccionadas.containsKey(calibracionId)) {
            _calibracionesSeleccionadas[calibracionId] = false;
          }

          // Creamos una Row para el Checkbox y su texto (similar a un chip)
          return Row(
            mainAxisSize: MainAxisSize
                .min, // Crucial para que Row ocupe solo el espacio necesario
            children: [
              Checkbox(
                value: _calibracionesSeleccionadas[calibracionId],
                onChanged: (bool? newValue) {
                  // 3. Actualizar el estado
                  setState(() {
                    _calibracionesSeleccionadas[calibracionId] =
                        newValue ?? false;
                    actualizarLimitesGrafica();
                  });
                },
              ),
              Flexible(
                // Flexible permite que el texto se ajuste si es largo
                child: Text(
                  formato.format(calibracion.fechaCalibracion),
                  overflow: TextOverflow
                      .ellipsis, // Opcional: para manejar textos muy largos
                  style: TextStyle(
                    color:
                        coloresPuntosSombras[calibracion.idCalibracionEquipo %
                            coloresPuntosSombras.length],
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  List<LineChartBarData> generarCurvasCorridas(
    List<CalibracionEquipo> todasLasCalibraciones,
    Map<int, bool> calibracionesVisibles,
  ) {
    List<LineChartBarData> lineBarsData = [];

    for (var calibracion in todasLasCalibraciones) {
      int id = calibracion.idCalibracionEquipo;

      // 1. Filtrado: Solo si el ID de la calibración está marcado como visible
      if (calibracionesVisibles[id] == true) {
        // 2. Mapeo: Convertir la lista de Corridas a una lista de FlSpot
        List<FlSpot> spots = [];
        final datosFlujo = calibracion as DatosCalibracionFlujo;
        // Usamos el index (i) para el Eje X
        for (int i = 0; i < datosFlujo.corridas.length; i++) {
          final corrida = datosFlujo.corridas[i];

          // Eje X: i + 1 (para que las corridas empiecen en el punto 1, no 0)
          // Eje Y: el valor de caudalM3Hr
          spots.add(FlSpot(corrida.caudalM3Hr, corrida.meterFactor));
        }

        // 3. Generación de la Curva (LineChartBarData)
        lineBarsData.add(
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color:
                coloresPuntos[id %
                    coloresPuntos.length], // Ejemplo de color dinámico
            barWidth: 3,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 5,
                  color: coloresPuntosSombras[id % coloresPuntosSombras.length],
                );
              },
            ),
            // Se puede usar 'id' para identificar la curva en la leyenda
            // read the data from 'calibracion.idCalibracionEquipo' for the legend
            // title: 'Calibración $id',
          ),
        );
      }
    }

    return lineBarsData;
  }

  // Dentro de VistaDetalleEquipoState
  void actualizarLimitesGrafica() {
    // 1. Filtrar las calibraciones por Producto (igual que en _buildCalibrationsCheckboxes)
    final List<CalibracionEquipo> calibracionesFiltradasPorProducto =
        _futureCalibraciones
            .where(
              (cal) =>
                  cal.producto.idProducto == productoSeleccionado?.idProducto,
            )
            .toList();

    // 2. Seleccionar el extractor de valor Y (ejemplo K-Factor)
    double yValueSelector(Corrida c) =>
        c.meterFactor; // Puedes cambiar esto según lo que quieras graficar

    final limites = calcularLimitesGrafica(
      todasLasCalibraciones: calibracionesFiltradasPorProducto,
      calibracionesVisibles: _calibracionesSeleccionadas,
      yValueSelector: yValueSelector,
    );

    setState(() {
      _currentMinX = limites.minX;
      _currentMaxX = limites.maxX;
      _currentMinY = limites.minY;
      _currentMaxY = limites.maxY;
      // maxCorridas puede ser útil si el Eje X es el índice de corrida.
    });
  }
}
