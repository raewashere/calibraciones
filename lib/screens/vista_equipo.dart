import 'package:calibraciones/dto/dto_equipo.dart';
import 'package:calibraciones/models/_tipo_sensor.dart';
import 'package:calibraciones/screens/components/filtros_reporte_modal.dart';
import 'package:calibraciones/screens/components/mensajes.dart';
import 'package:calibraciones/services/equipo_service.dart';
import 'package:calibraciones/services/implementation/equipo_service_impl.dart';
import 'package:calibraciones/services/implementation/tipo_sensor_impl.dart';
import 'package:calibraciones/services/tipo_sensor_service.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart'; // <-- Para animaciones suaves (añádelo a pubspec.yaml)

class VistaEquipo extends StatefulWidget {
  const VistaEquipo({super.key});

  @override
  State<StatefulWidget> createState() => _VistaEquipoState();
}

class _VistaEquipoState extends State<VistaEquipo> {
  final Mensajes mensajes = Mensajes();
  final ScrollController _scrollController = ScrollController();
  final EquipoService _equipoService = EquipoServiceImpl();
  final TipoSensorService _tipoSensorService = TipoSensorServiceImpl();

  List<DtoEquipo> equipos = [];
  bool _isLoading = true;

  List<TipoSensor> _listaTipoSensores = [];
  TipoSensor? tipoSensorSeleccionado;

  final Set<TipoSensor> _opcionesSeleccionadas = <TipoSensor>{};

  @override
  void initState() {
    super.initState();
    _cargarEquipos();
    _cargarSensores();
  }

  Future<void> _cargarEquipos() async {
    final resultado = await _equipoService.obtenerAllEquipos();
    final listaTipoSensores = await _tipoSensorService.obtenerAllTipoSensores();
    setState(() {
      equipos = resultado;
      _listaTipoSensores = listaTipoSensores;
      _isLoading = false;
    });
  }

  Future<void> _cargarSensores() async {
    final listaTipoSensores = await _tipoSensorService.obtenerAllTipoSensores();
    setState(() {
      _listaTipoSensores = listaTipoSensores;
    });
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _cargarEquipos,
              // 1. Reemplaza Padding por un Column
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. Sección Inmóvil de Filtros (ejemplo)
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    /*child: Text(
                      'Filtros de Búsqueda',
                      style: theme.textTheme.titleSmall,
                    ),*/
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Wrap(
                      // Wrap para tener varios filtros horizontales
                      spacing: 8.0,
                      children: [
                        Center(
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.filter),
                            onPressed: mostrarPopUpFiltros,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.secondary,
                              foregroundColor: Theme.of(
                                context,
                              ).colorScheme.onSecondary,
                            ),
                            label: const Text('Filtrar equipos'),
                          ),
                        ),
                      ], // 5. Convertir el Iterable resultante a List<Widget>
                    ),
                  ),
                  // Opcional: Separador visual
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 12.0,
                    ),
                    //child: Divider(),
                  ),

                  // 3. Contenido Desplazable (Lista de Equipos)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 12.0,
                        right: 12.0,
                        bottom: 12.0,
                      ), // Mantenemos el padding, excepto el de arriba
                      child: equipos.isEmpty
                          ? Center(
                              child: Text(
                                'No hay equipos registrados',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            )
                          : ListView.builder(
                              controller: _scrollController,
                              itemCount: equipos.length,
                              itemBuilder: (context, index) {
                                final equipo = equipos[index];
                                return FadeInUp(
                                  duration: const Duration(milliseconds: 400),
                                  child: Card(
                                    // ... el resto del código del Card y ListTile
                                    elevation: 3,
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 12,
                                          ),
                                      leading: CircleAvatar(
                                        backgroundColor: theme
                                            .colorScheme
                                            .secondaryContainer,
                                        child: Icon(
                                          Icons.monitor_rounded,
                                          color: theme
                                              .colorScheme
                                              .onSecondaryContainer,
                                        ),
                                      ),
                                      title: Text(
                                        equipo.tagEquipo,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 4),
                                          Text('Tipo: ${equipo.tipoSensor}'),
                                          Text('Marca: ${equipo.marca}'),
                                          Text('Modelo: ${equipo.modelo}'),
                                          Text('Estado: ${equipo.estado}'),
                                        ],
                                      ),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.zoom_in),
                                        color: theme.colorScheme.tertiary,
                                        tooltip: "Ver detalle",
                                        onPressed: () {
                                          Navigator.pushNamed(
                                            context,
                                            '/detalle_equipo',
                                            arguments: equipo,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildDropdownTipoSensor(
    BuildContext context, {
    required String hintText,
    required List<TipoSensor> items,
    required TipoSensor? value,
    required ValueChanged<TipoSensor?> onChanged,
  }) {
    return DropdownButton<TipoSensor>(
      isExpanded: true,
      value: value,
      items: items.map((TipoSensor item) {
        return DropdownMenuItem<TipoSensor>(
          value: item,
          child: Text(item.nombreTipoSensor),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  void mostrarPopUpFiltros() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return const FiltrosEquiposModal();
      },
    );
  }
}
