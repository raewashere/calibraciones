import 'package:calibraciones/dto/dto_equipo.dart';
import 'package:calibraciones/models/_tipo_sensor.dart';
import 'package:calibraciones/screens/components/filtros_equipos_modal.dart';
import 'package:calibraciones/screens/components/mensajes.dart';
import 'package:calibraciones/services/equipo_service.dart';
import 'package:calibraciones/services/implementation/equipo_service_impl.dart';
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

  List<DtoEquipo> equipos = [];
  bool _isLoading = true;


  @override
  void initState() {
    super.initState();
    _cargarEquipos();
  }

  Future<void> _cargarEquipos() async {
    final resultado = await _equipoService.obtenerAllEquipos();
    setState(() {
      equipos = resultado;
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
                          child: Row(
                            children: [
                              ElevatedButton.icon(
                                icon: Icon(Icons.filter_list),
                                onPressed: () {
                                  _cargarEquipos();
                                  mostrarPopUpFiltros();
                                },
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
                              const SizedBox(width: 10),
                              ElevatedButton.icon(
                                icon: Icon(Icons.filter_list_off),
                                onPressed: () {
                                  _cargarEquipos();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.secondary,
                                  foregroundColor: Theme.of(
                                    context,
                                  ).colorScheme.onSecondary,
                                ),
                                label: const Text('Quitar filtros'),
                              ),
                            ],
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

  void mostrarPopUpFiltros() async {
    //_cargarEquipos();

    final resultados = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        // Retorna el widget que contiene tus filtros
        return const FiltrosEquiposModal();
      },
    );

    if (resultados != null && resultados is Map<String, dynamic>) {
      // Procesa los resultados de los filtros aquí
      String tagFiltro = resultados['tag'] ?? '';
      Set<TipoSensor> sensoresFiltro =
          resultados['sensores'] as Set<TipoSensor>? ?? <TipoSensor>{};
      Set<String> estadosFiltro =
          resultados['estados'] as Set<String>? ?? <String>{};

      // Aplica los filtros a la lista de equipos
      setState(() {
        equipos = equipos.where((equipo) {
          final cumpleTag =
              tagFiltro.isEmpty ||
              equipo.tagEquipo.toLowerCase().contains(tagFiltro.toLowerCase());
          final cumpleSensor =
              sensoresFiltro.isEmpty ||
              sensoresFiltro.any(
                (sensor) =>
                    sensor.nombreTipoSensor.toLowerCase() ==
                    equipo.tipoSensor.toLowerCase(),
              );
          final cumpleEstado =
              estadosFiltro.isEmpty ||
              estadosFiltro.any(
                (estado) => estado.toLowerCase() == equipo.estado.toLowerCase(),
              );
          return cumpleTag && cumpleSensor && cumpleEstado;
        }).toList();
      });
    }
  }
}
