import 'package:animate_do/animate_do.dart';
import 'package:calibraciones/models/_calibracion_equipo.dart';
import 'package:calibraciones/services/calibracion_service.dart';
import 'package:calibraciones/services/implementation/calibracion_service_impl.dart';
import 'package:flutter/material.dart';

class VistaReporteCalibracion extends StatefulWidget {
  const VistaReporteCalibracion({super.key});

  @override
  State<VistaReporteCalibracion> createState() =>
      _VistaReporteCalibracionState();
}

class _VistaReporteCalibracionState extends State<VistaReporteCalibracion> {
  final ScrollController _scrollController = ScrollController();
  List<CalibracionEquipo> calibracionesEquipos = [];
  final CalibracionService calibracionService = CalibracionServiceImpl();
  bool _isLoading = false;
  int _currentOffset = 0;
  final int _limit = 10;

  @override
  void initState() {
    super.initState();
    _fetchMoreCalibraciones();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _fetchMoreCalibraciones();
      }
    });
  }

  Future<void> _fetchMoreCalibraciones() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);
    final nuevas = await calibracionService.obtenerCalibracionesEquipo(
      _currentOffset,
      _limit,
    );

    setState(() {
      calibracionesEquipos.addAll(nuevas);
      _currentOffset += _limit;
      _isLoading = false;
    });
  }

  Future<void> _refresh() async {
    setState(() {
      _currentOffset = 0;
      calibracionesEquipos.clear();
    });
    await _fetchMoreCalibraciones();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      floatingActionButton: _botonesAccion(context),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(12),
          itemCount: calibracionesEquipos.length + (_isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= calibracionesEquipos.length) {
              return const Padding(
                padding: EdgeInsets.all(20),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final calibracion = calibracionesEquipos[index];
            return FadeInUp(
              duration: const Duration(milliseconds: 400),
              child: Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: theme.colorScheme.secondaryContainer,
                    child: Icon(
                      Icons.build,
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                  ),
                  title: Text(
                    calibracion.certificadoCalibracion,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text('Equipo: ${calibracion.tagEquipo}'),
                      Text('Fecha: ${calibracion.fechaCalibracion}'),
                      Text('Próxima: ${calibracion.fechaProximaCalibracion}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.zoom_in),
                    color: theme.colorScheme.tertiary,
                    tooltip: "Ver detalle",
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/detalle_calibracion',
                        arguments: calibracion,
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _botonesAccion(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: "btnDescargar",
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
                backgroundColor: theme.colorScheme.primaryContainer,
                content: const Text('Descargando reporte...'),
              ),
            );
          },
          backgroundColor: theme.colorScheme.primaryContainer,
          child: const Icon(Icons.download),
        ),
        const SizedBox(height: 12),
        FloatingActionButton(
          heroTag: "btnFiltrar",
          onPressed: () => _abrirFormulario(context),
          backgroundColor: theme.colorScheme.secondaryContainer,
          child: const Icon(Icons.filter_list),
        ),
      ],
    );
  }

  void _abrirFormulario(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: theme.colorScheme.surfaceContainer,
          title: Text(
            'Filtrar Calibraciones',
            style: TextStyle(color: theme.colorScheme.primary),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              SizedBox(height: 8),
              TextField(decoration: InputDecoration(labelText: 'TAG')),
              SizedBox(height: 8),
              TextField(decoration: InputDecoration(labelText: 'SERIE')),
              SizedBox(height: 8),
              TextField(decoration: InputDecoration(labelText: 'TIPO')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancelar',
                style: TextStyle(color: theme.colorScheme.secondary),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Aplicando filtro...')));
              },
              child: const Text('Aplicar'),
            ),
          ],
        );
      },
    );
  }
}
