import 'package:calibraciones/models/_tipo_sensor.dart';
import 'package:calibraciones/services/implementation/tipo_sensor_impl.dart';
import 'package:calibraciones/services/tipo_sensor_service.dart';
import 'package:flutter/material.dart';

class FiltrosEquiposModal extends StatefulWidget {
  const FiltrosEquiposModal({super.key});

  @override
  State<FiltrosEquiposModal> createState() => _FiltrosEquiposModalState();
}

class _FiltrosEquiposModalState extends State<FiltrosEquiposModal> {
  DateTime? _fechaInicio;

  final TipoSensorService _tipoSensorService = TipoSensorServiceImpl();

  List<TipoSensor> _listaTipoSensores = [];
  TipoSensor? tipoSensorSeleccionado;

  final Set<TipoSensor> _opcionesSensoresSeleccionadas = <TipoSensor>{};

  List<String> _listaEstados = ['Operando', 'Fuera de operacion'];
  final TextEditingController _tagController = TextEditingController();

  final Set<String> _opcionesEstadoSeleccionados = <String>{};

  @override
  void initState() {
    super.initState();
    _cargarSensores();
  }

  Future<void> _cargarSensores() async {
    final listaTipoSensores = await _tipoSensorService.obtenerAllTipoSensores();
    setState(() {
      _listaTipoSensores = listaTipoSensores;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.5,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Opciones de filtro',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Divider(),
            const SizedBox(width: 10),
            Text('TAG', style: Theme.of(context).textTheme.bodyMedium),
            _buildTextFormField(
              context,
              hintText: "TAG",
              controllerText: _tagController,
            ),
            const SizedBox(width: 10),
            Text(
              'Tipo de transmisor',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(width: 10),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Wrap(
                // Wrap para tener varios filtros horizontales
                spacing: 8.0,
                children: _listaTipoSensores.map(
                  (TipoSensor opcion) {
                    // 2. Crear el FilterChip
                    return FilterChip(
                      label: Text(opcion.nombreTipoSensor),
                      selected: _opcionesSensoresSeleccionadas.contains(
                        opcion,
                      ), // 3. Leer estado
                      // 4. Lógica de selección/deselección
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            _opcionesSensoresSeleccionadas.add(
                              opcion,
                            ); // Agregar si se selecciona
                          } else {
                            _opcionesSensoresSeleccionadas.remove(
                              opcion,
                            ); // Remover si se deselecciona
                          }
                          // Opcional: print(_opcionesSensoresSeleccionadas);
                        });
                      },
                    );
                  },
                ).toList(), // 5. Convertir el Iterable resultante a List<Widget>
              ),
            ),
            const SizedBox(width: 10),
            Text('Estado', style: Theme.of(context).textTheme.bodyMedium),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Wrap(
                // Wrap para tener varios filtros horizontales
                spacing: 8.0,
                children: _listaEstados.map(
                  (String opcion) {
                    // 2. Crear el FilterChip
                    return FilterChip(
                      label: Text(opcion),
                      selected: _opcionesEstadoSeleccionados.contains(
                        opcion,
                      ), // 3. Leer estado
                      // 4. Lógica de selección/deselección
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            _opcionesEstadoSeleccionados.add(
                              opcion,
                            ); // Agregar si se selecciona
                          } else {
                            _opcionesEstadoSeleccionados.remove(
                              opcion,
                            ); // Remover si se deselecciona
                          }
                          // Opcional: print(_opcionesSensoresSeleccionadas);
                        });
                      },
                    );
                  },
                ).toList(), // 5. Convertir el Iterable resultante a List<Widget>
              ),
            ),
            const SizedBox(width: 10),
            Center(
              child: FilledButton(
                onPressed: _aplicarFiltros,
                child: const Text('Aplicar filtros'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _aplicarFiltros() {
    Navigator.pop(context, {
      'tag': _tagController.text,
      'sensores': _opcionesSensoresSeleccionadas,
      'estados': _opcionesEstadoSeleccionados,
    });
  }

  InputDecoration _inputSearch() => InputDecoration(
    border: const OutlineInputBorder(),

    icon: IconButton(
      alignment: Alignment.bottomLeft,
      icon: Icon(Icons.search),
      onPressed: () {},
    ),
  );

  Widget _buildTextFormField(
    BuildContext context, {
    required String hintText,
    required TextEditingController controllerText,
    bool obscureText = false,
    FocusNode? focusNode,
  }) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Focus(
        onFocusChange: (hasFocus) {},
        child: TextFormField(
          focusNode: focusNode,
          controller: controllerText,
          obscureText: obscureText,
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
          decoration: _inputSearch(),
        ),
      ),
    );
  }
}
