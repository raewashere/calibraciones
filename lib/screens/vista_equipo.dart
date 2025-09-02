import 'package:calibraciones/dto/dto_equipo.dart';
import 'package:calibraciones/services/equipo_service.dart';
import 'package:calibraciones/services/implementation/equipo_service_impl.dart';
import 'package:flutter/material.dart';

class VistaEquipo extends StatefulWidget {
  const VistaEquipo({super.key});

  @override
  State<StatefulWidget> createState() => _InfiniteScrollCatalogoState();
}

class _InfiniteScrollCatalogoState extends State<VistaEquipo> {
  final ScrollController _scrollController = ScrollController();
  List<DtoEquipo> equipos = [];
  final bool _isLoading = false;
  EquipoService equipoService = EquipoServiceImpl();

  @override
  void initState() {
    super.initState();
    equipoService.obtenerAllEquipos().then((value) {
      setState(() {
        equipos = value;
      });
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
        itemCount: equipos.length + 1,
        itemBuilder: (context, index) {
          if (index < equipos.length) {
            final equipo = equipos[index];
            return ListTile(
              contentPadding: EdgeInsets.all(12),
              textColor: Theme.of(context).colorScheme.secondary,
              tileColor: Theme.of(context).colorScheme.onPrimary,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(equipo.tagEquipo),
                        Text('Tipo de sensor: ${equipo.tipoSensor}'),
                        Text(
                          'Marca: ${equipo.marca}',
                        ),
                        Text('Modelo: ${equipo.modelo}'),
                        Text(
                          'Estado: ${equipo.estado}',
                        ),
                        
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
                        arguments: equipo,
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.tertiaryContainer,
                    content: Text('Filtrando'),
                  ),
                );
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
