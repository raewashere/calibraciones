import 'package:calibraciones/dto/dto_equipo.dart';
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

  void _mostrarFormularioFiltro() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              runSpacing: 12,
              children: [
                Text(
                  'Filtrar equipos',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'TAG',
                    prefixIcon: Icon(Icons.label),
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Serie',
                    prefixIcon: Icon(Icons.confirmation_number),
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Tipo de sensor',
                    prefixIcon: Icon(Icons.sensors),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          mensajes.info(context, 'Aplicando filtros...'),
                        );
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.filter_alt),
                      label: const Text('Aplicar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _mostrarFormularioNuevo() {
    ScaffoldMessenger.of(context).showSnackBar(
      mensajes.info(context, 'Abriendo formulario para nuevo equipo...'),
    );
    // TODO: Lógica para navegar o abrir formulario
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _mostrarFormularioNuevo,
        icon: const Icon(Icons.add),
        label: const Text('Agregar'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _cargarEquipos,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
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
                                  backgroundColor:
                                      theme.colorScheme.secondaryContainer,
                                  child: Icon(
                                    Icons.monitor_rounded,
                                    color:
                                        theme.colorScheme.onSecondaryContainer,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      '/detalle_calibracion',
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
    );
  }
}
