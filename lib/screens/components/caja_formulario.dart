import 'package:flutter/material.dart';

class CajaFormulario extends StatelessWidget {
  const CajaFormulario({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }

  BoxDecoration boxDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).colorScheme.onPrimary,
      borderRadius: BorderRadius.circular(60),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1), // sombra sutil
          spreadRadius: 1,
          blurRadius: 8,
          offset: Offset(0, 4), // desplazada hacia abajo
        ),
      ],
      border: Border(
        bottom: BorderSide(
          color: Colors.grey.withOpacity(0.3), // línea suave
          width: 1,
        ),
      ),
    );
  }
}
