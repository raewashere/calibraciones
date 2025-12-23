import 'package:animate_do/animate_do.dart';
import 'package:calibraciones/models/_calibracion_equipo.dart';
import 'package:calibraciones/models/_usuario.dart';
import 'package:calibraciones/screens/components/filtros_calibraciones_modal.dart';
import 'package:calibraciones/screens/components/mensajes.dart';
import 'package:calibraciones/services/calibracion_service.dart';
import 'package:calibraciones/services/implementation/calibracion_service_impl.dart';
import 'package:calibraciones/services/implementation/usuario_service_impl.dart';
import 'package:calibraciones/services/usuario_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VistaReporteCalibracion extends StatefulWidget {
  const VistaReporteCalibracion({super.key});

  @override
  State<VistaReporteCalibracion> createState() =>
      _VistaReporteCalibracionState();
}

class _VistaReporteCalibracionState extends State<VistaReporteCalibracion> {
  final UsuarioService usuarioService = UsuarioServiceImpl();
  final DateFormat formato = DateFormat("dd/MM/yyyy");
  final Mensajes mensajes = Mensajes();
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
    final nuevas = await calibracionService.obtenerCalibracionesAll(
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
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
                          icon: Icon(Icons.filter_list),
                          onPressed: () {
                            _refresh();
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
                      ),
                    ], // 5. Convertir el Iterable resultante a List<Widget>
                  ),
                ),
                // Opcional: Separador visual
                const Padding(
                  padding: EdgeInsets.only(
                    left: 12.0,
                    right: 12.0,
                    bottom: 12.0,
                  ),
                  //child: Divider(),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: calibracionesEquipos.isEmpty
                        ? Center(
                            child: Text('No hay calibraciones registradas'),
                          )
                        : RefreshIndicator(
                            onRefresh: _refresh,
                            child: ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.all(12),
                              itemCount:
                                  calibracionesEquipos.length +
                                  (_isLoading ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index >= calibracionesEquipos.length) {
                                  return const Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }

                                final calibracion = calibracionesEquipos[index];
                                return FadeInUp(
                                  duration: const Duration(milliseconds: 400),
                                  child: Card(
                                    borderOnForeground: true,
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
                                          Icons.build,
                                          color: theme
                                              .colorScheme
                                              .onSecondaryContainer,
                                        ),
                                      ),
                                      title: Text(
                                        calibracion.certificadoCalibracion,
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: theme.colorScheme.primary,
                                            ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 4),
                                          Text(
                                            'Equipo: ${calibracion.tagEquipo}',
                                          ),
                                          Text(
                                            'Fecha: ${formato.format(calibracion.fechaCalibracion)}',
                                          ),
                                          Text(
                                            'Próxima: ${formato.format(calibracion.fechaProximaCalibracion)}',
                                          ),
                                          FutureBuilder<Usuario>(
                                            future: usuarioService
                                                .obtenerUsuarioPorId(
                                                  calibracion.idUsuario,
                                                ),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return CircularProgressIndicator();
                                              } else if (snapshot.hasError) {
                                                return Text(
                                                  'Error: ${snapshot.error}',
                                                );
                                              } else {
                                                final usuario = snapshot.data;
                                                return Text(
                                                  'Registró : ${usuario?.nombre} ${usuario?.primerApellido} ${usuario?.segundoApellido}',
                                                );
                                              }
                                            },
                                          ),
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
                  ),
                ),
              ],
            ),
    );
  }

  void mostrarPopUpFiltros() async {
    final resultados = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return const FiltrosCalibracionesModal();
      },
    );

    if (resultados != null && resultados is Map<String, dynamic>) {
      // Procesar los resultados del filtro
      String tag = resultados['tag'] ?? '';
      String certificado = resultados['certificado'] ?? '';
      DateTime? fechaCertificado = resultados['fecha_certificado'];

      // Aquí puedes usar estos valores para filtrar la lista de calibraciones
      setState(() {
        calibracionesEquipos = calibracionesEquipos.where((calibracion) {
          final cumpleTag =
              tag.isEmpty ||
              calibracion.tagEquipo.toLowerCase().contains(tag.toLowerCase());
          final cumpleCertificado =
              certificado.isEmpty ||
              calibracion.certificadoCalibracion.toLowerCase().contains(
                certificado.toLowerCase(),
              );
          final cumpleFecha =
              fechaCertificado == null ||
              calibracion.fechaCalibracion == fechaCertificado;

          return cumpleTag && cumpleCertificado && cumpleFecha;
        }).toList();
      });
    }
  }
}
