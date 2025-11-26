import 'package:flutter/material.dart';

class FiltrosCalibracionesModal extends StatefulWidget {
  const FiltrosCalibracionesModal({super.key});

  @override
  State<FiltrosCalibracionesModal> createState() => _FiltrosCalibracionesModalState();
}

class _FiltrosCalibracionesModalState extends State<FiltrosCalibracionesModal> {
  DateTime? fecha_certificado;
  final TextEditingController _tagController = TextEditingController();
  final TextEditingController _certificadoController = TextEditingController();


  @override
  void initState() {
    super.initState();
    //_cargarSensores();
  }

  /*Future<void> _cargarSensores() async {
    final listaTipoSensores = await _tipoSensorService.obtenerAllTipoSensores();
    setState(() {
      _listaTipoSensores = listaTipoSensores;
    });
  }*/

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
            Text('Certificado', style: Theme.of(context).textTheme.bodyMedium),
            _buildTextFormField(
              context,
              hintText: "CERTIFICADO",
              controllerText: _certificadoController,
            ),
            const SizedBox(width: 10),
            ListTile(
              title: Text(fecha_certificado == null
                  ? 'Seleccionar Fecha de Inicio'
                  : 'Fecha de Inicio: ${fecha_certificado!.toLocal().toString().split(' ')[0]}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: _seleccionarFecha,
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

  Future<void> _seleccionarFecha() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fecha_certificado ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != fecha_certificado) {
      setState(() {
        fecha_certificado = picked;
      });
    }
  }

  void _aplicarFiltros() {
    Navigator.pop(context, {
      'tag': _tagController.text,
      'certificado': _certificadoController.text,
      'fecha_certificado': fecha_certificado,
      //'estados': _opcionesEstadoSeleccionados,
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
