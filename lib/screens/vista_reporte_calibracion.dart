import 'package:calibraciones/models/_calibracion_equipo.dart';
import 'package:flutter/material.dart';

class VistaReporteCalibracion extends StatefulWidget {
  const VistaReporteCalibracion({super.key});

  @override
  State<StatefulWidget> createState() => _InfiniteScrollCatalogoState();
}

class _InfiniteScrollCatalogoState extends State<VistaReporteCalibracion> {
  final ScrollController _scrollController = ScrollController();
  final List<CalibracionEquipo> _calibraciones_equipos = [
    CalibracionEquipo(
      1,
      'Certificado 001',
      DateTime(2023, 1, 15),
      DateTime(2024, 1, 15),
      0.01,
      0.02,
      'Observaciones de calibración 001',
      'documento_certificado_001.pdf',
      [],
      'Equipo A',
    ),
    CalibracionEquipo(
      2,
      'Certificado 002',
      DateTime(2023, 2, 20),
      DateTime(2024, 2, 20),
      0.015,
      0.025,
      'Observaciones de calibración 002',
      'documento_certificado_002.pdf',
      [],
      'Equipo B',
    ),
    CalibracionEquipo(
      3,
      'Certificado 003',
      DateTime(2023, 3, 10),
      DateTime(2024, 3, 10),
      0.02,
      0.03,
      'Observaciones de calibración 003',
      'documento_certificado_003.pdf',
      [],
      'Equipo C',
    ),
    // Agrega más calibraciones de ejemplo aquí
  ];
  bool _isLoading = false;
  final int _currentOffset = 0;
  final int _limit = 10;
  final TextEditingController _nombreObraController = TextEditingController();
  final TextEditingController _compositorController = TextEditingController();
  final TextEditingController _comentarioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchMoreObras();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _fetchMoreObras();
      }
    });
  }

  Future<void> _fetchMoreObras() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // Espera el resultado de obtener_catalogo
    //List<CalibracionEquipo> newObras =
    //    await catalogo_controlador.obtener_catalogo(_currentOffset, _limit);
    //print(newObras.length);
    setState(() {
      //_calibraciones_equipos.addAll(newObras);
      //_currentOffset += _limit;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.tertiaryContainer,
                    content: Text('Descargando reporte'),
                  ),
                );
              }, // Icono del botón (puedes cambiarlo)
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              tooltip: 'Descargar',
              child: Icon(Icons.download),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 80,
            child: FloatingActionButton(
              onPressed: () {
                _abrirFormulario(context);
              }, // Icono del botón (puedes cambiarlo)
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              tooltip: 'Filtrar',
              child: Icon(Icons.filter_list),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        controller: _scrollController,
        itemCount: _calibraciones_equipos.length + 1,
        itemBuilder: (context, index) {
          if (index < _calibraciones_equipos.length) {
            final calibracion = _calibraciones_equipos[index];
            return ListTile(
              textColor: Theme.of(context).colorScheme.secondary,
              tileColor: Theme.of(context).colorScheme.onPrimary,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(calibracion.certificadoCalibracion),
                        Text(
                          'Fecha calibración: ${calibracion.fechaCalibracion}',
                        ),
                        Text(
                          'Próxima calibración: ${calibracion.fechaProximaCalibracion}',
                        ),
                        Text('Equipo: ${calibracion.tagEquipo}'),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: "Ver detalle",
                    color: Theme.of(context).colorScheme.tertiary,
                    icon: Icon(
                      Icons.zoom_in,
                    ), // Icono del botón (puedes cambiarlo)
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/detalle_calibracion',
                        arguments: calibracion,
                      );
                    },
                  ),
                ],
              ),
            );
          } else if (_isLoading) {
            return Center(child: CircularProgressIndicator());
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }

  void _abrirFormulario(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          title: Text('Filtrar por'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(decoration: InputDecoration(labelText: 'TAG')),
              TextField(decoration: InputDecoration(labelText: 'SERIE')),
              TextField(decoration: InputDecoration(labelText: 'TIPO')),
              // Agrega más campos según sea necesario
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el formulario
              },
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar( SnackBar(
                  duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.tertiaryContainer,
                  content: Text('Filtrando')));
                // Lógica para guardar los datos del formulario
                Navigator.of(
                  context,
                ).pop(); // Cierra el formulario después de guardar
              },
              child: Text(
                'Guardar',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
