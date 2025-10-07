import 'package:calibraciones/dto/dto_equipo.dart';
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
                          SnackBar(
                            content: const Text('Aplicando filtros...'),
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                          ),
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
      SnackBar(
        content: const Text('Abriendo formulario para nuevo equipo...'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
    );
    // TODO: Lógica para navegar o abrir formulario
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Equipos de Calibración'),
        actions: [
          IconButton(
            tooltip: "Filtrar equipos",
            icon: const Icon(Icons.filter_list),
            onPressed: _mostrarFormularioFiltro,
          ),
        ],
      ),
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
                    : GridView.builder(
                        controller: _scrollController,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1, // Cambia a 2 para modo tablet
                              childAspectRatio: 2.8,
                              mainAxisSpacing: 10,
                            ),
                        itemCount: equipos.length,
                        itemBuilder: (context, index) {
                          final equipo = equipos[index];
                          return FadeInUp(
                            duration: const Duration(milliseconds: 400),
                            child: Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            equipo.tagEquipo,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            'Tipo: ${equipo.tipoSensor ?? '—'}',
                                          ),
                                          Text('Marca: ${equipo.marca ?? '—'}'),
                                          Text(
                                            'Modelo: ${equipo.modelo ?? '—'}',
                                          ),
                                          Text(
                                            'Estado: ${equipo.estado ?? '—'}',
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      tooltip: "Ver detalle",
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.tertiary,
                                      icon: const Icon(Icons.zoom_in),
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
