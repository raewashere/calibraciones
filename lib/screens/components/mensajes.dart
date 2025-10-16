import 'package:flutter/material.dart';

class Mensajes extends StatelessWidget {
  const Mensajes({super.key});

  @override
  Widget build(BuildContext context) {
    return Table();
  }

  SnackBar ayuda(BuildContext context, String mensaje) {
    return SnackBar(
      content: Text(mensaje),
      duration: Duration(seconds: 5),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Theme.of(context).colorScheme.tertiary,
    );
  }

  SnackBar info(BuildContext context, String mensaje) {
    return SnackBar(
      content: Text(mensaje),
      duration: Duration(seconds: 5),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Theme.of(context).colorScheme.tertiary,
    );
  }

  SnackBar error(BuildContext context, String mensaje) {
    return SnackBar(
      content: Text(mensaje),
      duration: Duration(seconds: 5),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }
}
