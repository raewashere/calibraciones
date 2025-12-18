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
  late LaboratorioCalibracion laboratorio;
  final LaboratorioCalibracionService laboratorioService =
      LaboratorioCalibracionServiceImpl();
  String nombreLaboratorio = '';
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

  bool _isLoading = true;

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
        equipo = args as DtoEquipo;

        // 2. Ejecutar la carga ASÍNCRONA
        _cargarDatosIniciales();
      }
    }
  }

  Future<void> _cargarDatosIniciales() async {
    // 💡 Ejecución Asíncrona: Esperamos a que ambos se completen.
    await Future.wait([
      recuperaJSON(),
      buscarEquipo(),
      buscarCalibracionesEquipo(),
    ]);
    setState(() {
      _isLoading = false; // Detenemos la carga
    });
  }

  Future<void> recuperaJSON() async {
    // Aquí puedes implementar la lógica para recuperar el JSON si es necesario
    _futureDirecciones = DataService().updateAndCacheData();
    rutaEquipo = buscarRutaAscendente(
      await _futureDirecciones,
      equipo.tagEquipo,
    );
  }

  Future<void> buscarEquipo() async {
    final resultado = await equipoService.obtenerEquipoPorId(equipo.tagEquipo);
    equipoCompleto = resultado;
  }

  Future<void> buscarCalibracionesEquipo() async {
    // 1. Cargar todas las calibraciones del equipo y guardarlas en el estado.
    final List<CalibracionEquipo> todasLasCalibraciones =
        await calibracionService.obtenerCalibracionesEquipo(equipo.tagEquipo);

    // 2. Guardar la lista COMPLETA de calibraciones del equipo.
    _futureCalibraciones = todasLasCalibraciones;

    // Usamos el Set para extraer productos únicos, como ya lo ajustamos.
    if (equipo.idTipoSensor == 1) {
      final Set<Producto> productosUnicos = todasLasCalibraciones
          .map((c) => c.producto)
          .toSet();
      // 3. Guardar la lista ÚNICA de productos disponibles.
      _listaProductos = productosUnicos.toList();

      // 4. Seleccionar el primer producto si existe.
      if (_listaProductos.isNotEmpty) {
        productoSeleccionado = _listaProductos.first;
      } else {
        productoSeleccionado = null;
      }
    }

    // Opcional: Limpiar las selecciones de checkboxes antiguas
    _calibracionesSeleccionadas.clear();
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

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                            equipoCompleto.getTipoSensor,
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

                  _buildGraficoHistorico(context),

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
    final colors = Theme.of(context).colorScheme;

    for (var calibracion in todasLasCalibraciones) {
      int id = calibracion.idCalibracionEquipo;

      // 1. Filtrado: Solo si el ID de la calibración está marcado como visible
      if (calibracionesVisibles[id] == true) {
        // 2. Mapeo: Convertir la lista de Corridas a una lista de FlSpot
        List<FlSpot> spots = [];
        if (calibracion.datosEspecificos is DatosCalibracionFlujo) {
          final datosFlujo =
              calibracion.datosEspecificos as DatosCalibracionFlujo;
          // Ordenar corridas por caudal para que la linea se dibuje correctamente
          datosFlujo.corridas.sort(
            (a, b) => a.caudalM3Hr.compareTo(b.caudalM3Hr),
          );

          for (int i = 0; i < datosFlujo.corridas.length; i++) {
            final corrida = datosFlujo.corridas[i];
            spots.add(FlSpot(corrida.caudalM3Hr, corrida.meterFactor));
          }
        }

        final color = coloresPuntos[id % coloresPuntos.length];
        final shadowColor =
            coloresPuntosSombras[id % coloresPuntosSombras.length];

        // 3. Generación de la Curva (LineChartBarData)
        lineBarsData.add(
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.2, // Curva suave pero no exagerada
            color: color,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: colors.surface,
                  strokeWidth: 2,
                  strokeColor: shadowColor,
                );
              },
            ),
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

  LineChartBarData generarCurvaDensidad(
    List<CalibracionEquipo> todasLasCalibraciones,
  ) {
    List<FlSpot> spots = [];
    // Sort calibrations by date to ensure proper line drawing
    todasLasCalibraciones.sort(
      (a, b) => a.fechaCalibracion.compareTo(b.fechaCalibracion),
    );

    for (var calibracion in todasLasCalibraciones) {
      final fechaCalibracion = calibracion.fechaCalibracion;
      int anio = fechaCalibracion.year;

      if (calibracion.datosEspecificos is DatosCalibracionDensidad) {
        final datosDensidad =
            calibracion.datosEspecificos as DatosCalibracionDensidad;
        spots.add(
          FlSpot(anio.toDouble(), datosDensidad.lectura.factorCorreccion),
        );
      }
    }

    final colors = Theme.of(context).colorScheme;

    return LineChartBarData(
      spots: spots,
      isCurved: true,
      curveSmoothness: 0.35,
      color: colors.primary,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          return FlDotCirclePainter(
            radius: 4,
            color: colors.surface,
            strokeWidth: 2,
            strokeColor: colors.primary,
          );
        },
      ),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [
            colors.primary.withValues(alpha: 0.2),
            colors.primary.withValues(alpha: 0.0),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  Widget _buildGraficoHistorico(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    if (equipo.idTipoSensor == 1) {
      if (_futureCalibraciones.isEmpty) {
        return Card(
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
                const Text("No hay calibraciones"),
              ],
            ),
          ),
        );
      }
      return Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: colors.shadow.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Gráfica de desviación",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
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
            const SizedBox(height: 16),
            SizedBox(
              height: 400,
              child: LineChart(
                LineChartData(
                  lineBarsData: generarCurvasCorridas(
                    _futureCalibraciones,
                    _calibracionesSeleccionadas,
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: 0.1, // or dynamic based on data
                    verticalInterval: 500, // or dynamic
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: colors.outlineVariant.withValues(alpha: 0.3),
                        strokeWidth: 1,
                        dashArray: [5, 5],
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: colors.outlineVariant.withValues(alpha: 0.3),
                        strokeWidth: 1,
                        dashArray: [5, 5],
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      axisNameWidget: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Caudal',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colors.onSurfaceVariant,
                              ),
                        ),
                      ),
                      axisNameSize: 30,
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        // interval: 500, // Let it be auto or set dynamic
                        getTitlesWidget: (value, meta) {
                          // Show generic numbers, maybe format K/M if large
                          final text = value.toStringAsFixed(0);
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              text,
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(color: colors.onSurfaceVariant),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      axisNameWidget: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'K Factor', // Or Meter Factor depending on what is plotted
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colors.onSurfaceVariant,
                              ),
                        ),
                      ),
                      axisNameSize: 30,
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 45,
                        // interval: 0.02,
                        getTitlesWidget: (value, meta) => Text(
                          value.toStringAsFixed(4), // Precision for factor
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: colors.onSurfaceVariant,
                                fontSize: 10,
                              ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      bottom: BorderSide(color: colors.outlineVariant),
                      left: BorderSide(color: colors.outlineVariant),
                      right: BorderSide.none,
                      top: BorderSide.none,
                    ),
                  ),
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (_) => colors.surfaceContainerHighest,
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((LineBarSpot touchedSpot) {
                          return LineTooltipItem(
                            'Caudal: ${touchedSpot.x.toInt()}\nVal: ${touchedSpot.y.toStringAsFixed(5)}',
                            TextStyle(
                              color: touchedSpot.bar.color ?? colors.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                  minX: _currentMinX,
                  maxX: _currentMaxX,
                  minY: _currentMinY,
                  maxY: _currentMaxY,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      if (equipo.idTipoSensor == 2 || equipo.idTipoSensor == 3) {
        return Container();
      } else {
        if (_futureCalibraciones.isEmpty) {
          return Card(
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
                    "Evolución factor de corrección",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colors.primary,
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 12),
                  const Text("No hay calibraciones"),
                ],
              ),
            ),
          );
        }
        return Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: colors.shadow.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Evolución factor de corrección",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 400,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 0.1,
                      getDrawingHorizontalLine: (value) {
                        // Linea 1.0 distintiva
                        if ((value - 1.0).abs() < 0.001) {
                          return FlLine(
                            color: colors.error.withValues(alpha: 0.5),
                            strokeWidth: 1.5,
                            dashArray: [5, 5],
                          );
                        }
                        return FlLine(
                          color: colors.outlineVariant.withValues(alpha: 0.3),
                          strokeWidth: 1,
                          dashArray: [5, 5],
                        );
                      },
                    ),
                    extraLinesData: ExtraLinesData(
                      horizontalLines: [
                        HorizontalLine(
                          y: 1,
                          color: colors.error,
                          strokeWidth: 1.5,
                          dashArray: const [8, 8],
                          label: HorizontalLineLabel(
                            show: true,
                            alignment: Alignment.topRight,
                            padding: const EdgeInsets.only(right: 5),
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: colors.error,
                                  fontWeight: FontWeight.bold,
                                ),
                            labelResolver: (line) => 'Ref 1.0',
                          ),
                        ),
                      ],
                    ),
                    lineBarsData: [generarCurvaDensidad(_futureCalibraciones)],
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        axisNameWidget: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Año',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colors.onSurfaceVariant,
                                ),
                          ),
                        ),
                        axisNameSize: 30,
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            final text = value.toStringAsFixed(0);
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                text,
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(color: colors.onSurfaceVariant),
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        axisNameWidget: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'Factor',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colors.onSurfaceVariant,
                                ),
                          ),
                        ),
                        axisNameSize: 30,
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 45,
                          interval: 0.1,
                          getTitlesWidget: (value, meta) => Text(
                            value.toStringAsFixed(2),
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: colors.onSurfaceVariant,
                                  fontSize: 10,
                                ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border(
                        bottom: BorderSide(color: colors.outlineVariant),
                        left: BorderSide(color: colors.outlineVariant),
                        right: BorderSide.none,
                        top: BorderSide.none,
                      ),
                    ),
                    lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipColor: (_) => colors.surfaceContainerHighest,
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((LineBarSpot touchedSpot) {
                            return LineTooltipItem(
                              'Año: ${touchedSpot.x.toInt()}\nFactor de corrección: ${touchedSpot.y.toStringAsFixed(4)}',
                              TextStyle(
                                color: colors.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ),
                    minX:
                        _futureCalibraciones.first.fechaCalibracion.year
                            .toDouble() -
                        1,
                    maxX:
                        _futureCalibraciones.last.fechaCalibracion.year
                            .toDouble() +
                        1,
                    minY: 0.8,
                    maxY: 1.20,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    }
  }
}
