import 'package:flutter/material.dart';

class FiltrosCalibracionesModal extends StatefulWidget {
  const FiltrosCalibracionesModal({super.key});

  @override
  State<FiltrosCalibracionesModal> createState() =>
      _FiltrosCalibracionesModalState();
}

class _FiltrosCalibracionesModalState extends State<FiltrosCalibracionesModal> {
  DateTime? fechaCertificado;
  final TextEditingController _tagController = TextEditingController();
  final TextEditingController _certificadoController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
            Text('Certificado', style: Theme.of(context).textTheme.bodyMedium),
            _buildTextFormField(
              context,
              hintText: "CERTIFICADO",
              controllerText: _certificadoController,
            ),
            const SizedBox(width: 10),
            ListTile(
              title: Text(
                fechaCertificado == null
                    ? 'Seleccionar Fecha de Inicio'
                    : 'Fecha de Inicio: ${fechaCertificado!.toLocal().toString().split(' ')[0]}',
              ),
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
      initialDate: fechaCertificado ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != fechaCertificado) {
      setState(() {
        fechaCertificado = picked;
      });
    }
  }

  void _aplicarFiltros() {
    Navigator.pop(context, {
      'tag': _tagController.text,
      'certificado': _certificadoController.text,
      'fechaCertificado': fechaCertificado,
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
